require 'rails_helper'

describe Api::V1::QuestionsController, type: :controller do
  render_views

  describe 'GET #scored' do
    let(:question) { create :question, :scored }

    before do
      create_list(:answer, 2, body: 2, question: question)
      create_list(:answer, 3, body: 3, question: question)
    end

    def do_request(params = {})
      get :scored, params: params.merge(format: :json)
    end

    it 'should be return average of score for each question' do
      do_request
      expect(response).to render_template :scored
      result = JSON.parse(response.body).with_indifferent_access
      expect(result[:success]).to be_truthy
      expect(assigns[:questions].first.avg).to eq 2.6
    end
  end

  describe 'GET #distributions' do
    let(:question1) { create :question, :scored }
    let(:question2) { create :question, :scored }
    let(:filter) { -> (arr, q) {
      arr.select{ |i| i[:question_id] == q.id }.first
    }}

    before do
      create_list(:answer, 2, body: 2, question: question1)
      create_list(:answer, 3, body: 3, question: question1)
      create_list(:answer, 2, body: 5, question: question2)
    end

    def do_request(params = {})
      get :distributions, params: params.merge(format: :json)
    end

    it 'should be return question frequencies' do
      do_request
      expect(response).to render_template :distributions
      result = JSON.parse(response.body).with_indifferent_access
      expect(result[:success]).to be_truthy
      expect(filter.call(assigns[:frequencies], question1).score_1).to be_nil
      expect(filter.call(assigns[:frequencies], question1).score_2).to eq 2
      expect(filter.call(assigns[:frequencies], question1).score_3).to eq 3
      expect(filter.call(assigns[:frequencies], question2).score_1).to be_nil
      expect(filter.call(assigns[:frequencies], question2).score_5).to eq 2
    end
  end

  describe 'GET #demographic' do
    let(:male1) { create :respondent, :male }
    let(:male2) { create :respondent, :male }
    let(:female1) { create :respondent, :female }
    let(:female2) { create :respondent, :female }
    let(:question1) { create :question, :scored }
    let(:question2) { create :question, :scored }
    let(:filter) { -> (arr, q) {
      arr.select{ |i| i.id == q.id }.first.avg
    }}

    before do
      create(:answer, body: 2, question: question1, respondent: male1)
      create(:answer, body: 3, question: question2, respondent: male2)
      create(:answer, body: 4, question: question2, respondent: create(:respondent, :male))
      create(:answer, body: 3, question: question1, respondent: female1)
      create(:answer, body: 4, question: question2, respondent: female2)
    end

    def do_request(params = {})
      get :demographic, params: params.merge(format: :json)
    end

    it 'should be return average of score for each question' do
      do_request
      expect(response).to render_template :demographic
      result = JSON.parse(response.body).with_indifferent_access
      expect(result[:success]).to be_truthy
      expect(filter.call(assigns[:male_answers], question1)).to eq 2
      expect(filter.call(assigns[:male_answers], question2)).to eq 3.5
      expect(filter.call(assigns[:female_answers], question1)).to eq 3
      expect(filter.call(assigns[:female_answers], question2)).to eq 4
    end
  end
end
