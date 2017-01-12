module SimpleServer
  class Body
    attr_accessor :body

    def initialize
      @body = "<ul>\r\n"
    end

    def render_node(base_dir)
      base_dir[:dir].each { |dir|
        base = "up" if dir == ".."
        base = "root" if dir == "."
        @body += "<li>" + "<a href=http://127.0.0.1:3000/#{base || dir}>#{dir}</a>" + "</li>\r\n"
      }
      base_dir[:file].each { |file|
        @body += "<li>#{file}</li>\r\n"
      }
      @body += "</ul>"
      # if Dir.exists? base_dir
      #   base_dir.entries.each do |dir|
      #     if File.directory? dir
      #       base = "up" if dir == ".."
      #       base = "root" if dir == "."
      #       @body += "<li>" + "<a href=http://localhost:3000/#{base || dir}>#{dir}</a>" + "</li>\r\n"
      #     else
      #       @body += "<li>#{dir}</li>\r\n"
      #     end
      #   end
      # else
      #   @body += "<p>Directory does not exists!</p>"
      # end
      # @body += "</ul>"
      @body
    end
  end
end
