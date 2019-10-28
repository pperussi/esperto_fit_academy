require 'rails_helper'

describe 'api send registration data' do
	it 'successfully' do
		# arrange
		headers = new_header
		client = create(:client, cpf: '12312312300')

		# act
		post "/api/v1/clients/#{client.cpf}", headers: headers
		json_client = JSON.parse(response.body, symbolize_names: true)
		
		# assert
		expect(response.status).to eq 302
		expect(json_client[:name]).to eq client.name
		expect(json_client[:email]).to eq client.email
		expect(json_client[:status]).to eq client.status
		expect(json_client[:cpf]).to eq client.cpf
	end
	
	it 'and return message if client not found' do
		# arrange
		headers = new_header
		client = create(:client)

		# act
		post "/api/v1/clients/00000000", headers: headers

		# assert
		expect(response.status).to eq 404
		expect(response.body).to include('Cliente não encontrado')
	end
end