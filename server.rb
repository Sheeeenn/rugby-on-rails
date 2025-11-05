require 'webrick'

server = WEBrick::HTTPServer.new(
  Port: 3000,
  DocumentRoot: Dir.pwd
)

server.mount_proc '/' do |req, res|
  res.body = "1Welcome to Rugby on Rails (plain Ruby web server)"
end

trap('INT') { server.shutdown }

server.start
