class User < ActiveRecord::Base
  # Since no auth_token was provided by the we have to create our own.(email with Jonatan)
  # Hence, before a user is created, we have to give each a unique auth token.
  before_create :set_auth_token
  has_secure_password
  validates :name, presence: true
  validates_uniqueness_of :email
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :phone_number, length: { is: 10 }
  validates :phone_number, :numericality => {:only_integer => true}

  has_many :projects


# method being called for auth token
  private
  def set_auth_token
    #halts mehtod is auth_token present. If not, method continues.
    return if auth_token.present?

    #sets User.auth_token = to a random hex number
    self.auth_token = SecureRandom.hex

  end

end
