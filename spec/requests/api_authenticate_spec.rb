require 'rails_helper'

describe 'API recive request' do
  it 'and authorizes' do
    headers = new_header
    create(:gym)

    get '/api/v1/gyms', headers: headers

    expect(response.status).to eq 200
    expect(response.body).to include 'Av Paulista 111'
  end

  it 'and authorizes but it is empty' do
    employee = create(:employee, gym: nil, admin: true)
    headers = user_header(employee)

    get '/api/v1/gyms', headers: headers

    expect(response.status).to eq 200
    expect(response.body).to include 'Nenhuma unidade cadastrada'
  end

  it 'and does not authorizes' do
    create(:gym)
    headers = { 'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type' => 'application/json',
                'Token' => 'eyJhbGciOiJIUzI1NiJ9.InNlbmhhaCI.2XvmeP1zL4df23yROAFDUw9yFEtnpiWXRIDB2NRzaP8',
                'User-Agent' => 'Faraday v0.17.0' }

    get '/api/v1/gyms', headers: headers

    expect(response.status).to eq 401
    expect(response.body).not_to include 'Av Paulista 111'
    expect(response.body).to include 'Authentication error, invalid payload.'
  end
end