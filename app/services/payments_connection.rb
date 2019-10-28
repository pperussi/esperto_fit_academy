class PaymentsConnection < ApiConnection
  def self.endpoint
    Rails.configuration.esperto_fit_payment[:payment_url]
  end
end