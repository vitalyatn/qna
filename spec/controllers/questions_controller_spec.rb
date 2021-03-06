require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new questions in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
          last_question = Question.order(created_at: :desc).first
          expect(user).to eq(last_question.user)
        end

        it 'redirect to show' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'Unauthenticated user' do
      it 'tries create question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { login(user) }

      context 'is author'  do
        context 'with valid attributes' do
          it 'assigns the requested question to @question' do
            question = create(:question, user: user)
            patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
            expect(assigns(:question)).to eq question
          end

          it 'changes question attributes' do
            question = create(:question, user: user)
            patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
            question.reload

            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it 'redirects to updated question' do
            question = create(:question, user: user)
            patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before do
            question = create(:question, user: user)
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          end

          it 'does not change question' do
            question.reload
            expect(question.title).to match 'MyString'
            expect(question.body).to match 'MyText'
          end

          it 're-renders edit view' do
            expect(response).to render_template :update
          end
        end
      end

      context 'is not author' do
        it 'does not change question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload

          expect(question.title).to_not eq 'new title'
          expect(question.body).to_not eq 'new body'
        end
      end
    end
    context 'Unauthenticated user' do
      it 'does not change question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }
      it 'tries delete own question' do
        question = create(:question, user: user)
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'tries delete other question' do
        question = create(:question)
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Non authenticated user' do
      it 'tries delete question' do
        question = create(:question)
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end
