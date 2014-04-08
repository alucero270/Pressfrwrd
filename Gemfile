source 'https://rubygems.org'

gem 'minitest'
gem 'rails', '4.1.0.rc2'
gem 'bootstrap-sass', '2.1'
gem 'bcrypt', '3.1.7'
gem 'faker', '1.0.1'

gem 'kaminari', '~> 0.15.1'
gem 'kaminari-bootstrap', '~> 0.1.3'

#gem 'will_paginate', '3.0.5'
#gem 'bootstrap-will_paginate', '0.0.6'

gem 'jquery-rails', '2.0.2'

# for rails 4 (TODO remove attr_protected/attr_accessible)
gem 'protected_attributes'

# fulltext search
#gem 'sunspot_rails'

group :development, :test do
  gem 'sqlite3', '~> 1.3.9'
  gem 'spring-commands-rspec'
  gem 'rspec-rails', '2.14.2'
  gem 'guard-rspec', '1.2.1'
  gem 'guard-spork', '1.5.1'
  gem 'childprocess', '0.5.2'
  gem 'spork', '1.0.0rc4'
end

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails','4.0.1', :git => 'git://github.com/rails/sass-rails.git'
gem 'coffee-rails'
gem 'uglifier', '1.2.3'

group :test do
  gem 'capybara', '1.1.2'
  gem 'factory_girl_rails', '4.1.0'
  gem 'cucumber-rails', '~> 1.4.0'
  gem 'database_cleaner', '~> 1.2.0'
  # gem 'launchy', '2.1.0'
  # gem 'rb-fsevent', '0.9.1', :require => false
  # gem 'growl', '1.0.3'
end

group :production do
  gem 'pg', '0.12.2'
end
