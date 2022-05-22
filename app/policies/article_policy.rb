class ArticlePolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user == record.user
  end

  def destroy?
    update?
  end

  def add_favorite?
    user.present? && record.published?
  end

  def remove_favorite?
    user.present?
  end

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.present?
        scope
          .where(published: true)
          .or(scope.where(user_id: user.id))
      else
        scope.where(published: true)
      end
    end

    private

    attr_reader :user, :scope
  end
end
