require 'rails_helper'

describe 'only admin can delete gym' do
  it 'susscessfully' do
    gym = create(:gym)
    user = create(:employee, admin: true)
    headers = user_header(user)
    params = { email: user.email, password: user.password }
    sign_in user

    delete "/api/v1/gyms/#{gym.id}", headers: headers, params: params.to_json

    json_gym = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 202
    expect(json_gym[:msg]).to include('Academia apagada com sucesso')
  end

  it 'and employees can not' do
    gym = create(:gym)
    user = create(:employee)
    headers = user_header(user)
    params = { email: user.email, password: user.password }
    sign_in user

    delete "/api/v1/gyms/#{gym.id}", headers: headers, params: params.to_json

    json_gym = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 412
    expect(json_gym[:msg]).to include('Você não tem essa permissão')
  end
end
