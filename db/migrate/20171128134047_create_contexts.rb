class CreateContexts < ActiveRecord::Migration[5.0]
  def change
    create_table :contexts do |t|
      t.references :context, foreign_key: true
      t.text :name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
