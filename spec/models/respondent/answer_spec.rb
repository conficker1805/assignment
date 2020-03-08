require 'rails_helper'

describe Respondent::Answer do
  describe 'Associations' do
    it { should belong_to :respondent }
    it { should belong_to :question }
  end

  describe 'Validations' do
    it { should validate_presence_of(:question_id) }
    it { should validate_presence_of(:respondent_id) }

    context 'validate body length' do
      let(:respondent) { create :respondent }
      let(:question) { create :question }
      let(:invalid_string) { ["", Faker::Lorem.characters(number: 257)].sample }
      let(:answer) do
        Respondent::Answer.new(attributes_for(:answer,
          body: invalid_string,
          question_id: question.id,
          respondent_id: respondent.id
        ))
      end

      it 'should validate length in 1..256' do
        expect(answer.valid?).to be_falsey

        message = answer.errors.messages[:body].join
        expect(/is too (long|short)/.match(message).present?).to be_truthy
      end
    end
  end

  describe '#unique_submission' do
    let(:respondent) { create :respondent }
    let(:question) { create :question }
    let!(:answer1) { create :answer, question: question, respondent: respondent }

    let(:answer2) do
      Respondent::Answer.new(attributes_for(:answer,
        body: Faker::Lorem.sentence,
        question_id: question.id,
        respondent_id: respondent.id
      ))
    end

    context 'user submit one more time on a question' do
      it 'should raise error' do
        expect { answer2.save }.to raise_error(Error::Answer::SubmitTwice)
      end
    end
  end

  describe '#valid_body' do
    let(:respondent) { create :respondent }
    let(:question) { create :question, :scored }
    let(:invalid_body) { ['0', '1.3', 6, '5,5', '-4'].sample }

    let(:answer) do
      Respondent::Answer.new(attributes_for(:answer,
        body: invalid_body,
        question_id: question.id,
        respondent_id: respondent.id
      ))
    end

    context 'user submit invalid answer' do
      it 'should raise error' do
        expect { answer.save }.to raise_error(Error::Params::Invalid)
      end
    end
  end

  describe '#score_out_of_range' do
    let(:valid) { (1..5).to_a.sample }
    let(:invalid) { (6..20).to_a.sample }

    it 'should return body valid or not' do
      expect(Respondent::Answer.new(body: valid).send(:score_out_of_range)).to be_falsey
      expect(Respondent::Answer.new(body: invalid).send(:score_out_of_range)).to be_truthy
    end
  end

  describe '#fetch_answers_by_gender' do
    let(:males) { create_list(:respondent, 3, :male) }
    let(:females) { create_list(:respondent, 2, :female) }
    let(:question1) { create :question, :scored }
    let(:question2) { create :question, :scored }
    let(:filter_score) { -> (arr, q) {
      arr.select{ |i| i[:id] == q.id }.first[:avg].to_f
    }}

    before do
      create(:answer, body: 1, question: question1, respondent: males.first)
      create(:answer, body: 3, question: question1, respondent: males.second)
      create(:answer, body: 4, question: question2, respondent: males.third)

      create(:answer, body: 5, question: question2, respondent: females.first)
    end

    it 'should return a hash of average score for each question' do
      male_result   = Respondent::Answer.fetch_answers_by_gender('Male')
      female_result = Respondent::Answer.fetch_answers_by_gender('Female')
      male_result   = male_result.map { |i| [:id, :avg].zip(i).to_h }
      female_result = female_result.map { |i| [:id, :avg].zip(i).to_h }

      expect(male_result).is_a? Hash
      expect(female_result).is_a? Hash

      expect(filter_score.call(male_result, question1)).to eq 2
      expect(filter_score.call(male_result, question2)).to eq 4
      expect(filter_score.call(female_result, question2)).to eq 5
    end
  end
end
