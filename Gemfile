source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Export to Excel
gem 'rubyzip'
gem 'axlsx'
gem 'axlsx_rails'
gem 'rails_admin', '~> 2.0'
gem 'rails', '~> 5.1.6'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-sass'
gem 'font-awesome-sass', '~> 5.8.1'
gem "font-awesome-rails"
gem 'simple_form'
gem 'autoprefixer-rails'
gem 'jquery-rails'
gem 'devise'
gem 'money-rails', '~>1.12'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'slim'
gem 'carrierwave', '~> 1.2'
gem 'dotenv-rails', groups: [:development, :test]
gem 'cloudinary', '~> 1.9.1'
gem 'trix'
gem "pagseguro-oficial", "~> 2.5.0"
gem "geocoder"
gem 'stripe'
gem 'autocomplete_zipcode'
gem 'rails-i18n'
gem 'devise-i18n'
gem 'correios-cep'
gem 'httparty'
gem 'sidekiq'
gem 'sidekiq-failures', '~> 1.0'
gem 'postmark-rails'
gem 'letter_opener', group: :development
gem 'pagarme'
gem 'webpacker', '~> 4.0'
gem "puma_worker_killer"
gem 'simplecov', require: false, group: :test
gem 'twilio-ruby', '~> 5.33.1'
gem 'sassc-rails', '>= 2.1.0'
gem 'derailed', group: :development
gem "sentry-raven"
gem 'stripe_event'
gem 'pg_search', '~> 2.3.0'
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
