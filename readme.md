# example-payments

## set up

```
$ bundle install
$ bundle exec rackup # this is a consumer
$ open http://localhost:9292/ping
```

It works.

## Start 3 producers

```bash
$ API_ENDPOINT='http://localhost:9292' PRODUCERS_COUNT=3 bundle exec ruby bin/make-transaction.rb
```

## Kill 3 producers

`Ctrl + c`

## How it works

### Consumer

- Consumer has Http API endpoint.
- Use `sinatra` with `webrick`.
    - 1 worker = 1 consumer
- This API is blocking, because producer needs transaction log.
- Consumer stores the data into class variables.
- Consumer stores user's balance.

### Producer

- Producers use thread.
- This sends a Http Api request, and waits the result of balance.
- Producer stores the data into thread variables.
- `ctrl + c` stops all producers, and after that this calculates current data from log.
