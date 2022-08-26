# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def admin?
    user&.admin?
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  ASSOCIATION_ACTIONS = [:view, :edit, :attach, :detach, :create, :edit, :destroy].freeze

  class << self
    # TODO: Move to Shimmer (?)
    def allow_association_actions(association_names, *allowed_actions, **options)
      options.reverse_merge! except: [], if: nil
      allowed_actions = (allowed_actions.presence || ASSOCIATION_ACTIONS) - options[:except]
      ASSOCIATION_ACTIONS.each do |action|
        Array.wrap(association_names).each do |association_name|
          define_method "#{action}_#{association_name}?" do
            allowed_actions.include?(action) && (!options[:if] || send(options[:if]))
          end
        end
      end
    end
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
