# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :password,
  :card_number,
  :card_cvv,
  :card_holder_name,
  :card_expiration_date,
  :card_holder_uf,
  :card_holder_street_number,
  :card_holder_city,
  :card_holder_neighborhood,
  :card_holder_zipcode
]
