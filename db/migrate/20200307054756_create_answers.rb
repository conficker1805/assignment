class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :respondent_answers do |t|
      t.references :question, null: false, index: true
      t.references :respondent, null: false, index: true
      t.text :body

      t.timestamps null: false
    end
  end
end
