if Rails.env.development?
  Rails.configuration.pagarme = {
    api_key: ENV['PAGARME_SANDBOX_API_KEY'],
    cripto_key: ENV['PAGARME_SANDBOX_CRIPTO_KEY']
  }
else
  Rails.configuration.pagarme = {
    api_key: ENV['PAGARME_API_KEY'],
    cripto_key: ENV['PAGARME_CRIPTO_KEY']
  }
end
# Pagarme.api_key = Rails.configuration.stripe[:secret_key]
