class Project < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true
  has_many :projects

  validates_presence_of :name, :kind

  enum kind: { grouping: 1, linear: 2 }
end
