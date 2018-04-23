class Transactor
  class << self
    def run(count:)
      Signal.trap('INT') do
        stop
        exit(1)
      end

      start(count: count)
    end

    def start(count:)
      puts 'start!'

      loop do
        puts 'working'
        sleep 1
      end
    end

    def stop
      puts 'stop!'
    end
  end
end
