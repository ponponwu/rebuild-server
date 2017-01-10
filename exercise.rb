require './lib/simple_server'
require 'socket'
require 'pry'
require 'pry-byebug'

class Exercise
  def initialize(port)
    @server = TCPServer.new(port)
  end

  def start
    base_dir = Dir.new(".")
    socket = @server.accept
    binding.pry
    puts socket.gets

    body = SimpleServer::Body.new
    socket.write "HTTP/1.1 200 oK \r\n"
    # header = "Content-Type: text/html\r\n" +
    #          "Content-Length: #{body.length}\r\n" +
    #          "Connection: close\r\n"
    socket.write "Content-Type: text/html\r\n"
    socket.write "\r\n"
    socket.write body.render_node(base_dir)

    # socket.close
    # base_dir.entries.each do |f|
    #   if File.directory? f
    #     socket.print("
    #     #{f}/
    #
    #     ")
    #   else
    #     socket.print("
    #     #{f}
    #
    #     ")
    #   end
    # end
    # socket.close

    # if File.directory?(resource)
    #   socket.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
    #   if resource == ""
    #     base_dir = Dir.new(".")
    #   else
    #     base_dir = Dir.new("./#{resource}")
    #   end
    #   base_dir.entries.each do |f|
    #     dir_sign = ""
    #     base_path = resource + "/"
    #     base_path = "" if resource == ""
    #     resource_path = base_path + f
    #     if File.directory?(resource_path)
    #       dir_sign = "/"
    #     end
    #     if f == ".."
    #       upper_dir = base_path.split("/")[0..-2].join("/")
    #       socket.print("<a href=\&quot;/#{upper_dir}\&quot;>#{f}/</a>")
    #     else
    #       socket.print("<a href=\&quot;/#{resource_path}\&quot;>#{f}#{dir_sign}</a>")
    #     end
    #   end
    # end
    #

  end





end

server = Exercise.new(3000)
puts "Plugging tube into port 3000"
server.start
