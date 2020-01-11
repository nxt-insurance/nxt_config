source "https://rubygems.org"

# Specify your gem's dependencies in nxt_config.gemspec
gemspec

gem "rake"
gem "rspec"

group :development do
  gem "guard-rspec", require: false
end

group :test do
  gem "rspec_junit_formatter" # for CircleCI
end
