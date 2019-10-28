class PersonalConnection < ApiConnection
  def self.endpoint
    Rails.configuration.esperto_fit_personal[:base_url]
  end
end