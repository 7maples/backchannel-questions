class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :body
      t.integer :user_id
      t.integer :track_id

      t.timestamps
    end
  end
end
