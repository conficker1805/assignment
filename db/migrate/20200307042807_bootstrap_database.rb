class BootstrapDatabase < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :type, index: true
      t.text :prompt
      t.boolean :optional, null: false
      t.timestamps null: false
    end

    create_table :respondents do |t|
      t.string :identifier, null: false, index: true, unique: true
      t.timestamps null: false
    end

    create_table :respondent_profiles do |t|
      t.string :gender
      t.string :department
      t.references :respondent, null: false, index: true

      t.timestamps null: false
    end
  end
end
