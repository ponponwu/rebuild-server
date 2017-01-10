module SimpleServer
  class Body
    attr_accessor :body

    def initialize
      @body = "<ul>\r\n"
    end

    def render_node(base_dir)
      if Dir.exists? base_dir
        # binding.pry
        base_dir.entries.each do |dir|
          if File.directory? dir
            base = "up" if dir == ".."
            base = "root" if dir == "."
            @body += "<li>" + "<a href=http://localhost:3000/#{base || dir}>#{dir}</a>" + "</li>\r\n"
          else
            @body += "<li>#{dir}</li>\r\n"
          end
        end
      else
        @body += "<p>Directory does not exists!</p>"
      end
      @body += "</ul>"
      return @body
    end
  end
end
