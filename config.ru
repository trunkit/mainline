# This file is used by Rack-based servers to start the application.

if defined?(Unicorn)
  require 'unicorn/worker_killer'

  # Max requests per worker
  use Unicorn::WorkerKiller::MaxRequests, 2048, 3072

  # Max memory size (RSS) per worker
  use Unicorn::WorkerKiller::Oom, (160*(1024**2)), (192*(1024**2))
end

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
