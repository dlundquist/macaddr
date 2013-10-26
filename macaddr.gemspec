Gem::Specification.new do |s|
    s.name        = 'macaddr'
    s.version     = `git describe --tags`
    s.date        = Time.now
    s.summary     = "MACAddr"
    s.description = "MAC Address"
    s.authors     = ["Dustin Lundquist"]
    s.email       = 'dustin@null-ptr.net'
    s.files       = ["lib/macaddr.rb"]
    s.homepage    = 'http://github.com/dlundquist/macaddr'
end
