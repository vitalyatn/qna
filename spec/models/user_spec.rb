require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe ".author?" do
    let!(:user) { create(:user) }

    it "of question_true" do
      question = create(:question, user: user)
      expect(user).to eq(question.user)
    end

    it "of answer_true" do
      answer = create(:question, user: user)
      expect(user).to eq(answer.user)
    end

    it "of question_false" do
      question = create(:question)
      expect(user).to_not eq(question.user)
    end

    it "of answer_true_false" do
      answer = create(:question)
      expect(user).to_not eq(answer.user)
    end
  end
end
