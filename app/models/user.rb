class User < ActiveRecord::Base
	has_secure_password
	validates :phone_number, presence: true
	validates :phone_number, length: { is: 10 }
	validates :phone_number, :numericality => {:only_integer => true}
	validates :name, presence: true


	def self.current
    	Thread.current[:user]
  	end
  	
  	def self.current=(user)
    	Thread.current[:user] = user
  	end

end