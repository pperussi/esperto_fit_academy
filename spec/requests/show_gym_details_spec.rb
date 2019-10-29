require 'rails_helper'

describe 'show gym details ' do
  it 'sucessfully' do
    user = create(:employee, admin: true)
    headers = user_header(user)
    params = { email: user.email, password: user.password }
    
    gym = create(:gym)

    get "/api/v1/gyms/#{gym.id}", headers: headers, params: params
    json_gym = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 200
    expect(json_gym[:gym][:cod]).to eq gym.cod
    expect(json_gym[:gym][:open_hour]).to eq gym.open_hour
    expect(json_gym[:gym][:close_hour]).to eq gym.close_hour
    expect(json_gym[:gym][:working_days]).to eq gym.working_days
    expect(json_gym[:gym][:address]).to eq gym.address
    expect(json_gym[:gym][:images].first).to include '/academia_01.jpeg'
  end

  it 'returns an error if the gym is not found' do
    user = create(:employee, admin: true)
    headers = user_header(user)
    params = { email: user.email, password: user.password }
    
    get '/api/v1/gyms/1111', headers: headers, params: params
    json_gym = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 404
    expect(json_gym[:message]).to eq 'Academia não encontrada'
  end
end
