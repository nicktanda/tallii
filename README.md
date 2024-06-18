# README

Things To Run:
```
bin/setup
overmind start
overmind connect # in a separate tab
# in another tab
stripe login
stripe listen --forward-to http://localhost:3000/webhooks/payment
```

Eventually I'll get everything into its own script when I deploy to a docker container but for now I don't particularly care lol

Resources where I source shit from that's useful:
ruby.mobidev.biz/posts/stripe-payment-gateway-integration-in-ruby-on-rails-app/