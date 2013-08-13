Trunkit::Application.routes.draw do
  root to: "contents#show"

  get "*path" => "contents#show"
end
