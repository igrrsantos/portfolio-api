class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.string :tech_stack
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
