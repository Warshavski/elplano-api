# frozen_string_literal: true

RSpec.shared_examples 'admin user management' do
  let_it_be(:log_message) do
    "User - \"#{user.username}\" (#{user.email}) was \"#{action}\" " \
          " by \"#{admin.username}\" (#{admin.email})"
  end

  it 'is expected to log management action' do
    expect(instance).to receive(:log_info).with(log_message).once

    subject
  end
end
