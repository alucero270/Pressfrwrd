source 'https://rubygems.org'
ruby '2.0.0'

gem 'minitest'
gem 'rails', '~> 4.2.0'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'bcrypt', '~> 3.1.9'
gem 'faker', '~> 1.4.3'

gem 'kaminari', '~> 0.16.1'
gem 'kaminari-bootstrap', '~> 3.0.1'

gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 4.0.2'
gem 'turbolinks', '~> 2.5.3'
gem 'jbuilder', '~> 2.2.6'

gem 'acts-as-taggable-on'
gem 'twitter-text'

gem 'paperclip'
gem 'aws-sdk'

gem 'unicorn'

group :development do
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'byebug'
  gem 'sqlite3', '~> 1.3.10'
  gem 'rspec-rails', '~> 3.1.0'
end

group :test do
  gem 'spring-commands-rspec'
  gem 'guard-rspec', '4.5.0'
end
gem 'newrelic_rpm'
gem 'sass-rails', '~> 5.0.0'
gem 'uglifier', '~> 2.6.0'

def platform_is_darwin?
  true # `uname` =~ /Darwin/
end

group :test do
  gem 'selenium-webdriver', '~> 2.44.0'
  gem 'capybara', '~> 2.4.4'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'cucumber-rails', '~> 1.4.2', require: false
  gem 'database_cleaner', '~> 1.3.0'

  # Uncomment this line on OS X.
  if platform_is_darwin?
    gem 'growl', '~> 1.0.3', require: false
  end

  # Uncomment these lines on Linux.
  # gem 'libnotify', '0.8.0'

  # Uncomment these lines on Windows.
  # gem 'rb-notifu', '0.0.4'
  # gem 'win32console', '1.3.2'
  # gem 'wdm', '0.1.0'
end

group :doc do
  gem 'sdoc', '~> 0.4.1', require: false
end


gem 'pg', '0.17.1'
gem 'pg_search', '~> 0.7.8'
group :production do
  gem 'rails_12factor', '0.0.3'
end
