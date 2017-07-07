require "spec_helper"

class User
  include ActiveModel::Validations
  include Humanizer
  require_human_on :create
end

describe Humanizer do

  before(:each) do
    @user = User.new
  end

  context "when mixed-in with a class" do

    it "adds questions and answers to the instances" do
      questions = @user.send(:humanizer_questions)
      expect(questions.count).to eq(2)
      expect(questions[0]["question"]).to eq("Two plus two?")
      expect(questions[0]["answers"]).to eq(["4", "four"])
      expect(questions[1]["question"]).to eq("Jack and Jill went up the...")
      expect(questions[1]["answer"]).to eq("hill")
    end

    context "when question localizations can't be found" do
      it "will raise an exception" do
        I18n.with_locale :empty do
          expect { @user.send(:humanizer_questions) }.to raise_error(I18n::MissingTranslationData)
        end
      end
    end

    context "when question locale can't be found" do
      it "will raise an exception" do
        expect {
          I18n.with_locale :fi do
            @user.send(:humanizer_questions)
          end
         }.to raise_error(I18n::InvalidLocale)
      end
    end

  end

  context "question" do

    context "id" do

      it "is a random index for the questions array" do
        expect(@user).to receive(:humanizer_questions).and_return([1])
        expect(@user.humanizer_question_id).to eq(0)
      end

    end

    it "is retrieved based on the set id" do
      expect(@user).to receive(:humanizer_question_id).and_return(0)
      expect(@user.humanizer_question).to eq("Two plus two?")
      expect(@user).to receive(:humanizer_question_id).and_return(1)
      expect(@user.humanizer_question).to eq("Jack and Jill went up the...")
    end

  end

  context "answer" do

    it "is retrieved for a given id" do
      answers_for_id_0 = @user.send(:humanizer_answers_for_id, 0)
      answers_for_id_1 = @user.send(:humanizer_answers_for_id, 1)
      expect(answers_for_id_0.count).to eq(2)
      expect(answers_for_id_0).to include("4")
      expect(answers_for_id_0).to include("four")
      expect(answers_for_id_1).to eq(["hill"])
    end

  end

  context "correct answer" do

    it "can be any of the answers" do
      @user.humanizer_question_id = 0
      @user.humanizer_answer = "4"
      expect(@user.humanizer_correct_answer?).to be_truthy
      @user.humanizer_answer = "four"
      expect(@user.humanizer_correct_answer?).to be_truthy
    end

    it "is case-insensitive" do
      @user.humanizer_question_id = 1
      @user.humanizer_answer = "HILL"
      expect(@user.humanizer_correct_answer?).to be_truthy
      @user.humanizer_answer = "hiLL"
      expect(@user.humanizer_correct_answer?).to be_truthy
    end

    it "cannot be nil" do
      @user.humanizer_question_id = 0
      @user.humanizer_answer = nil
      expect(@user.humanizer_correct_answer?).to be_falsey
    end

    it "cannot be an answer that doesn't match" do
      @user.humanizer_question_id = 1
      @user.humanizer_answer = "slope"
      expect(@user.humanizer_correct_answer?).to be_falsey
    end

    it "can have extra spaces in begin and end" do
      @user.humanizer_question_id = 0
      @user.humanizer_answer = "4"
      expect(@user.humanizer_correct_answer?).to be_truthy
      @user.humanizer_answer = " 4"
      expect(@user.humanizer_correct_answer?).to be_truthy
      @user.humanizer_answer = "4 "
      expect(@user.humanizer_correct_answer?).to be_truthy
      @user.humanizer_answer = " 4 "
      expect(@user.humanizer_correct_answer?).to be_truthy
    end

    it "is can be an answer when question(as string)" do
      @user.humanizer_question_id = "0"
      @user.humanizer_answer = "4"
      expect(@user.humanizer_correct_answer?).to be_truthy
    end

    it "is cannot be an answer when question(as string) not exists" do
      @user.humanizer_question_id = "10_000"
      expect(@user.humanizer_correct_answer?).to be_falsey
    end

    it "is cannot be an answer when question not exists" do
      @user.humanizer_question_id = 10_000
      expect(@user.humanizer_correct_answer?).to be_falsey
    end
  end

  describe "#change_humanizer_question" do

    it "sets humanizer_question_id with no params" do
      @user.change_humanizer_question
      expect(@user.instance_variable_get(:@humanizer_question_id)).not_to be_nil
    end

    context "when passing in a value" do

      before(:each) do
        questions = double(:count => 4)
        allow(@user).to receive(:humanizer_questions).and_return(questions)
        expect(@user.send(:humanizer_question_ids)).to eq([0,1,2,3])
      end

      it "removes the question from the possible questions" do
        @user.change_humanizer_question(2)
        expect(@user.send(:humanizer_question_ids)).to eq([0,1,3])
      end

      it "reloads the questions when it runs out" do
        3.times { |i| @user.change_humanizer_question(i) }
        expect(@user.send(:humanizer_question_ids)).to eq([3])
        @user.change_humanizer_question(3)
        expect(@user.send(:humanizer_question_ids)).to eq([0,1,2])
      end

    end

  end

end
