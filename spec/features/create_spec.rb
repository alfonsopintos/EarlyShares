require 'rails_helper'


describe 'Sign up' do
	it 'Signing Up from home page' do
		visit "/"
		expect(page).to have_content('Home')
		click_on("Sign Up")
		expect(page).to have_content('Sign Up')
		find(:css, "input[id$='user_name']").set("test")
		find(:css, "input[id$='user_email']").set("alfonsopintos@gmail.com")
		find(:css, "input[id$='user_phone_number']").set("7865467647")
		find(:css, "input[id$='user_password']").set("1234")
		find(:css, "input[id$='user_password_confirmation']").set("1234")
		click_on("Create User")
		expect(page).to have_content('Listing projects')
	end
end

describe 'Log In' do
	
	before :each do
	    User.create(:name => 'alfonso', :email => 'alfonsopintos@gmail.com', :phone_number => '1234567890', :password => '1234', :password_confirmation => '1234')
	  end
	it 'Signing in from home page' do
		visit "/"
		expect(page).to have_content('Home')
		click_on("Log In")
		expect(page).to have_content('Email')
		find(:css, "input[id$='email']").set("alfonsopintos@gmail.com")
		find(:css, "input[id$='password']").set("1234")
		click_on("Sign In")
		expect(page).to have_content('Listing projects')
	end
end

describe 'Creating projects' do

	it 'redirects to project show page on success' do
		visit "/projects"
		expect(page).to have_content("Listing projects")
		click_on('New Project')
		expect(page).to have_content("New project")

	end
end