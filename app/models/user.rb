class User < ApplicationRecord
  require 'mail'

  has_secure_password

  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
  validates :password, length: { minimum: 8 }, allow_nil: true
  validate :email_valid?

  has_many :contexts
  has_many :projects
  has_many :tasks

  model_name.instance_variable_set(:@route_key, 'user')

  private

  def email_valid?
    Mail::Address.new(email)
  rescue
    errors.add(:email, 'Invalid Email Address')
  end
end
