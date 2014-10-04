class Project < ActiveRecord::Base
  require 'json'

  validates :name, presence: true, length: { minimum: 3 }

  after_save :send_project_rabbit, :if => :status_changed? 

  belongs_to :user


 def send_project_rabbit
  if self.status == "Funding" 
    begin

      BunnyExchange.publish(hash, :routing_key => BunnyQueue.name)

    #   BunnyQueue.subscribe do |delivery_info, metadata, payload|
    #   puts "Recieved #{payload}"
    #   # puts "metadata: #{metadata}"

    # end


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


  