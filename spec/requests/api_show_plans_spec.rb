require 'rails_helper'

describe 'api shoe plans' do
  it 'successfully show all' do
    user = create(:employee, admin: true)
    headers = user_header(user)
    params = { email: user.email, password: user.password }
    plan_basic = create(:plan, name: 'Básico', minimum_permanence: 12)
    plan_plus = create(:plan, name: 'Plus', minimum_permanence: 3)

    get api_v1_show_all_plans_path, headers: headers, params: params

    JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq 200
    expect(response.body).to include(plan_basic.name)
    expect(response.body).to include('12')
    expect(response.body).to include(plan_plus.name)
    expect(response.body).to include('3')
  end

  it 'fails to find plans' do
    user = create(:employee, admin: true)
    headers = user_header(user)
    params = { email: user.email, password: user.password }

    get api_v1_plans_path, headers: headers, params: params

    JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 404
    expect(response.body).to include('Nenhum plano cadastrado')
  end

  it 'successfully find one plan' do
    user = create(:employee, admin: true)
    headers = user_header(user)
    params = { email: user.email, password: user.password }

    plan_basic = create(:plan, name: 'Básico', minimum_permanence: 12)
    plan_plus = create(:plan, name: 'Plus', minimum_permanence: 3)

    get api_v1_plan_path(plan_basic.id), headers: headers, params: params

    JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 200
    expect(response.body).to include(plan_basic.name)
    expect(response.body).to include('12')
    expect(response.body).not_to include(plan_plus.name)
  end

  it 'fails to find one plan' do
    user = create(:employee, admin: true)
    headers = user_header(user)
    params = { email: user.email, password: user.password }

    get api_v1_plan_path(10), headers: headers, params: params

    JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 404
    expect(response.body).to include('Nenhum plano encontrado')
  end
end
