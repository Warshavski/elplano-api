RSpec.shared_examples 'json:api examples' do |root, body, attributes, relationships|
  it 'responds with root json-api keys' do
    expect(body_as_json.keys).to match_array(root)
  end

  it { expect(response.body).to look_like_json }

  it 'responds with json-api format' do
    actual_keys = body_as_json[:data].keys

    expect(actual_keys).to match_array(body)
  end

  it 'responds with correct relationships' do
    actual_keys = body_as_json[:data][:relationships].keys

    expect(actual_keys).to match_array(relationships)
  end

  it 'returns correct data format' do
    actual_keys = body_as_json[:data][:attributes].keys

    expect(actual_keys).to match_array(attributes)
  end
end
