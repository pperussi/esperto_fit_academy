module HeaderGenerator
    def new_header
        user = create(:employee)
        payload = {
            user_id: user.id, token_type: 'client_a2', exp: 4.hours.from_now.to_i,
            }
        token = Auth.issue(payload)
        headers = {
            "Token" => token,
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Content-Type" => "application/json"
            }
        return headers
        
    end

    def user_header(user)
        payload = {
            user_id: user.id, token_type: 'client_a2', exp: 4.hours.from_now.to_i,
            }
        token = Auth.issue(payload)
        headers = {
            "Token" => token,
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Content-Type" => "application/json"
            }
        return headers
    end
end