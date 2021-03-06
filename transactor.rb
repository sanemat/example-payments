require 'securerandom'
require 'httpclient'
require 'json'

class Transactor
  class << self
    def run(count:, endpoint:)
      @endpoint = endpoint
      @threads = []

      Signal.trap('INT') do
        stop
        exit(1)
      end

      start(count: count)
    end

    def start(count:)
      count.times.map do
        @threads << Thread.new do
          producer_id = SecureRandom.uuid
          client = HTTPClient.new

          loop do
            response = client.post_content(
              api_v1_payments,
              JSON.generate(
                build_transaction(
                  producer_id: producer_id,
                  account_id: SecureRandom.uuid,
                  amount: rand(amount_range),
                  )
              ),
              'Content-Type' => 'application/json'
            )
            # puts response

            Thread.current[:histories] ||= []
            Thread.current[:histories] = Thread.current[:histories] + [response]

            sleep rand(interval_range)
          end
        end
      end

      @threads.map(&:join)
    end

    def stop
      histories = []
      @threads.each do |th|
        histories += th[:histories].map { |string| JSON.parse(string) }
      end

      sorted_histories = histories.sort_by do |history|
        [history['balanced_at_epoc']]
      end
      accounts = {}
      sorted_histories.each do |history|
        accounts[history['account_id']] = { balance: history['balance'] }
      end

      result = {
        histories: sorted_histories,
        accounts: accounts,
      }
      puts result
    end

    def api_v1_payments
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

    def interval_range
      0..0.2
    end
  end
end
