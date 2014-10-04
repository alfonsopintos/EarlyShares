require 'rails_helper'

describe 'Deleting projects when user signed in' do

  before :each do
    BunnyExchange = instance_double Bunny::Exchange
    allow(BunnyExchange).to receive(:publish)
    User.create(:name => 'alfonso', :email => 'alfonsopintos@gmail.com', :phone_number => '1234567890', :password => '1234', :password_confirmation => '1234')
  end

  def create_project(options={})
    options[:project_name] ||= "Test"
    options[:status] ||= "New"

    click_on('New Project')
    expect(page).to have_content("New project")
    find(:css, "input[id$='project_name']").set(options[:project_name])
    select (options[:status]), from: 'Status'
    click_button 'Create Project'
  end 

  it 'should successfully sign in, create, and destroy a project' do
    visit "/"
    expect(page).to have_content('Home')
    click_on("Log In")
    expect(page).to have_content('Email')
    find(:css, "input[id$='email']").set("alfonsopintos@gmail.com")
    find(:css, "input[id$='password']").set("1234")
    click_on("Sign In")
    expect(page).to have_content('Listing projects')
    expect(Project.count).to eq(0)
    create_project
    expect(page).to have_content("Project was successfully created")
    expect(Project.count).to eq(1)
    click_on('Back')
    visit "/projects"
    click_on('Destroy')
    expect(Project.count).to eq(0)
  end
end

describe "should not allow a visitor to destroy a project" do

  it 'does not allow you to access the destroy link' do

    visit "/projects"
    expect(page).to have_content("Listing projects")
    expect(page).to have_no_content("Destroy")
  end

end











