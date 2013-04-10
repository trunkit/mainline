class ContentsController < ApplicationController
  def show
    path = (request.path == "/" ? "index" : request.path)
    path = path.downcase.gsub(/[^A-Za-z0-9\/]+/, '_')

    render(template: "contents/#{path}")
  end
end
