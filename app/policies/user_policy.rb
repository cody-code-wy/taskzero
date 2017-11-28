class UserPolicy < ApplicationPolicy

  def show?
    @user == @record
  end

  def create?
    not @user
  end

  def new?
    create?
  end

  def update?
    @user == @record
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  class Scope < Scope

    def resolve
      scope
    end
  end
end
