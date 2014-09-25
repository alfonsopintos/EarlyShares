require 'rails_helper'

RSpec.describe User, :type => :model do
	subject{ described_class.new name: example_name}
	let(:example_name){"Bryce"}
	it 'has a name' do
		expect(subject.name).to eq example_name
	end
	it 'has a phone number'
	it 'has an email address'
end