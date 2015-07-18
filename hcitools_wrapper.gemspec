Gem::Specification.new do |s|
  s.name = 'hcitools_wrapper'
  s.version = '0.1.1'
  s.summary = 'Uses hcitool lescan + hcidump --r to fetch the RSSI values from a Bluetooth device address.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/hcitools_wrapper.rb']
  s.add_runtime_dependency('run_every', '~> 0.1', '>=0.1.9')
  s.signing_key = '../privatekeys/hcitools_wrapper.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/hcitools_wrapper'
end
