class Project < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :project_tech_tags, dependent: :destroy
  has_many :tech_tags, through: :project_tech_tags

  def tech_tag_names
    tech_tags.pluck(:name)
  end
end
