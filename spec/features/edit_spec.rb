require 'rails_helper'

describe 'Editing projects when user signed in' do

  before :each do
    User.create(:name => 'alfonso', :email => 'alfonsopintos@gmail.com', :phone_number => '1234567890', :password => '1234', :password_confirmation => '1234')
  end

  def sign_in_and_create_project(options={})
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

  it 'updates a project name successfully with correct information' do
    sign_in_and_create_project
    project = Project.last
    expect(page).to have_content("successfully created")
    expect(Project.count).to eq(1)
    visit "/"
    expect(page).to have_content("Listing projects")
    click_on "Edit"
    expect(page).to have_content("Editing project")
    fill_in "Name", with: "Test Rename"
    click_on "Update Project"
    expect(page).to have_content("successfully updated")
    expect(page).to have_content("Test Rename")
    project.reload
    expect(project.name).to eq("Test Rename")
    expect(project.status).to eq("new")
  end

  it 'displays error when updating project with name less than 3 characters' do
    sign_in_and_create_project
    expect(page).to have_content("successfully created")
    expect(Project.count).to eq(1)
    visit "/"
    expect(page).to have_content("Listing projects")
    click_on "Edit"
    expect(page).to have_content("Editing project")
    fill_in "Name", with: "ab"
    click_on "Update Project"
    expect(page).to have_content("error")
  end

  it 'displays error when updating project with no name' do
    sign_in_and_create_project
    expect(page).to have_content("successfully created")
    expect(Project.count).to eq(1)
    visit "/"
    expect(page).to have_content("Listing projects")
    click_on "Edit"
    expect(page).to have_content("Editing project")
    fill_in "Name", with: ""
    click_on "Update Project"
    expect(page).to have_content("error")

  end

  it 'publishes to rabbitmq when project status moves to funding' do
    sign_in_and_create_project
    project = Project.last
    expect(page).to have_content("successfully created")
    expect(Project.count).to eq(1)
    visit "/"
    expect(page).to have_content("Listing projects")
    click_on "Edit"
    expect(page).to have_content("Editing project")
    select ("Funding"), from: "Status"
    click_on "Update Project"
    expect(page).to have_content("successfully updated")
    project.reload
    expect(project.status).to eq("Funding")
    expect(Project.count).to eq(1)

  end

end 





