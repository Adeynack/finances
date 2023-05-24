# frozen_string_literal: true

class ProxyController < ApplicationController
  FILE_ROOT = Rails.root.join("public").freeze

  def ping
    render html: "<html><body><h1>pong</h1></body></html>".html_safe, layout: false
  end

  def proxy
    extension = File.extname(request.path)
    file_name = (params[:path].to_s + extension).presence || "index.html"
    file = FILE_ROOT.join(file_name)
    type = Mime::Type.lookup_by_extension(extension.presence&.delete_prefix(".") || "html")
    if file.exist? # static file
      expires_in 2.years, public: true if [".css", ".js", ".svg"].include?(extension)
      send_file file, disposition: :inline, type: type.to_s
    elsif extension.blank? # client side routing of html files
      send_file FILE_ROOT.join("index.html"), disposition: :inline, type: type.to_s
    else
      head :not_found
    end
  end
end
