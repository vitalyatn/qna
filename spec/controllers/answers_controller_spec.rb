require 'rails_helper'
require 'byebug'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user) }
  let!(:answer) { create(:answer) }

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
          expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
          last_answer = Answer.order(created_at: :desc).first
          expect(last_answer.question).to eq(answer.question)
        end

        it 'redirect to question' do
          post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }
          expect(response).to redirect_to answer.question
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
        end

        it 're-renders new view' do
          post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }
          expect(response).to render_template 'questions/show', locals: { question: answer.question }
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
      expect { delete :destroy, params: { question_id: answer.question, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'delete the answer by not author' do
      login(user)
      expect { delete :destroy, params: { question_id: answer.question, id: answer } }.to_not change(Answer, :count)
    end

    it 'delete the answer by non authorized user' do
      expect { delete :destroy, params: { question_id: answer.question, id: answer } }.to_not change(Answer, :count)
    end

    it 'redirects to index' do
      login(answer.user)
      delete :destroy, params: { question_id: answer.question, id: answer }
      expect(response).to redirect_to question_path(answer.question)
    end
  end
end
