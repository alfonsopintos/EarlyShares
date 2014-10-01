begin
  raise 'error' if Rails.env.test?

  conn = Bunny.new(
    :host => "tiger.cloudamqp.com", 
    :vhost => "jnrczvil", 
    :user => "jnrczvil", 
    :password => "sIMlgcE-xekl1Fo5hEQEIApzaBtGP8tO",
    :automatic_recovery => false)

    conn.start

    BunnyConnection = conn      
    BunnyChannel = BunnyConnection.create_channel
    BunnyQueue = BunnyChannel.queue("bunny", :auto_delete => true)
    BunnyExchange = BunnyChannel.default_exchange
rescue
  require 'rspec/mocks/standalone'
    BunnyConnection = instance_double Bunny
    BunnyChannel = instance_double Bunny::Channel
    BunnyQueue = instance_double Bunny::Queue, name: 'bunny' 
    BunnyExchange = instance_double Bunny::Exchange
end