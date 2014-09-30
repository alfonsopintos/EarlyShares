class User < ActiveRecord::Base
  before_create :set_auth_token
  has_secure_password
  validates :name, presence: true
  validates_uniqueness_of :email
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :phone_number, length: { is: 10 }
  validates :phone_number, :numericality => {:only_integer => true}

  has_many :projects


  private
  def set_auth_token
    return if auth_token.present?

    begin
      self.auth_token = SecureRandom.hex
    end 
    while self.class.exists?(auth_token: self.auth_token)
    end
  end
end
