class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.text :name
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.integer :kind
      t.boolean :on_hold

      t.timestamps
    end
  end
end
