Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_drop_ship'
  s.version     = '3.0.1.beta'
  s.summary     = 'Spree Drop Shipping Extension'
  s.description = 'Adds drop shipping functionality to Spree stores.'
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Jeff Dutil'
  s.email     = 'JDutil@BurlingtonWebApps.com'
  s.homepage  = 'http://github.com/JDutil/spree_drop_ship'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'


  s.add_dependency 'spree_api',      '>= 3.1.0', '< 4.0'
  s.add_dependency 'spree_backend',  '>= 3.1.0', '< 4.0'
  s.add_dependency 'spree_core',     '>= 3.1.0', '< 4.0'
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'mysql2', '~> 0.3.18'
  s.add_development_dependency 'pg' , '~> 0.18'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'spree_auth_devise'
  s.add_development_dependency 'spree_sample'
  s.add_development_dependency 'sqlite3'
end
