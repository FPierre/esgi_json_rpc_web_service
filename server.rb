require 'xmlrpc/server'

server = XMLRPC::Server.new 1234

server.add_handler('my_test.test') { |msg| "response for #{msg}" }

server.serve
