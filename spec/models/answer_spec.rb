require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe "#set_better!" do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 5, question: question) }

    it "create best answer" do
      answer = answers[0]
      answer.set_better!
      expect(answer).to be_better
    end

    it "change best_answer" do
      old_best = create(:answer, question: question, better: true)
      answer = answers[0]
      answer.set_better!
      old_best.reload
      expect(old_best).not_to be_better
      expect(answer).to be_better
    end
  end
end
