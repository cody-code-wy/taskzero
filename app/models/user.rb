class User < ApplicationRecord
  require 'mail'

  has_secure_password

  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
  validates :password, length: {minimum: 8}
  validate :email_valid?

  private

  def email_valid?
    begin
      Mail::Address.new(email)
    rescue
      errors.add(:email, 'Invalid Email Address')
    end
  end
end
