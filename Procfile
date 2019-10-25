web: bundle exec puma -C config/puma.rb
sidekiq: bundle exec sidekiq
ingest: python3 runner/ws_ingest/subscribe.py -u "isebox" -p "MDDqnieTIgzwAoq8" -w "wss://e-tddc-ise2-psn4.medcampus.org:8910/pxgrid/ise/pubsub" -n "e-tddc-ise2-psn4.medcampus.org" -t "/topic/com.cisco.ise.session"
schduler: rails runner runner/scheduler.rb
