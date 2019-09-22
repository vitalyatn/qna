require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe "#author?" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user) }

    it "of question_true" do
      expect(user.author?(question)).to eq(true)
    end

    it "of answer_true" do
      expect(user.author?(answer)).to eq(true)
    end

    it "of question_false" do
      expect(user.author?(create(:question))).to eq(false)
    end

    it "of answer_true_false" do
      expect(user.author?(create(:answer))).to eq(false)
    end
  end
end
