class User < ActiveRecord::Base
  # Since no auth_token was provided by the we have to create our own.(email with Jonatan)
  # Hence, before a user is created, we have to give each a unique auth token.
  before_create :set_auth_token
  after_save :send_rabbit
  has_secure_password
  validates :name, presence: true
  validates_uniqueness_of :email
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :phone_number, length: { is: 10 }
  validates :phone_number, :numericality => {:only_integer => true}

  has_many :projects


def send_rabbit 
  begin

    BunnyExchange.publish(hash, :routing_key => BunnyQueue.name)

    # BunnyQueue.subscribe do |delivery_info, metadata, payload|
    #   puts "Recieved #{payload}"
    #   # puts "delivery info: #{delivery_info}"
    #   # puts "metadata: #{metadata}"
    # end

  rescue Bunny::Exception => e

    @errors.add(:self, "Connection Failed, Error Rescued")

  return false
  end   
end



def hash
  {'header' => { 
    ref_id: SecureRandom.uuid, 
    client: 'es_web', 
    timestamp: Time.now, 
    priority: 'normal', 
    auth_token: self.auth_token, 
    event_type: 'Welcome New User'},
    'body' => {
      user_id: self.id, 
      channel: "email", 
      user_email: self.email, 
      username: self.name, 
      user_mobile: self.phone_number}
      }.to_json
end





# method being called for auth token
  private
  def set_auth_token
    #halts mehtod is auth_token present. If not, method continues.
    return if auth_token.present?

    #sets User.auth_token = to a random hex number
    self.auth_token = SecureRandom.hex

  end

end
