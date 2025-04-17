class TechTag < ApplicationRecord
  has_many :project_tech_tags, dependent: :destroy
  has_many :projects, through: :project_tech_tags
end
