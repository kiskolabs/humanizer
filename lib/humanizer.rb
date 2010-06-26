require 'humanizer_question'
module Humanizer

    def require_human_on(validate_on)
        class_eval do
          validate :humanizer_answer, :on => validate_on
          attr_accessor :humanizer_question_answer, :humanizer_question_id

          def initialize(attributes = {})
            super
            case ActiveRecord::Base.connection.adapter_name
            when 'MySQL'
              random_sql='rand()'
            when 'SQLite'
              random_sql='random()'
            end
            self.humanizer_question_id = HumanizerQuestion.find(:first, :order => random_sql).id if self.humanizer_question_id.nil?
          end
          
          
          def humanizer_answer
            if humanizer_question_answer.nil? or humanizer_question_answer.downcase != HumanizerQuestion.find(humanizer_question_id).answer.downcase
              errors[:base] << (I18n::t("humanizer.validation.error"))
              
            end
          end
        end
      
    end
    
end

ActiveRecord::Base.extend Humanizer