# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :request do
  include_context 'shared setup'

  let(:base_endpoint)     { '/api/v1/events' }
  let(:resource_endpoint) { "#{base_endpoint}/#{event.id}" }

  let_it_be(:student) { create(:student, :group_member, user: user) }

  let_it_be(:event) do
    create(:event, title: 'some_new_event', creator: student, eventable: student)
  end

  let(:event_params)  { build(:event_params).merge(eventable_id: student.id) }

  let(:request_params) { { event: event_params } }
  let(:invalid_request_params) { { event: build(:invalid_event_params) } }

  let_it_be(:labels) { create_list(:label, 2, group: student.group) }

  let_it_be(:label_ids) { labels.map(&:id) }

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers, params: params }

    let_it_be(:president) do
      create(:student, :group_supervisor, group: student.group)
    end

    let_it_be(:events) do
      create_list(:event, 2, creator: president, eventable: student)
    end

    let_it_be(:labeled_event) do
      create(:event, creator: president, eventable: student, labels: labels)
    end

    context 'N+1' do
      let(:params) { {} }

      bulletify { subject }
    end

    context 'collection filtering' do
      before(:each) { subject }

      context 'when no filter params are provided' do
        let(:params) { {} }

        it 'is expected to respond with all events' do
          expect(response).to have_http_status(:ok)
          expect(json_data.count).to be(4)
        end
      end

      context 'when type filter param is provided' do
        let(:params) do
          {
            filter: { type: 'group' }
          }
        end

        it 'is expected to respond with events filtered by type' do
          expect(response).to have_http_status(:ok)
          expect(json_data.count).to be(0)
        end
      end

      context 'when scope filter param is provided' do
        let(:params) do
          {
            filter: { scope: 'authored' }
          }
        end

        it 'is expected to respond with events filtered by scope' do
          expect(response).to have_http_status(:ok)
          expect(json_data.count).to be(1)
        end
      end

      context 'when scope filter param is provided' do
        let(:params) do
          {
            filter: { labels: labels.map(&:id).join(',') }
          }
        end

        it 'is expected to respond with events filtered by label' do
          expect(response).to have_http_status(:ok)
          expect(json_data.count).to be(1)
          expect(json_data.first['id']).to eq(labeled_event.id.to_s)
        end
      end
    end
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(json_data['type']).to eq('event') }

    include_examples 'json:api examples',
                     %w[data included],
                     %w[id type attributes relationships],
                     %w[title description background_color foreground_color status start_at end_at timezone recurrence created_at updated_at],
                     %w[creator course eventable labels]

    it 'returns correct expected data' do
      actual_title = json_data.dig(:attributes, :title)
      expected_title = event.title

      expect(actual_title).to eq(expected_title)
    end

    context 'when request params are not valid' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_event?" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'POST #create' do
    subject { post base_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    it 'is expected to respond with created event' do
      expect(response).to have_http_status(:created)
      expect(json_data['type']).to eq('event')

      actual_title = json_data.dig(:attributes, :title)
      expected_title = event_params[:title]

      expect(actual_title).to eq(expected_title)
    end

    include_examples 'json:api examples',
                     %w[data included],
                     %w[id type attributes relationships],
                     %w[title description background_color foreground_color status start_at end_at timezone recurrence created_at updated_at],
                     %w[creator course eventable labels]

    include_examples 'request errors examples'

    context 'when the event is created with reference to the course' do
      let_it_be(:course) { create(:course, group: student.group) }

      let(:event_params) do
        build(:event_params).merge(course_id: course.id, eventable_id: student.id)
      end

      it 'returns created model with bound course' do
        expect(response).to have_http_status(:created)

        actual_course_id = relationship_data(:course)[:id].to_i

        expect(actual_course_id).to eq(course.id)
      end
    end

    context 'when the event is created with reference to the labels' do
      let(:event_params) do
        build(:event_params).merge(label_ids: label_ids, eventable_id: student.id)
      end

      it 'returns created model with attached labels' do
        expect(response).to have_http_status(:created)

        actual_label_ids = relationship_data(:labels).map { |r| r[:id].to_i }
        expect(actual_label_ids).to match_array(label_ids)
      end
    end
  end

  describe 'PUT #update' do
    subject { put resource_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    it 'is expected to update event and respond with updated event' do
      expect(response).to have_http_status(:ok)
      expect(json_data['type']).to eq('event')

      actual_title = event.reload.title
      expected_title = event_params[:title]

      expect(actual_title).to eq(expected_title)
    end

    include_examples 'json:api examples',
                     %w[data included],
                     %w[id type attributes relationships],
                     %w[title description background_color foreground_color status start_at end_at timezone recurrence created_at updated_at],
                     %w[creator course eventable labels]

    include_examples 'request errors examples'

    context 'when the event is updated with reference to the course' do
      let_it_be(:course) { create(:course, group: student.group) }

      let(:event_params) do
        build(:event_params).merge(course_id: course.id)
      end

      it 'return created model with bound course' do
        actual_course_id = relationship_data(:course)[:id].to_i

        expect(actual_course_id).to eq(course.id)
      end
    end

    context 'when the event is updated with reference to the labels' do
      let(:event_params) do
        build(:event_params).merge(label_ids: label_ids, eventable_id: student.id)
      end

      it 'returns created model with attached labels' do
        expect(response).to have_http_status(:ok)

        actual_label_ids = relationship_data(:labels).map { |r| r[:id].to_i }
        expect(actual_label_ids).to eq(label_ids)
      end
    end

    context 'when request params are not valid' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_event?" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with a 204 status' do
      delete resource_endpoint, headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it 'responds with a 404 status not existed event' do
      delete "#{base_endpoint}/wat_event?", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes event' do
      expect { delete resource_endpoint, headers: headers }.to change(Event, :count).by(-1)
    end
  end
end
