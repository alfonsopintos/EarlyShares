class User < ActiveRecord::Base
	has_secure_password
	validates :name, presence: true
	validates_uniqueness_of :email
	validates :email, presence: true
	validates :cell_phone, presence: true
	validates :cell_phone, length: { is: 10 }
	validates :cell_phone, :numericality => {:only_integer => true}

	has_many :projects

end
