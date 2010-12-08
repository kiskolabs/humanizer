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
    
  end
  
  context "question" do
    
    context "id" do
      
      it "is a random index for the questions array" do
        Kernel.should_receive(:rand).with(2).and_return(1)
        @user.humanizer_question_id.should == 1
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
    
  end
  
  context "generate_random_question_id" do
    
    it "sets humanizer_question_id with no params" do
      @user.generate_random_question_id
      @user.instance_variable_get(:@humanizer_question_id).should_not be_nil
    end
    context 'when passing in a value' do
      before do
        # return 5 for humanizer question id the first and second time
        @user.should_receive(:humanizer_question_id).and_return(5)
        @user.should_receive(:humanizer_question_id).and_return(5)        
        # return 6(a different value) for humanizer question id the third time
        @user.should_receive(:humanizer_question_id).and_return(6)
        # ensure that change humanizer question id was called twice
        @user.should_receive(:change_humanizer_question_id).twice
        
      end
      it "sets humanizer_question_id to a new value" do
        @user.generate_random_question_id(5)
      end
    end
  end
end