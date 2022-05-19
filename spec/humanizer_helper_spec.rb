require 'spec_helper'
require 'humanizer_helper'

describe HumanizerHelper do

  context "initialized with variables" do
    let(:incorrect_humanizer_answer) {"this is a wrong answer"}
    let(:humanizer_question_id) {1}
    let(:humanize_helper) {HumanizerHelper.new(humanizer_answer: incorrect_humanizer_answer, humanizer_question_id: humanizer_question_id.to_s)}

    it "works as a placeholder class to humanizer using the variables passed in" do
      expect(humanize_helper.humanizer_answer).to eq(incorrect_humanizer_answer)
      expect(humanize_helper.humanizer_question_id).to eq(humanizer_question_id)
      expect(humanize_helper.humanizer_correct_answer?).to be_falsey
      expect(humanize_helper.humanizer_question).to eq('Jack and Jill went up the...')

      expect(humanize_helper.get_correct_humanizer_answer).to eq('hill')
      humanize_helper.humanizer_answer = "hill"
      expect(humanize_helper.humanizer_correct_answer?).to be true

      humanize_helper.change_humanizer_question(humanizer_question_id)
      expect(humanize_helper.humanizer_question_id).to_not eq(humanizer_question_id)
    end
  end

  context "initialized without variables" do
    let(:humanize_helper) {HumanizerHelper.new}

    it "works as a placeholder class to humanizer" do
      expect(humanize_helper.humanizer_answer).to be_nil
      expect(humanize_helper.humanizer_question_id).to be_present
      expect(humanize_helper.humanizer_correct_answer?).to be_falsey

      humanize_helper.humanizer_answer = humanize_helper.get_correct_humanizer_answer
      expect(humanize_helper.humanizer_correct_answer?).to be true
    end
  end
end
