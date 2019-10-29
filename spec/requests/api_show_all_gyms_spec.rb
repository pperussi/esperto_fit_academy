require 'rails_helper'

describe 'api show all gyms' do
  it 'successfully' do
    user = create(:employee, admin: true)
    headers = user_header(user)
    params = { email: user.email, password: user.password }

    # arrange all gyms
    gym = create(:gym, name: 'Vila Mariana')
    another_gym = create(:gym, name: 'Vila Madalena')

    # act

    get api_v1_gyms_path, headers: headers, params: params

    json_gyms = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 200
    expect(json_gyms[1][:name]).to eq gym.name
    expect(json_gyms[2][:name]).to eq another_gym.name
  end

  it 'fails' do
    user = create(:employee, gym: nil, admin: true)
    headers = user_header(user)
    params = { email: user.email, password: user.password }

    get api_v1_gyms_path, headers: headers, params: params

    json_gyms = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 200
    expect(json_gyms[:messages]).to eq 'Nenhuma unidade cadastrada'
  end
end
