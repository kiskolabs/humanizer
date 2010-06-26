ActiveRecord::Schema.define :version => 0 do
  create_table :humanizer_questions, :force => true do |t|
    t.column :question, :string
    t.column :answer, :string
  end
  create_table :user_models, :force => true do |t|
    t.column :name, :string
  end  
end
