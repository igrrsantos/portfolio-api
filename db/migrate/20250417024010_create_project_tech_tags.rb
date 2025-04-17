class CreateProjectTechTags < ActiveRecord::Migration[7.1]
  def change
    create_table :project_tech_tags do |t|
      t.references :project, null: false, foreign_key: true
      t.references :tech_tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
