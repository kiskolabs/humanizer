Humanizer is a very simple CAPTCHA method. It has a table with questions and answers which is used to validate that the user is an actual human. Currently only Mysql an Sqlite3 are supported.

### Installation

1. gem install humanizer
2. rails g humanizer
3. rake db:migrate

### Usage

1. In your model add require_human_on method, example:

          class User < ActiveRecord::Base
            require_human_on :create
          end

2. Ask the question in the form, example:

          <%= f.label :humanizer_question_answer, HumanizerQuestion.find(@user.humanizer_question_id).question, :class => "required" %>
          <%= f.text_field :humanizer_question_answer %>
          <%= f.hidden_field :humanizer_question_id, :value => @user.humanizer_question_id %>

### Configuration

Default translations can be found from config/locales/humanizer.en.yml

You might want to add / change question and answer pairs. This can be easily done by adding / modifying entries in HumanizerQuestion model