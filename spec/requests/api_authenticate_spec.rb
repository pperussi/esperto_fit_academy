require 'rails_helper'

describe 'API recive request' do
  it 'and authorizes' do
    create(:gym)
    headers = {'Accept'=>'*/*',
    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    'Content-Type'=>'application/json',
    'Password'=>'eyJhbGciOiJIUzI1NiJ9.IidFc3BlcnRvRml0R3ltJyI.u6afO6F22Hbx32vL2uefWXI1rEj_iYIFUHdeG22sRD0',
    'User-Agent'=>'Faraday v0.17.0'}

    get '/api/v1/gyms', headers: headers

    expect(response.status).to eq 200
    expect(response.body).to include 'Av Paulista 111'
  end

  it 'and authorizes but it is empty' do
    headers = {'Accept'=>'*/*',
    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    'Content-Type'=>'application/json',
    'Password'=>'eyJhbGciOiJIUzI1NiJ9.IidFc3BlcnRvRml0R3ltJyI.u6afO6F22Hbx32vL2uefWXI1rEj_iYIFUHdeG22sRD0',
    'User-Agent'=>'Faraday v0.17.0'}

    get '/api/v1/gyms', headers: headers

    expect(response.status).to eq 200
    expect(response.body).to include 'Nenhuma unidade cadastrada'
  end

  it 'and does not authorizes' do
    create(:gym)
    headers = {'Accept'=>'*/*',
    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    'Content-Type'=>'application/json',
    'Password'=>'eyJhbGciOiJIUzI1NiJ9.InNlbmhhaCI.2XvmeP1zL4df23yROAFDUw9yFEtnpiWXRIDB2NRzaP8',
    'User-Agent'=>'Faraday v0.17.0'}

    get '/api/v1/gyms', headers: headers

    expect(response.status).to eq 401
    expect(response.body).not_to include 'Av Paulista 111'
    expect(response.body).to include 'unauthorized'
  end
end