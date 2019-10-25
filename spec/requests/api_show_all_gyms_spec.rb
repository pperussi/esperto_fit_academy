require 'rails_helper'

describe 'api show all gyms' do
  it 'successfully' do
    headers = new_header

    # arrange all gyms
    gym = create(:gym)
    another_gym = create(:gym)

    # act

    get api_v1_gyms_path, :headers => headers

    json_gyms = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 200
    # byebug
    expect(json_gyms[1][:name]).to eq gym.name
    expect(json_gyms[2][:name]).to eq another_gym.name
  end

  it 'fails' do
    employee = create(:employee, gym: nil, admin: true)
    headers = user_header(employee)

    get api_v1_gyms_path, :headers => headers

    json_gyms = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 200
    expect(json_gyms[:messages]).to eq 'Nenhuma unidade cadastrada'
  end
end
