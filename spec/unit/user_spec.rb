require 'rails_helper'

  describe User do
    
    before :each do
      BunnyExchange = instance_double Bunny::Exchange
    end 

    it  'should mock a rabbitmq call and test for response header and body' do
      user = User.new
      user.name = 'alfonso'
      user.email = 'alfonsopintos@gmail.com'
      user.phone_number = '1234567890'
      user.password = "1234"
      user.password_confirmation = "1234"
      expect(BunnyExchange).to receive(:publish) do |hash, options|
        hash = JSON.parse(hash)
        expect(hash).to have_key("body")
        expect(hash["body"]).to have_key("user_id")
        expect(hash["header"]).to have_key("auth_token")
      end
      user.save
      expect(User.count).to eq(1)
    end



end