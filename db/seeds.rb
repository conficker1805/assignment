ActiveRecord::Base.connection.execute("TRUNCATE questions RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE respondents RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE respondent_answers RESTART IDENTITY CASCADE")

# Questions
questions = Rails.root.join('db', 'seeds', 'questions.yml')
Question.create!(YAML::load_file(questions))

# Respondents
respondents = YAML::load_file(Rails.root.join('db', 'seeds', 'respondents.yml'))
respondents.each{ |i| i['profile_attributes'] = i.delete('profile') }
Respondent.create respondents
