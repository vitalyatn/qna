require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe "question's answers order by better" do
    let!(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }
    let!(:answer3) { create(:answer, question: question) }

    context 'question has not better answer' do
      it "returns order by datetime" do
        expect(question.answers).to eq([answer1, answer2, answer3])
      end
    end

    context 'question has better answer' do
      let!(:answer2) { create(:answer, question: question, better: true) }

      it "returns order by better" do
        expect(question.answers).to eq([answer2, answer1, answer3])
      end
    end
  end
end
