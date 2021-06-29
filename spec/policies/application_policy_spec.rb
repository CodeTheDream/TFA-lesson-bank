require 'rails_helper'
RSpec.describe ApplicationPolicy, type: :policy do
#   let(:policy) { described_class }
subject { ApplicationPolicy.new(:user,:course) }
  before do
   @user = FactoryBot.create(:user)
  end
  after do
    @user.delete
  end
  context 'being a visitor for user' do
    let(:user) { nil }
    it { should_not permit_action(:create)  }
    it { should_not permit_action(:index) }
  end

  context 'being a visitor for course' do
    let(:course) { nil }
    it { should_not permit_action(:create)  }
    it { should_not permit_action(:index) }
  end
end

