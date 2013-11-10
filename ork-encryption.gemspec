Gem::Specification.new do |s|
  s.name        = 'ork-encryption'
  s.version     = '0.0.1'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'Ruby modeling layer for Riak.'
  s.summary     = 'A simple encryption library for Ork::Documents stored in riak.'
  s.description = 'Ork is a small Ruby modeling layer for Riak, inspired by Ohm.'
  s.description = 'Encrypt documents persisted on Riak DB. Inspired in ripple-encryption'
  s.authors     = ['Emiliano Mancuso']
  s.email       = ['emiliano.mancuso@gmail.com']
  s.homepage    = 'http://github.com/emancu/ork-encryption'
  s.license     = 'MIT'

  s.files = Dir[
    'README.md',
    'rakefile',
    'lib/**/*.rb',
    '*.gemspec'
  ]
  s.test_files = Dir['test/*.*']

  s.add_dependency 'riak-client'
  s.add_dependency 'ork', "~> 0.1.1"
  s.add_development_dependency 'protest'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'coveralls'
end

