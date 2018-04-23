require_relative '../transactor'
producers_count = ENV.fetch('PRODUCERS_COUNT').to_i
api_endpoint = ENV.fetch('API_ENDPOINT')

Transactor.run(count: producers_count, endpoint: api_endpoint)
