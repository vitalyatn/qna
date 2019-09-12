require 'rails_helper'
require 'byebug'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user) }
  let!(:answer) { create(:answer) }
  let(:question) { create :question }

  describe 'GET #show' do
    before { get :show, params: { question_id: answer.question, id: answer } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: answer.question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'Authorized user tries create answer' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }, format: :js }.to change(Answer, :count).by(1)
          last_answer = Answer.order(created_at: :desc).first
          expect(last_answer.question).to eq(answer.question)
          expect(user).to eq(last_answer.user)
        end

        it 'redirect to question' do
          post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
        end

        it 're-renders new view' do
          post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :create
        end
      end
    end

    context 'Non authorized user tries create answer' do
      it 'does not save the answer', skip_before: true do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    it 'delete the answer by author' do
      login(answer.user)
      expect { delete :destroy, params: { question_id: answer.question, id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'delete the answer by not author' do
      login(user)
      expect { delete :destroy, params: { question_id: answer.question, id: answer }, format: :js }.to_not change(Answer, :count)
    end

    it 'delete the answer by non authorized user' do
      expect { delete :destroy, params: { question_id: answer.question, id: answer }, format: :js }.to_not change(Answer, :count)
    end

    it 'redirects to index' do
      login(answer.user)
      delete :destroy, params: { question_id: answer.question, id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: {id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: {id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          answer.reload
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #better' do
    describe 'Author can' do
      before { login(user) }
      let!(:question) { create(:question, user: user) }
      let!(:answers) { create_list(:answer, 5, question: question) }
  
      context 'choose better answer' do
        it 'changes answer attributes (question has not better answer)' do
          answer = answers.first
          patch :better, params: { id: answer, answer: { better: true } }, format: :js
          answer.reload
          expect(answer.better).to eq true
        end

        it 'changes answer attributes (question has better answer)' do
          answers << create(:answer, question: question, better: true)
          old_better_answer = answers.last
          answer = answers.first
          patch :better, params: { id: answer, answer: { better: true } }, format: :js
          answer.reload
          old_better_answer.reload
          expect(answer).to be_better
          expect(old_better_answer).not_to be_better
        end

        it 'renders update view' do
          patch :better, params: { id: answer, answer: { better: true } }, format: :js
          expect(response).to render_template :better
        end
      end
    end

    describe 'Not author can not' do
      before { login(user) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 5, question: question) }

      context 'choose better answer' do
        it 'does not change answer attributes (question has not better answer)' do
          answer = answers.first
          patch :better, params: { id: answer, answer: { better: true } }, format: :js
          answer.reload
          expect(answer).not_to be_better
        end

        it 'does not change answer attributes (question has better answer)' do
          answers << create(:answer, question: question, better: true)
          old_better_answer = answers.last
          answer = answers.first
          patch :better, params: { id: answer, answer: { better: true } }, format: :js
          answer.reload
          old_better_answer.reload
          expect(answer).not_to be_better
          expect(old_better_answer).to be_better
        end

        it 'renders update view' do
          patch :better, params: { id: answer, answer: { better: true } }, format: :js
          expect(response).to render_template :better
        end
      end
    end

    describe 'Guest can not' do
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 5, question: question) }

      context 'choose better answer' do
        it 'does not change answer attributes (question has not better answer)' do
          answer = answers.first
          patch :better, params: { id: answer, answer: { better: true } }, format: :js
          answer.reload
          expect(answer).not_to be_better
        end

        it 'does not change answer attributes (question has better answer)' do
          answers << create(:answer, question: question, better: true)
          old_better_answer = answers.last
          answer = answers.first
          patch :better, params: { id: answer, answer: { better: true } }, format: :js
          answer.reload
          old_better_answer.reload
          expect(answer).not_to be_better
          expect(old_better_answer).to be_better
        end

        it 'renders update view' do
          patch :better, params: { id: answer, answer: { better: true } }, format: :js
          expect(response).to render_template :better
        end
      end
    end
  end
end
