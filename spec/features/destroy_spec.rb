require 'rails_helper'

describe 'Deleting projects when user signed in' do

	before :each do
	    User.create(:name => 'Joel', :email => 'joel@gmail.com', :phone_number => '1234567890', :password => '12345', :password_confirmation => '12345')
	end

	def create_project(options={})
		options[:project_name] ||= "Test"
		options[:status] ||= "New"

		visit "/"
		expect(page).to have_content('Home')
		click_on("Log In")
		expect(page).to have_content('Email')
		find(:css, "input[id$='email']").set("joel@gmail.com")
		find(:css, "input[id$='password']").set("12345")
		click_on("Sign In")
		expect(page).to have_content('Listing projects')
		click_on('New Project')
		expect(page).to have_content("New project")
		find(:css, "input[id$='project_name']").set(options[:project_name])
		select (options[:status]), from: 'Status'
		click_button 'Create Project'
	end	


	it 'successfully destroys a project' do
		create_project
		expect(page).to have_content("Project was successfully created")
		expect(Project.count).to eq(1)
		click_on('Back')
		visit "/projects"
		click_on('Destroy')
		expect(Project.count).to eq(0)
	end
end