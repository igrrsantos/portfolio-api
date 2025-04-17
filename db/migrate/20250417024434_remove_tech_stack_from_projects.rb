class RemoveTechStackFromProjects < ActiveRecord::Migration[7.1]
  def change
    remove_column :projects, :tech_stack, :string
  end
end
