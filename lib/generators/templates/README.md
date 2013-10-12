Usage
-----
And the YAML file should look something like this. Change file with the appropriate values.

```yaml
development:
    callback_url: 'http://0.0.0.0:3000/pesapal/callback'
    consumer_key: '<YOUR_CONSUMER_KEY>'
    consumer_secret: '<YOUR_CONSUMER_SECRET>'

production:
    callback_url: 'http://1.2.3.4:3000/pesapal/callback'
    consumer_key: '<YOUR_CONSUMER_KEY>'
    consumer_secret: '<YOUR_CONSUMER_SECRET>'
```

Change default values in ```app/config/pesapal.yml```