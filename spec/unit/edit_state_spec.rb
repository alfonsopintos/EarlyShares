require 'rails_helper'

  describe Project do
    
    before :each do
    @user = User.create(:name => 'alfonso', :email => 'alfonsopintos@gmail.com', :phone_number => '1234567890', :password => '1234', :password_confirmation => '1234')
    end

    it  'should send rabbitmq call' do
      project = Project.new
      project.name = "test1"
      project.status = "new"
      project.user = @user
      project.save
      expect(Project.count).to eq(1)
      project.status = "Funding"
      project.save
      expect(Project.count).to eq(1)
      expect(Project.response).to have(project.hash)

    end

end