class Project < ActiveRecord::Base
  require 'json'

  validates :name, presence: true, length: { minimum: 3 }

  after_save :send_rabbit, :if => :status_changed? 

  belongs_to :user


 def send_rabbit
  if self.status == "Funding" 
    begin
      connection = Bunny.new(
        :host => "tiger.cloudamqp.com", 
        :vhost => "jnrczvil", 
        :user => "jnrczvil", 
        :password => "sIMlgcE-xekl1Fo5hEQEIApzaBtGP8tO",
        :automatic_recovery => false)

      connection.start
          

      channel = connection.create_channel
      queue = channel.queue("bunny", :auto_delete => true)
      exchange = channel.default_exchange

      queue.subscribe do |delivery_info, metadata, payload|
        puts "Recieved #{payload}"
        # puts "delivery info: #{delivery_info}"
        # puts "metadata: #{metadata}"

      end

      exchange.publish(hash, :routing_key => queue.name)

      sleep 1.0
      connection.close

    rescue Bunny::Exception => e

     @errors.add(:self, "Connection Failed, Error Rescued")

     return false
   end   
 end
end


def hash
  {'header' => { 
    ref_id: SecureRandom.uuid, 
    client: 'es_web', 
    timestamp: Time.now, 
    priority: 'normal', 
    auth_token: self.user.auth_token, 
    event_type: 'project_status_update'},
    'body' => {
      user_id: self.user_id, 
      channel: "email", 
      user_email: self.user.email, 
      username: self.user.name, 
      user_mobile: self.user.phone_number}
      }.to_json
    end

  end
