require 'socket'
require 'http/parser'
require 'stringio'
require 'thread'
require 'eventmachine'

class Tube
  def initialize(port, app)
    @server = TCPServer.new(port)
    @app = app
  end

  def prefork(workers)
    workers.times do
      fork do
        puts "Forked #{Process.pid}"
        start
      end
    end
    Process.waitall
  end

   def start
    loop do
      socket = @server.accept
      Thread.new do
        connection = Connection.new(socket, @app)
        connection.process
      end
    end
  end

  class Connection
    def initialize(socket, app)
      @socket = socket
      @app = app
      @parser = Http::Parser.new(self)
    end

    def process
      until @socket.closed? || @socket.eof?
        data = @socket.readpartial(1024)
        @parser << data
        puts data
      end
    end

    def on_message_complete
      puts "#{@parser.http_method} #{@parser.request_url}"
      puts "  " + @parser.headers.inspect
      puts

      env = {}
      @parser.headers.each_pair do |name, value|
        name = "HTTP_" + name.upcase.tr("-", "_")
        env[name] = value
      end
      env["PATH_INFO"] = @parser.request_url
      env["REQUEST_METHOD"] = @parser.http_method
      env["rack.input"] = StringIO.new

      send_response env
    end

    REASONS = {
      200 => "OK",
      404 => "Not Found"
    }


    def send_response(env)
      status, headers, body = @app.call(env)
      reason = REASONS[status]

      @socket.write "HTTP/1.1 #{status} #{reason}\r\n"
      headers.each_pair do |name, value|
        @socket.write "#{name}: #{value}\r\n"
      end
      @socket.write "\r\n"
      body.each do |chunk|
        @socket.write chunk
      end
      body.close if body.respond_to? :close

      close
    end

    def close
      @socket.close
    end
  end #Connection

  class Builder
    attr_reader :app

    def run(app)
      @app = app
    end

    def self.parse_file(file)
      content = File.read(file)
      builder = self.new
      builder.instance_eval(content)
      builder.app
    end

  end #Builder
end

app = Tube::Builder.parse_file("config.ru")

server = Tube.new(3000, app)
puts "Plugging tube into port 3000"
server.prefork 3
# server.start
