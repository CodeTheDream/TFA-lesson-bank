require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Associations" do
    it { should have_many(:courses) }
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
