# frozen_string_literal: true

source "https://rubygems.org"

ruby ">=2.7.1"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "sinatra"
gem "sinatra-contrib"
gem "thin"
gem "haversine"

group :test do
  gem "minitest", require: "minitest/autorun"
  gem "webmock", require: "webmock/minitest"
  gem "vcr"
end
