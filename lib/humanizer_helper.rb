class HumanizerHelper
  include ActiveModel::Validations
  include Humanizer

  def initialize(options={})
    options[:humanizer_question_id] = options[:humanizer_question_id].to_i unless options[:humanizer_question_id].nil?
    options.each do |k, v|
      self.send("#{k}=", v)
    end

    humanizer_question_id
  end

  def get_correct_humanizer_answer
    humanizer_answers_for_id(humanizer_question_id.to_i)[0]
  end
end
