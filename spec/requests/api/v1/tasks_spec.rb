# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :request do
  include_context 'shared setup'

  let(:base_endpoint)     { '/api/v1/tasks' }
  let(:resource_endpoint) { "#{base_endpoint}/#{task.id}" }

  let_it_be(:student) { create(:student, :group_supervisor, user: user) }
  let_it_be(:event)   { create(:event, eventable: student.group, creator: student) }

  let_it_be(:task) do
    create(:task, event: event, author: student)
  end

  let(:task_params) { build(:task_params) }

  let(:request_params) do
    { task: task_params.merge(event_id: event.id) }
  end

  let(:invalid_request_params) do
    { task: build(:invalid_task_params).merge(event_id: event.id) }
  end

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers, params: params }

    let(:params) { {} }

    let_it_be(:tasks) { create_list(:task, 2, event: event, author: student) }

    context 'N+1' do
      bulletify { subject }
    end

    before(:each) { subject }

    context 'when no filter or sort params are presented' do
      it 'is expected to respond with all tasks' do
        expect(response).to have_http_status(:ok)
        expect(json_data.count).to be(3)

        task_data = json_data.first

        expect(task_data['type']).to eq('task')
        expect(task_data['attributes'].keys).to(
          match_array(%w[title description extra_links outdated expired_at created_at updated_at])
        )
      end
    end

    context 'when event id filter is set' do
      let_it_be(:another_event) do
        create(:event, eventable: student.group, creator: student)
      end

      let_it_be(:another_task) do
        create(:task, event: another_event, author: student)
      end

      let_it_be(:params) do
        {
          filter: { event_id: another_event.id }
        }
      end

      it 'is expected to respond with tasks filtered by event id' do
        expect(response).to have_http_status(:ok)
        expect(json_data.count).to be(1)

        task_data = json_data.first

        expect(task_data['id']).to eq(another_task.id.to_s)
        expect(task_data['type']).to eq('task')
        expect(task_data['attributes'].keys).to(
          match_array(%w[title description extra_links outdated expired_at created_at updated_at])
        )
      end
    end

    context 'when expiration filter is set' do
      before do
        allow(Date).to receive(:current).and_return(Date.parse('2020-02-15'))
      end

      let_it_be(:outdated_task) do
        create(:task, :skip_validation, author: student, expired_at: '2020-02-10')
      end

      let_it_be(:params) do
        {
          filter: { expiration: 'outdated' }
        }
      end

      it 'is expected to respond with tasks filtered by outdated flag' do
        expect(response).to have_http_status(:ok)
        expect(json_data.count).to be(1)

        task_data = json_data.first

        expect(task_data['id']).to eq(outdated_task.id.to_s)
        expect(task_data['type']).to eq('task')
        expect(task_data['attributes'].keys).to(
          match_array(%w[title description extra_links outdated expired_at created_at updated_at])
        )
      end
    end

    context 'when accomplished filter is set' do
      let_it_be(:accomplished_task) do
        create(:task, :accomplished, author: student)
      end

      let_it_be(:params) do
        {
          filter: {
            accomplished: true
          }
        }
      end

      it 'is expected to respond with tasks filtered by accomplished flag' do
        expect(response).to have_http_status(:ok)
        expect(json_data.count).to be(1)

        task_data = json_data.first

        expect(task_data['id']).to eq(accomplished_task.id.to_s)
        expect(task_data['type']).to eq('task')
        expect(task_data['attributes'].keys).to(
          match_array(%w[title description extra_links outdated expired_at created_at updated_at])
        )
      end
    end
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before(:each) { subject }

    it 'is expected to respond with task entity' do
      expect(response).to have_http_status(:ok)
      expect(json_data['type']).to eq('task')
    end

    include_examples 'json:api examples',
                     %w[data included],
                     %w[id type attributes relationships],
                     %w[title description extra_links outdated expired_at created_at updated_at],
                     %w[event attachments]

    it 'returns requested task entity' do
      actual_title = json_data.dig(:attributes, :title)
      expected_title = task.title

      expect(actual_title).to eq(expected_title)
    end

    context 'when request params are not valid' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_assignment?" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'POST #create' do
    subject { post base_endpoint, params: request_params, headers: headers }

    let(:file) { fixture_file_upload('spec/fixtures/files/dk.png') }
    let(:metadata) { AttachmentUploader.new(:cache).upload(file) }

    let(:request_params) do
      params = task_params.merge(event_id: event.id, attachments: [metadata.to_json])

      { task: params }
    end

    before(:each) { subject }

    context 'when user is a group owner' do
      it 'returns created task entity' do
        expect(response).to have_http_status(:created)

        actual_title = json_data.dig(:attributes, :title)
        expected_title = task_params[:title]

        expect(actual_title).to eq(expected_title)
        expect(event.id.to_s).to eq(relationship_data(:event)[:id])
      end

      include_examples 'json:api examples',
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[title description extra_links outdated expired_at created_at updated_at],
                       %w[event attachments]

      include_examples 'request errors examples'
    end

    context 'when user is a regular group member' do
      let_it_be(:student) { create(:student, :group_member) }
      let_it_be(:token)   { create(:token, resource_owner_id: student.user.id) }

      it { expect(response).to have_http_status(:not_found) }

      context 'when group member create self assigned task' do
        let_it_be(:event)   { create(:event, eventable: student, creator: student) }

        let(:request_params) do
          params = task_params.merge(
            student_ids: [student.id],
            event_id: event.id,
            attachments: [metadata.to_json]
          )

          { task: params }
        end

        it 'returns created task entity' do
          expect(response).to have_http_status(:created)

          actual_title = json_data.dig(:attributes, :title)
          expected_title = task_params[:title]

          expect(actual_title).to eq(expected_title)
          expect(event.id.to_s).to eq(relationship_data(:event)[:id])
        end
      end
    end
  end

  describe 'PUT #update' do
    subject { put resource_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'when user is a group owner' do
      it 'updates a task model' do
        expect(response).to have_http_status(:ok)

        actual_title = task.reload.title
        expected_title = task_params[:title]

        expect(actual_title).to eq(expected_title)
        expect(event.id.to_s).to eq(relationship_data(:event)[:id])
      end

      include_examples 'json:api examples',
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[title description extra_links outdated expired_at created_at updated_at],
                       %w[event attachments]

      include_examples 'request errors examples'

      context 'when request params are not valid' do
        let(:resource_endpoint) { "#{base_endpoint}/wat_course?" }

        it { expect(response).to have_http_status(:not_found) }
      end
    end

    context 'when user is a regular group member' do
      let_it_be(:member)  { create(:student, group: student.group) }
      let_it_be(:token)   { create(:token, resource_owner_id: member.user.id) }

      it { expect(response).to have_http_status(:not_found) }

      context 'when group member updates self assigned task' do
        let_it_be(:event)   { create(:event, eventable: member, creator: member) }

        let_it_be(:task) do
          create(:task, event: event, author: member)
        end

        it 'returns updates task entity' do
          expect(response).to have_http_status(:ok)

          actual_title = task.reload.title
          expected_title = task_params[:title]

          expect(actual_title).to eq(expected_title)
          expect(event.id.to_s).to eq(relationship_data(:event)[:id])
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is a group owner' do
      it 'responds with a 204 status' do
        delete resource_endpoint, headers: headers

        expect(response).to have_http_status(:no_content)
      end

      it 'responds with a 404 status not existed task' do
        delete "#{base_endpoint}/0", headers: headers

        expect(response).to have_http_status(:not_found)
      end

      it 'deletes task' do
        expect { delete resource_endpoint, headers: headers }.to change(Task, :count).by(-1)
      end
    end

    context 'when user is a regular group member' do
      let_it_be(:member)  { create(:student, group: student.group) }
      let_it_be(:token)   { create(:token, resource_owner_id: member.user.id) }

      it 'responds with 403 - forbidden' do
        delete resource_endpoint, headers: headers

        expect(response).to have_http_status(:not_found)
      end

      context 'when group member deletes self assigned task' do
        let_it_be(:event)   { create(:event, eventable: member, creator: member) }

        let_it_be(:task) do
          create(:task, event: event, author: member)
        end

        it { expect { delete resource_endpoint, headers: headers }.to change(Task, :count).by(-1) }
      end
    end
  end
end
