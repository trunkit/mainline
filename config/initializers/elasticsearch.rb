host = Rails.env.development? ?  "http://localhost:9200" : ENV["BONSAI_URL"]
Elasticsearch::Model.client = Elasticsearch::Client.new(host: host)
