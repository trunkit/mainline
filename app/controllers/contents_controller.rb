class ContentsController < ApplicationController
  def show
    path = (request.path == "/" ? "index" : request.path[1,request.path.length-1])
    path = path.downcase.gsub(/[^A-Za-z0-9\/]+/, '_')

    render(template: "contents/#{path}")
  end
end
