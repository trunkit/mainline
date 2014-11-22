Swagger::Docs::Config.register_apis({
  "1.0" => {
    api_extension_type: :json,
    api_file_path: "public/api/v1",
    base_path: "http://www.trunkit.com",
    clean_directory: false,
    attributes: {
      info: {
        title: "Trunkit - Social Shopping",
        description: "RESTful JSON API for Trunkt",
        contact: "team@trunkit.com"
      }
    }
  }
}) if defined?(Swagger)