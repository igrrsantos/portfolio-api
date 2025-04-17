class CreateTechTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tech_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
