require 'rails_helper'

RSpec.describe "Homes", type: :request do
  it "root" do
    get "/"
    expect(response.body).to include("Coming soon")
  end
end
