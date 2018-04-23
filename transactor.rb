require 'securerandom'

class Transactor
  class << self
    def run(count:, endpoint:)
      @endpoint = endpoint

      Signal.trap('INT') do
        stop
        exit(1)
      end

      start(count: count)
    end

    def start(count:)
      puts 'start!'
      producer_id = SecureRandom.uuid

      loop do
        puts "POST #{api_v1_payments} #{build_transaction(producer_id: producer_id, account_id: SecureRandom.uuid, amount: rand(amount_range))}"
        sleep 1
      end
    end

    def stop
      puts "GET #{api_v1_retrieve_all_payments}"
    end

    def api_v1_payments
      "#{@endpoint}/v1/payments"
    end

    def api_v1_retrieve_all_payments
      "#{@endpoint}/v1/payments"
    end

    def build_transaction(producer_id:, account_id:, amount:)
      {
          producer_id: producer_id,
          account_id: account_id,
          amount: amount,
      }
    end

    def amount_range
      -10000..10000
    end
  end
end
