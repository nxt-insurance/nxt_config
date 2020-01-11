source "https://rubygems.org"

# Specify your gem's dependencies in nxt_config.gemspec
gemspec

gem "rake", "~> 12.0"
gem "rspec", "~> 3.0"

group :development do
  gem "guard-rspec", require: false
end

group :test do
  gem "rspec_junit_formatter" # for CircleCI
end
