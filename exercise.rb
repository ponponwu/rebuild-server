require './lib/simple_server'
require 'socket'
require 'pry'
require 'pry-byebug'
require 'thread'

class Exercise
  def initialize(port)
    @server = TCPServer.new(port)
  end

  def get_content_type(path)
    ext = File.extname(path)
    return "text/html"  if ext == ".html" or ext == ".htm"
    return "text/plain" if ext == ".txt"
    return "text/css"   if ext == ".css"
    return "image/jpeg" if ext == ".jpeg" or ext == ".jpg"
    return "image/gif"  if ext == ".gif"
    return "image/bmp"  if ext == ".bmp"
    return "text/plain" if ext == ".rb"
    return "text/xml"   if ext == ".xml"
    return "text/xml"   if ext == ".xsl"
    return "text/html"
  end

  def start
    loop do
      base_dir = Dir.new(".")
      socket = @server.accept
      request = socket.gets


      trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '').chomp
      resource =  trimmedrequest
      if resource == ""
        resource = "."
      end
      print resource

      Thread.fork(socket) do
        body = SimpleServer::Body.new
        socket.write "HTTP/1.1 200 oK \r\n"
        # header = "Content-Type: text/html\r\n" +
        #          "Content-Length: #{body.length}\r\n" +
        #          "Connection: close\r\n"
        socket.write "Content-Type: text/html\r\n"
        socket.write "\r\n"
        socket.write body.render_node(base_dir)
        socket.close
      end
    end
    # if File.directory?(resource)
    #   socket.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
    #   if resource == ""
    #     base_dir = Dir.new(".")
    #   else
    #     base_dir = Dir.new("./#{trimmedrequest}")
    #   end
    #   binding.pry
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
    # else
    #   contentType = get_content_type(resource)
    #   socket.print "HTTP/1.1 200/OK\r\nServer: Matteo\r\nContent-type: #{contentType}\r\n\r\n"
    #   File.open(resource, "rb") do |f|
    #     while (!f.eof?) do
    #       buffer = f.read(256)
    #       socket.write(buffer)
    #     end
    #   end
    # end




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
