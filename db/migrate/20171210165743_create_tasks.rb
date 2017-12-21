class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.text :name
      t.integer :kind
      t.text :description
      t.date :deferred_date
      t.text :delegate
      t.text :delegate_note
      t.boolean :complete
      t.references :project, foreign_key: true
      t.references :context, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
