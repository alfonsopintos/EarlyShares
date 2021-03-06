require 'rails_helper'

describe 'Sign up' do
  
  before :each do
    BunnyExchange = instance_double Bunny::Exchange
    allow(BunnyExchange).to receive(:publish)
  end

  it 'should redirect to project index after success' do
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
    BunnyExchange = instance_double Bunny::Exchange
    allow(BunnyExchange).to receive(:publish)
    User.create(:name => 'alfonso', :email => 'alfonsopintos@gmail.com', :phone_number => '1234567890', :password => '1234', :password_confirmation => '1234')
  end

  it 'signs in user then redirects to project index' do
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

describe 'Creating projects when user signed in' do

  before :each do
    BunnyExchange = instance_double Bunny::Exchange
    allow(BunnyExchange).to receive(:publish)
    User.create(:name => 'alfonso', :email => 'alfonsopintos@gmail.com', :phone_number => '1234567890', :password => '1234', :password_confirmation => '1234')
  end

  def create_project(options={})
    options[:project_name] ||= "Test Create"
    options[:status] ||= "New"

    visit "/"
    expect(page).to have_content('Home')
    click_on("Log In")
    expect(page).to have_content('Email')
    find(:css, "input[id$='email']").set("alfonsopintos@gmail.com")
    find(:css, "input[id$='password']").set("1234")
    click_on("Sign In")
    expect(page).to have_content('Listing projects')
    click_on('New Project')
    expect(page).to have_content("New project")
    find(:css, "input[id$='project_name']").set(options[:project_name])
    select (options[:status]), from: 'Status'
    click_button 'Create Project'
  end 


  it 'redirects to project show after creation when status new' do
    create_project status: "New"
    expect(page).to have_content("Project was successfully created")
    expect(Project.count).to eq(1)

  end

  it 'redirects to project show after creation when status pre-funding' do
    create_project status: "Pre-Funding"
    expect(page).to have_content("Project was successfully created")
    expect(Project.count).to eq(1)
  end

  it 'redirects to project show after creation when status approved' do
    create_project status: "Approved"
    expect(page).to have_content("Project was successfully created")
    expect(Project.count).to eq(1)
  end

  it 'should render error when poject name is below three letters' do
    create_project project_name: "hi"
    expect(page).to have_content("error")
    expect(Project.count).to eq(0)
  end
end

describe 'Creating projects when not signed in' do 

  it 'redirects to log in page if user not signed in when trying to create project' do
    visit "/projects"
    expect(page).to have_content("Listing projects")
    visit "/projects/new"
    expect(page).to have_content("Log In")
    expect(Project.count).to eq(0)

  end
end










