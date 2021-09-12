require 'rails_helper'

RSpec.describe TestService do
  it "rspec service test" do
    expect(TestService.new.execute).to eq(1)
  end
end
