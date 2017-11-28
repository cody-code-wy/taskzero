class Context < ApplicationRecord
  belongs_to :context, optional: true
  has_many :contexts
  belongs_to :user
end
