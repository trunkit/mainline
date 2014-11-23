Swagger::Docs::Config.register_apis({
  "1.0" => {
    api_file_path: "public/api/v1",
    base_path: (Rails.env.production? ? "https://www.trunkit.com" : "http://localhost:3000"),
    clean_directory: false,
    attributes: {
      info: {
        title: "Trunkit - Social Shopping",
        description: "RESTful JSON API for Trunkt",
        contact: "team@trunkit.com"
      }
    }
  }
})

class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    host = (Rails.env.production? ? "https://www.trunkit.com/api/v1" : "http://localhost:3000/api/v1")
    "#{host}/#{path}"
  end
end
