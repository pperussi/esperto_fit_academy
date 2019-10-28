require 'rails_helper'

describe 'API consult CPF' do
  it 'successfully' do
    # arrange
    headers = new_header
    client = create(:client, cpf: '12312312300', status: :banished)

    # act
    get "/api/v1/clients/consult_cpf/#{client.cpf}", headers: headers

    # assert
    expect(response.status).to eq 302
    expect(response.body).to include(client.cpf)
    expect(response.body).to include(client.status)
    expect(response.body).not_to include(client.name)
  end

  it 'and CPF must exit' do
    # act
    headers = new_header
    get '/api/v1/clients/consult_cpf/000', headers: headers

    # assert
    expect(response.status).to eq 404
    expect(response.body).to include('CPF não encontrado')
  end
end
