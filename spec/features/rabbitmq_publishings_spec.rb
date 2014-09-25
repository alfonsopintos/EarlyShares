require 'rails_helper'

feature "RabbitmqPublishings", :type => :feature do
	subject{ Project.create name: 'bees Project'}

  scenario 'Project state becomes funding'

  scenario 'Project is created in funding state'

  scenario 'Project state becomes pre-funding' do 

  	visit "projects/#{subject.id}/edit"
  	select 'pre-funding', from: 'status'
  	click_button 'Update Project'

  end
end
