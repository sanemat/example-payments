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

      loop do
        puts "POST #{api_v1_payments}"
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
  end
end
