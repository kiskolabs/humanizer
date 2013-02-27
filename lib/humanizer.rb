module Humanizer
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  attr_accessor :humanizer_answer
  attr_writer :humanizer_question_id

  def humanizer_question
    self.class.humanizer_questions[humanizer_question_id.to_i]["question"]
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
    humanizer_answer && humanizer_answers_for_id(humanizer_question_id).include?(humanizer_answer.mb_chars.downcase)
  end

  private
  
  def humanizer_questions
    puts "Instanse method `humanizer_questions` is deprecated and will be removed from Humanizer user Class Method `humanizer_questions` instead."
    self.class.humanizer_questions
  end  
  

  def humanizer_question_ids
    @humanizer_question_ids ||= (0...self.class.humanizer_questions.count).to_a
  end

  def random_humanizer_question_id
    humanizer_question_ids[rand(humanizer_question_ids.count)]
  end

  def humanizer_answers_for_id(id)
    question = self.class.humanizer_questions[id.to_i]
    Array(question["answer"] || question["answers"]).map { |a| a.to_s.mb_chars.downcase }
  end

  def humanizer_check_answer
    errors.add(:humanizer_answer, I18n.translate("humanizer.validation.error")) unless humanizer_correct_answer?
  end
  
  module ClassMethods
    def humanizer_questions
      # Let humanizer_questions in memory as random sorting and random pick 20 items, 
      # and it will reload and get new random sorting in next day
      if @humanizer_questions_cache_date != Time.now.to_date
        @humanizer_questions_cache_date = Time.now.to_date
        @humanizer_questions = nil
      end
      @humanizer_questions ||= I18n.translate("humanizer.questions").sample(20).shuffle
    end
    
    def require_human_on(validate_on, opts = {})
      opts[:on] = validate_on
      validate :humanizer_check_answer,  opts
    end
    
  end
  
end
