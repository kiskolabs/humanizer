require "spec_helper"

describe Humanizer do
  before(:each) do
    clean_database!
  end
  
  describe "validate as human - should fail if now answer is given" do
    @user = UserModel.new(:name => "plaa")
    @user.save.should == false
  end
  
  describe "validate as human - should fail if wrong answer is given" do
    @user = UserModel.new(:name => "plaa", :humanizer_question_answer => "wrong")
    @user.save.should == false
  end
  
  describe "validate as human - should pass if correct answer is given" do
    @user = UserModel.new(:name => "plaa")
    @user.humanizer_question_answer = HumanizerQuestion.find(@user.humanizer_question_id).answer
    @user.save.should == true
  end

end