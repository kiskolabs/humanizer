class CreateHumanizerQuestions < ActiveRecord::Migration
  
  def self.up
    create_table :humanizer_questions, :force => true do |t|
      t.column :question, :string
      t.column :answer, :string
    end
    
    create "What is two plus two?", "4"
    create "What is the number before twelve?", "11"
    create "Five times two is what?", "10"
    create "Insert the next number in this sequence: 10, 11, 12, 13, 14, ??", "15"
    create "What is five times five?", "25"
    create "Ten divided by two is what?", "5"
    create "What day comes after Monday?", "tuesday"
    create "What is the last month of the year?", "december"
    create "How many minutes are in an hour?", "60"
    create "What is the opposite of down?", "up"
    create "What is the opposite of north?", "south"
    create "What is the opposite of bad?", "good"
    create "Complete the following: 'Jack and Jill went up the ???", "hill"
    create "What is 4 times four?", "16"
    create "What number comes after 20?", "21"
    create "What month comes before July?", "june"
    create "What is fifteen divided by three?", "5"
    create "What is 14 minus 4?", "10"
    create "What comes next? 'Monday Tuesday Wednesday ?????'", "Thursday"
  end

  def self.down
    drop_table :humanizer_questions
  end
  
  def self.create(question, answer)
    HumanizerQuestion.create(:question => question, :answer => answer.downcase)
  end
end
