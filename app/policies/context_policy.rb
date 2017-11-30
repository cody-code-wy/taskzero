class ContextPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @record.user == @user
  end

  def create?
    @user
  end

  def update?
    @record.user == @user
  end

  def destroy?
    @record.user == @user
  end

  class Scope < Scope
    def resolve
      @scope.where(user: @user)
    end
  end
end
