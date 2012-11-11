if ENV['COVERAGE']
  begin
    require 'simplecov'
    SimpleCov.start
  rescue LoadError
    puts 'SimpleCov not loaded!'
  end
end

require 'minitest/autorun'

Thread.abort_on_exception = true
