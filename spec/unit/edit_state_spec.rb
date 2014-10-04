require 'rails_helper'

  describe Project do
    
    before :each do
      BunnyExchange = instance_double Bunny::Exchange
    end

    it  'should mock a rabbitmq call and test for response header and body' do
      alfonso = User.new
      alfonso.name = 'alfonso'
      alfonso.email = 'alfonsopintos@gmail.com'
      alfonso.phone_number = '1234567890'
      alfonso.password = "1234"
      alfonso.password_confirmation = "1234"
      expect(BunnyExchange).to receive(:publish) do |hash, options|
        hash = JSON.parse(hash)
        expect(hash).to have_key("body")
        expect(hash["body"]).to have_key("user_id")
        expect(hash["header"]).to have_key("auth_token")
      end
      alfonso.save
      expect(User.count).to eq(1)

      project = Project.new
      project.name = "test1"
      project.status = "new"
      project.user = alfonso
      project.save
      expect(Project.count).to eq(1)
      project.status = "Funding"
      expect(BunnyExchange).to receive(:publish) do |hash, options|
        hash = JSON.parse(hash)
        expect(hash).to have_key("body")
        expect(hash["body"]).to have_key("user_id")
        expect(hash["header"]).to have_key("auth_token")
      end
      project.save
      expect(Project.count).to eq(1)
  end


end