require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe "#has_better_answer?" do
    it "true" do
      question = create(:question)
      answers = create_list(:answer, 3, question: question)
      answers << create(:answer, question: question, better: true)
      expect(question.has_better_answer?).to eq(true)
    end

    it "false" do
      question = create(:question)
      answers = create_list(:answer, 3, question: question)
      expect(question.has_better_answer?).to eq(false)
    end
  end

  describe "#delete_better" do
    it "sets 'better' to false" do
      question = create(:question)
      answers = create_list(:answer, 3, question: question)
      answers << create(:answer, question: question, better: true)
      question.delete_better
      expect(question.has_better_answer?).to eq(false)
    end
  end

end
