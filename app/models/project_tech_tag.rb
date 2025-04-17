class ProjectTechTag < ApplicationRecord
  belongs_to :project
  belongs_to :tech_tag
end
