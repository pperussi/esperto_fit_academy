require 'rails_helper'

describe 'API recive request' do
  it 'and authorizes' do
    create(:gym)
    user = create(:employee, admin: true)
    headers = user_header(user)
    params = { email: user.email, password: user.password }

    get '/api/v1/gyms', headers: headers, params: params

    expect(response.status).to eq 200
    expect(response.body).to include 'Av Paulista 111'
  end

  it 'and authorizes but it is empty' do
    user = create(:employee, gym: nil, admin: true)
    headers = user_header(user)
    params = { email: user.email, password: user.password }

    get '/api/v1/gyms', headers: headers, params: params
    # byebug

    expect(response.status).to eq 200
    expect(response.body).to include 'Nenhuma unidade cadastrada'
  end

  it 'and does not authorizes' do
    create(:gym)
    user = create(:employee, admin: true)
    params = { email: user.email, password: user.password }
    headers = { 'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type' => 'application/json',
                'Token' => 'a',
                'User-Agent' => 'Faraday v0.17.0' }

    get '/api/v1/gyms', headers: headers, params: params.to_json

    expect(response.status).to eq 401
    expect(response.body).not_to include 'Av Paulista 111'
    expect(response.body).to include 'Authentication error, invalid payload.'
  end

  it 'and token is expired' do
    create(:gym)
    user = create(:employee)
    params = { email: user.email, password: user.password }
    token = Auth.issue(user_id: user.id, token_type: 'client_a2', exp: 1_572_299_394)
    headers = { 'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type' => 'application/json',
                'Token' => token,
                'User-Agent' => 'Faraday v0.17.0' }

    get '/api/v1/gyms', headers: headers, params: params.to_json

    expect(response.status).to eq 401
    expect(response.body).to include 'Authentication error, token has been expired.'
  end

  it 'and token is WRONG' do
    create(:gym)
    user = create(:employee)
    params = { email: user.email, password: user.password }
    payload = {
      user_id: user.id, token_type: 'client_a3', exp: 4.hours.from_now.to_i
    }
    token = Auth.issue(payload)
    headers = {
      'Token' => token,
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type' => 'application/json'
    }

    get '/api/v1/gyms', headers: headers, params: params.to_json

    expect(response.status).to eq 401
    expect(response.body).to include 'Authentication error, token is wrong on header Authentication' 
  end

  it 'and token is missing' do
    create(:gym)
    user = create(:employee)
    params = { email: user.email, password: user.password }
    headers = {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type' => 'application/json'
    }

    get '/api/v1/gyms', headers: headers, params: params.to_json

    expect(response.status).to eq 401
    expect(response.body).to include 'Authentication error, missing token.' 
  end

  it 'and password is wrong' do
    create(:gym)
    user = create(:employee)
    params = { email: user.email, password: 'banana' }
    payload = {
      user_id: user.id, token_type: 'client_a2', exp: 4.hours.from_now.to_i
    }
    token = Auth.issue(payload)
    headers = {
      'Token' => token,
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type' => 'application/json'
    }

    get '/api/v1/gyms', headers: headers, params: params

    expect(response.status).to eq 401
    expect(response.body).to include 'Wrong email or password, please try again.' 
  end

  it 'and should provide email and password' do
    create(:gym)
    user = create(:employee)
    payload = {
      user_id: user.id, token_type: 'client_a2', exp: 4.hours.from_now.to_i
    }
    token = Auth.issue(payload)
    headers = {
      'Token' => token,
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type' => 'application/json'
    }

    get '/api/v1/gyms', headers: headers

    expect(response.status).to eq 401
    expect(response.body).to include 'Missing necessary params.' 
  end
  

  
end