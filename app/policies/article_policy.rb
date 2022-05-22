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
end
