lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'worker_pool/version'

Gem::Specification.new do |gem|
  gem.name = 'worker_pool'
  gem.version = WorkerPool::VERSION
  gem.authors = [ 'Sebastian Ohm' ]
  gem.email = [ 'ohm.sebastian@gmail.com' ]
  gem.homepage = 'http://github.com/ohm/worker_pool'
  gem.summary = 'Simple worker pool for (synchronized) concurrent task execution'
  gem.files = `git ls-files`.split($/)
  gem.test_files = gem.files.grep(%r{\Atest/})
  gem.require_paths = [ 'lib' ]
  gem.add_development_dependency('simplecov')
  gem.required_ruby_version = '>= 1.9'
end
