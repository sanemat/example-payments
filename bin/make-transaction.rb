require_relative '../transactor'
producers_count = ENV.fetch('PRODUCERS_COUNT').to_i

Transactor.run(count: producers_count)
