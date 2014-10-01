require 'rails_helper'

  describe Project do
    
    before :each do
    @user = User.create(:name => 'alfonso', :email => 'alfonsopintos@gmail.com', :phone_number => '1234567890', :password => '1234', :password_confirmation => '1234')
    end

    it  'should mock a rabbitmq call and test for response header and body' do
      project = Project.new
      project.name = "test1"
      project.status = "new"
      project.user = @user
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