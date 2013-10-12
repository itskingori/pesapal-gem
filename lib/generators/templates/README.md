
How To Use Config File
----------------------

The Pesapal config file is in YAML format and looks something like this. Change
the values appropriately.

```
development:
    callback_url: 'http://0.0.0.0:3000/pesapal/callback'
    consumer_key: '<YOUR_CONSUMER_KEY>'
    consumer_secret: '<YOUR_CONSUMER_SECRET>'

production:
    callback_url: 'http://1.2.3.4:3000/pesapal/callback'
    consumer_key: '<YOUR_CONSUMER_KEY>'
    consumer_secret: '<YOUR_CONSUMER_SECRET>'
```

The config file can be found at `#{Rails.root}/config/pesapal.yml`.

