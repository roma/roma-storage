require 'test/unit'

if ENV['CI']
  require 'simplecov'

  SimpleCov.start do
    add_filter '/test/'
  end
end
