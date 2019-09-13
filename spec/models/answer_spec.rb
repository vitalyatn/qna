require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe "#set_better!" do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 5, question: question) }

    it "create best answer" do
      answer = answers[0]
      expect(answer.set_better!).to eq(true)
    end

    it "change best_answer" do
      old_best = create(:answer, question: question, better: true)
      answer = answers[0]
      expect(answer.set_better!).to eq(true)
    end
  end
end
