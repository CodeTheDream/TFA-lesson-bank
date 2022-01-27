require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    @user = FactoryBot.create(:user)
  end
  it "send_email_confirmation" do
    expect { @user.send_email_confirmation }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
  
  after do
    @user.delete
  end
end
