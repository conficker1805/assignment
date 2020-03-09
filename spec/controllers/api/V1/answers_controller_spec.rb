require 'rails_helper'

describe Api::V1::AnswersController, type: :controller do
  render_views

  describe 'GET #index' do
    before do
      create_list(:answer, 12)
    end

    def do_request(params = {})
      get :index, params: params.merge(format: :json)
    end

    it 'should be show list of answers' do
      do_request
      expect(response).to render_template :index
      result = JSON.parse(response.body).with_indifferent_access
      expect(result[:success]).to be_truthy
      expect(result[:data][:responses].count).to eq 10
    end
  end

  describe 'POST #create' do
    let(:respondent) { create :respondent }
    let(:question1) { create :question }
    let(:question2) { create :question, :scored }

    def do_request(params = {})
      post :create, params: params.merge(format: :json)
    end

    context 'valid params' do
      let(:params) {{
        respondentIdentifier: respondent.identifier,
        responses: [
          { questionId: question1.id, body: Faker::Lorem.sentence },
          { questionId: question2.id, body: 3 }
        ]
      }}

      it 'should be create answer(s) successfully' do
        expect { do_request(params) }.to change{ Respondent::Answer.count }.from(0).to(2)

        result = JSON.parse(response.body).with_indifferent_access
        expect(response).to render_template :create
        expect(result[:success]).to be_truthy
        expect(result[:data][:responses].count).to eq 2
        expect(respondent.answers.count).to eq 2
      end
    end

    context 'invalid params' do
      context 'user is not found' do
        let(:params) {{
          respondentIdentifier: 'invalid_identifier',
          responses: [
            { questionId: question1.id, body: Faker::Lorem.sentence },
            { questionId: question2.id, body: 3 }
          ]
        }}

        it 'should return error' do
          do_request(params)
          result = JSON.parse(response.body).with_indifferent_access
          expect(result[:success]).to be_falsey
          expect(result[:message]).to eq 'You don\'t have permission on this resource.'
        end
      end

      context 'param is missing' do
        let(:params) {{
          respondentIdentifier: respondent.identifier,
          responses: [
            { body: Faker::Lorem.sentence },
            { questionId: question2.id, body: 3 }
          ]
        }}

        it 'should return error message' do
          do_request(params)
          result = JSON.parse(response.body).with_indifferent_access
          expect(result[:success]).to be_falsey
          expect(result[:message]).to eq 'Your requested params are invalid, please check again.'
        end
      end

      context 'last answer is invaild' do
        let(:params) {{
          respondentIdentifier: respondent.identifier,
          responses: [
            { questionId: question1.id, body: Faker::Lorem.sentence },
            { questionId: question2.id, body: Faker::Lorem.sentence }
          ]
        }}

        it 'should not create any answer' do
          expect { do_request(params) }.not_to change{ Respondent::Answer.count }
          result = JSON.parse(response.body).with_indifferent_access
          expect(result[:success]).to be_falsey
          expect(result[:message]).to eq 'Your answer should be a number from 1 to 5 for scored questions'
          expect(respondent.answers.count).to eq 0
        end
      end

      context 'do not give answer for mandatory questions' do
        let!(:question3) { create :question, optional: false }

        let(:params) {{
          respondentIdentifier: respondent.identifier,
          responses: [
            { questionId: question1.id, body: Faker::Lorem.sentence },
            { questionId: question2.id, body: 3 }
          ]
        }}

        it 'should not create any answer and raise error' do
          expect { do_request(params) }.not_to change{ Respondent::Answer.count }
          result = JSON.parse(response.body).with_indifferent_access
          expect(result[:success]).to be_falsey
          expect(result[:message]).to eq 'Please give response for mandatory questions.'
          expect(respondent.answers.count).to eq 0
        end
      end

      context 'giving 2 answers for single question' do
        let(:params) {{
          respondentIdentifier: respondent.identifier,
          responses: [
            { questionId: question1.id, body: Faker::Lorem.sentence },
            { questionId: question1.id, body: Faker::Lorem.sentence }
          ]
        }}

        it 'should not create any answer' do
          expect { do_request(params) }.not_to change{ Respondent::Answer.count }
          result = JSON.parse(response.body).with_indifferent_access
          expect(result[:success]).to be_falsey
          expect(result[:message]).to eq 'Are you giving response twice on a question?'
          expect(respondent.answers.count).to eq 0
        end
      end
    end
  end
end
