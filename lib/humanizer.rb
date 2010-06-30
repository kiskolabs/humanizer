module Humanizer
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  attr_accessor :humanizer_answer
  attr_writer :humanizer_question_id

  def humanizer_question
    humanizer_questions[humanizer_question_id]["question"]
  end
  
  def humanizer_question_id
    @humanizer_question_id ||= Kernel.rand(humanizer_questions.count)
  end
  
  def humanizer_correct_answer?
    humanizer_answer && humanizer_answers_for_id(humanizer_question_id).include?(humanizer_answer.downcase)
  end

  private
  
  def humanizer_questions
    @humanizer_questions ||= I18n.translate("humanizer.questions")
  end

  def humanizer_answers_for_id(id)
    answers = (humanizer_questions[id.to_i]["answer"] || humanizer_questions[id.to_i]["answers"]).to_a
    answers.map { |a| a.to_s.downcase }
  end

  def humanizer_check_answer
    errors[:base] << I18n.translate("humanizer.validation.error") unless humanizer_correct_answer?
  end
  
  module ClassMethods
    
    def require_human_on(validate_on)
      validate :humanizer_check_answer, :on => validate_on
    end
    
  end
  
end