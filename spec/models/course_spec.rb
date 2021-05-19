require 'rails_helper'
RSpec.describe Course, type: :model do
  describe 'Course' do
    subject { Course.new(id: 1, title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: "2021-05-05 07:09:07", updated_at: "2021-05-05 07:09:07", user_id: 1)
              User.new(id: 1, email: "adi_111@icloud.com", role: "teacher", created_at: "2021-05-05 07:06:27", updated_at: "2021-05-05 07:08:29", password: "Pa$$word1")} 
    it "is valid with valid attributes" do
      expect(subject).to be_valid    
    end

  end
end

