class Task < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :context, optional: true
  belongs_to :user

  enum kind: { normal: 1, apointment: 2, chore: 3 }

  validates_presence_of :name, :kind
end
