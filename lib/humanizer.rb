module Humanizer
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  attr_accessor :humanizer_answer
  attr_writer :humanizer_question_id

  def humanizer_question
    humanizer_questions[humanizer_question_id.to_i]["question"]
  end
  
  def humanizer_question_id
    @humanizer_question_id ||= random_humanizer_question_id
  end
  
  def change_humanizer_question(current=nil)
    @humanizer_question_ids = nil if humanizer_question_ids.compact.count == 1
    humanizer_question_ids.delete(current) if current
    @humanizer_question_id = random_humanizer_question_id
  end
    
  def humanizer_correct_answer?
    humanizer_answer && 
      humanizer_answers_for_id(humanizer_question_id).include?(humanizer_answer.mb_chars.downcase.strip)
  end

  private

  def humanizer_questions
    @humanizer_questions ||= begin
      questions = I18n.translate!("humanizer.questions")
      # Poor man's HashWithIndifferentAccess
      questions.map do |question|
        question.default_proc = proc do |h, k|
           case k
             when String then sym = k.to_sym; h[sym] if h.key?(sym)
             when Symbol then str = k.to_s; h[str] if h.key?(str)
           end
        end
      end
      questions
    end
  end

  def humanizer_question_ids
    @humanizer_question_ids ||= (0...humanizer_questions.count).to_a
  end

  def random_humanizer_question_id
    humanizer_question_ids[rand(humanizer_question_ids.count)]
  end

  def humanizer_answers_for_id(id)
    question = humanizer_questions[id.to_i]
    Array(question["answer"] || question["answers"]).map { |a| a.to_s.mb_chars.downcase }
  end

  def humanizer_check_answer
    errors.add(:humanizer_answer, I18n.translate("humanizer.validation.error")) unless humanizer_correct_answer?
  end
  
  module ClassMethods
    
    def require_human_on(validate_on = nil, opts = {})
      opts[:on] = validate_on if validate_on
      validate :humanizer_check_answer,  opts
    end
    
  end
  
end
