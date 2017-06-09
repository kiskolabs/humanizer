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
      questions.count.should == 2
      questions[0]["question"].should == "Two plus two?"
      questions[0]["answers"].should == ["4", "four"]
      questions[1]["question"].should == "Jack and Jill went up the..."
      questions[1]["answer"].should == "hill"
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
        @user.should_receive(:humanizer_questions).and_return([1])
        @user.humanizer_question_id.should == 0
      end

    end

    it "is retrieved based on the set id" do
      @user.should_receive(:humanizer_question_id).and_return(0)
      @user.humanizer_question.should == "Two plus two?"
      @user.should_receive(:humanizer_question_id).and_return(1)
      @user.humanizer_question.should == "Jack and Jill went up the..."
    end

  end

  context "answer" do

    it "is retrieved for a given id" do
      answers_for_id_0 = @user.send(:humanizer_answers_for_id, 0)
      answers_for_id_1 = @user.send(:humanizer_answers_for_id, 1)
      answers_for_id_0.count.should == 2
      answers_for_id_0.should include("4")
      answers_for_id_0.should include("four")
      answers_for_id_1.should == ["hill"]
    end

  end

  context "correct answer" do

    it "can be any of the answers" do
      @user.humanizer_question_id = 0
      @user.humanizer_answer = "4"
      @user.humanizer_correct_answer?.should be_true
      @user.humanizer_answer = "four"
      @user.humanizer_correct_answer?.should be_true
    end

    it "is case-insensitive" do
      @user.humanizer_question_id = 1
      @user.humanizer_answer = "HILL"
      @user.humanizer_correct_answer?.should be_true
      @user.humanizer_answer = "hiLL"
      @user.humanizer_correct_answer?.should be_true
    end

    it "cannot be nil" do
      @user.humanizer_question_id = 0
      @user.humanizer_answer = nil
      @user.humanizer_correct_answer?.should be_false
    end

    it "cannot be an answer that doesn't match" do
      @user.humanizer_question_id = 1
      @user.humanizer_answer = "slope"
      @user.humanizer_correct_answer?.should be_false
    end

    it "can have extra spaces in begin and end" do
      @user.humanizer_question_id = 0
      @user.humanizer_answer = "4"
      @user.humanizer_correct_answer?.should be_true
      @user.humanizer_answer = " 4"
      @user.humanizer_correct_answer?.should be_true
      @user.humanizer_answer = "4 "
      @user.humanizer_correct_answer?.should be_true
      @user.humanizer_answer = " 4 "
      @user.humanizer_correct_answer?.should be_true
    end

    it "is cannot be an answer when questing not exist" do
      @user.humanizer_question_id = 10_000
      @user.humanizer_correct_answer?.should be_false
    end

  end

  describe "#change_humanizer_question" do

    it "sets humanizer_question_id with no params" do
      @user.change_humanizer_question
      @user.instance_variable_get(:@humanizer_question_id).should_not be_nil
    end

    context "when passing in a value" do

      before(:each) do
        questions = double(:count => 4)
        @user.stub(:humanizer_questions).and_return(questions)
        @user.send(:humanizer_question_ids).should == [0,1,2,3]
      end

      it "removes the question from the possible questions" do
        @user.change_humanizer_question(2)
        @user.send(:humanizer_question_ids).should == [0,1,3]
      end

      it "reloads the questions when it runs out" do
        3.times { |i| @user.change_humanizer_question(i) }
        @user.send(:humanizer_question_ids).should == [3]
        @user.change_humanizer_question(3)
        @user.send(:humanizer_question_ids).should == [0,1,2]
      end

    end

  end

end
