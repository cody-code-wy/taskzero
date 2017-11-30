class Context < ApplicationRecord
  belongs_to :context, optional: true
  has_many :contexts
  belongs_to :user

  validates_presence_of :name

  def get_full_name
    fullname = ""
    fullname += "#{context.get_full_name}:" if context
    fullname += name
  end
end
