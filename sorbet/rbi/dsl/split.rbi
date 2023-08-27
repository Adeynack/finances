# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Split`.
# Please instead update this file by running `bin/tapioca dsl Split`.

class Split
  include GeneratedAssociationMethods
  include GeneratedAttributeMethods
  extend CommonRelationMethods
  extend GeneratedRelationMethods

  private

  sig { returns(NilClass) }
  def to_ary; end

  module CommonRelationMethods
    sig { params(block: T.nilable(T.proc.params(record: ::Split).returns(T.untyped))).returns(T::Boolean) }
    def any?(&block); end

    sig { params(column_name: T.any(String, Symbol)).returns(T.untyped) }
    def average(column_name); end

    sig { params(attributes: T.untyped, block: T.nilable(T.proc.params(object: ::Split).void)).returns(::Split) }
    def build(attributes = nil, &block); end

    sig { params(operation: Symbol, column_name: T.any(String, Symbol)).returns(T.untyped) }
    def calculate(operation, column_name); end

    sig { params(column_name: T.untyped).returns(T.untyped) }
    def count(column_name = nil); end

    sig { params(attributes: T.untyped, block: T.nilable(T.proc.params(object: ::Split).void)).returns(::Split) }
    def create(attributes = nil, &block); end

    sig { params(attributes: T.untyped, block: T.nilable(T.proc.params(object: ::Split).void)).returns(::Split) }
    def create!(attributes = nil, &block); end

    sig { params(attributes: T.untyped, block: T.nilable(T.proc.params(object: ::Split).void)).returns(::Split) }
    def create_or_find_by(attributes, &block); end

    sig { params(attributes: T.untyped, block: T.nilable(T.proc.params(object: ::Split).void)).returns(::Split) }
    def create_or_find_by!(attributes, &block); end

    sig { returns(T::Array[::Split]) }
    def destroy_all; end

    sig { params(conditions: T.untyped).returns(T::Boolean) }
    def exists?(conditions = :none); end

    sig { returns(T.nilable(::Split)) }
    def fifth; end

    sig { returns(::Split) }
    def fifth!; end

    sig { params(args: T.untyped).returns(T.untyped) }
    def find(*args); end

    sig { params(args: T.untyped).returns(T.nilable(::Split)) }
    def find_by(*args); end

    sig { params(args: T.untyped).returns(::Split) }
    def find_by!(*args); end

    sig do
      params(
        start: T.untyped,
        finish: T.untyped,
        batch_size: Integer,
        error_on_ignore: T.untyped,
        order: Symbol,
        block: T.nilable(T.proc.params(object: ::Split).void)
      ).returns(T.nilable(T::Enumerator[::Split]))
    end
    def find_each(start: nil, finish: nil, batch_size: 1000, error_on_ignore: nil, order: :asc, &block); end

    sig do
      params(
        start: T.untyped,
        finish: T.untyped,
        batch_size: Integer,
        error_on_ignore: T.untyped,
        order: Symbol,
        block: T.nilable(T.proc.params(object: T::Array[::Split]).void)
      ).returns(T.nilable(T::Enumerator[T::Enumerator[::Split]]))
    end
    def find_in_batches(start: nil, finish: nil, batch_size: 1000, error_on_ignore: nil, order: :asc, &block); end

    sig { params(attributes: T.untyped, block: T.nilable(T.proc.params(object: ::Split).void)).returns(::Split) }
    def find_or_create_by(attributes, &block); end

    sig { params(attributes: T.untyped, block: T.nilable(T.proc.params(object: ::Split).void)).returns(::Split) }
    def find_or_create_by!(attributes, &block); end

    sig { params(attributes: T.untyped, block: T.nilable(T.proc.params(object: ::Split).void)).returns(::Split) }
    def find_or_initialize_by(attributes, &block); end

    sig { params(signed_id: T.untyped, purpose: T.untyped).returns(T.nilable(::Split)) }
    def find_signed(signed_id, purpose: nil); end

    sig { params(signed_id: T.untyped, purpose: T.untyped).returns(::Split) }
    def find_signed!(signed_id, purpose: nil); end

    sig { params(arg: T.untyped, args: T.untyped).returns(::Split) }
    def find_sole_by(arg, *args); end

    sig { params(limit: T.untyped).returns(T.untyped) }
    def first(limit = nil); end

    sig { returns(::Split) }
    def first!; end

    sig { returns(T.nilable(::Split)) }
    def forty_two; end

    sig { returns(::Split) }
    def forty_two!; end

    sig { returns(T.nilable(::Split)) }
    def fourth; end

    sig { returns(::Split) }
    def fourth!; end

    sig { returns(Array) }
    def ids; end

    sig do
      params(
        of: Integer,
        start: T.untyped,
        finish: T.untyped,
        load: T.untyped,
        error_on_ignore: T.untyped,
        order: Symbol,
        block: T.nilable(T.proc.params(object: PrivateRelation).void)
      ).returns(T.nilable(::ActiveRecord::Batches::BatchEnumerator))
    end
    def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, order: :asc, &block); end

    sig { params(record: T.untyped).returns(T::Boolean) }
    def include?(record); end

    sig { params(limit: T.untyped).returns(T.untyped) }
    def last(limit = nil); end

    sig { returns(::Split) }
    def last!; end

    sig { params(block: T.nilable(T.proc.params(record: ::Split).returns(T.untyped))).returns(T::Boolean) }
    def many?(&block); end

    sig { params(column_name: T.any(String, Symbol)).returns(T.untyped) }
    def maximum(column_name); end

    sig { params(record: T.untyped).returns(T::Boolean) }
    def member?(record); end

    sig { params(column_name: T.any(String, Symbol)).returns(T.untyped) }
    def minimum(column_name); end

    sig { params(attributes: T.untyped, block: T.nilable(T.proc.params(object: ::Split).void)).returns(::Split) }
    def new(attributes = nil, &block); end

    sig { params(block: T.nilable(T.proc.params(record: ::Split).returns(T.untyped))).returns(T::Boolean) }
    def none?(&block); end

    sig { params(block: T.nilable(T.proc.params(record: ::Split).returns(T.untyped))).returns(T::Boolean) }
    def one?(&block); end

    sig { params(column_names: T.untyped).returns(T.untyped) }
    def pick(*column_names); end

    sig { params(column_names: T.untyped).returns(T.untyped) }
    def pluck(*column_names); end

    sig { returns(T.nilable(::Split)) }
    def second; end

    sig { returns(::Split) }
    def second!; end

    sig { returns(T.nilable(::Split)) }
    def second_to_last; end

    sig { returns(::Split) }
    def second_to_last!; end

    sig { returns(::Split) }
    def sole; end

    sig do
      params(
        column_name: T.nilable(T.any(String, Symbol)),
        block: T.nilable(T.proc.params(record: T.untyped).returns(T.untyped))
      ).returns(T.untyped)
    end
    def sum(column_name = nil, &block); end

    sig { params(limit: T.untyped).returns(T.untyped) }
    def take(limit = nil); end

    sig { returns(::Split) }
    def take!; end

    sig { returns(T.nilable(::Split)) }
    def third; end

    sig { returns(::Split) }
    def third!; end

    sig { returns(T.nilable(::Split)) }
    def third_to_last; end

    sig { returns(::Split) }
    def third_to_last!; end
  end

  module GeneratedAssociationMethods
    sig { params(args: T.untyped, blk: T.untyped).returns(::Exchange) }
    def build_exchange(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(::Register) }
    def build_register(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(::Exchange) }
    def create_exchange(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(::Exchange) }
    def create_exchange!(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(::Register) }
    def create_register(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(::Register) }
    def create_register!(*args, &blk); end

    sig { returns(T.nilable(::Exchange)) }
    def exchange; end

    sig { params(value: T.nilable(::Exchange)).void }
    def exchange=(value); end

    sig { returns(T::Array[T.untyped]) }
    def import_origin_ids; end

    sig { params(ids: T::Array[T.untyped]).returns(T::Array[T.untyped]) }
    def import_origin_ids=(ids); end

    # This method is created by ActiveRecord on the `Split` class because it declared `has_many :import_origins`.
    # 🔗 [Rails guide for `has_many` association](https://guides.rubyonrails.org/association_basics.html#the-has-many-association)
    sig { returns(::ImportOrigin::PrivateCollectionProxy) }
    def import_origins; end

    sig { params(value: T::Enumerable[::ImportOrigin]).void }
    def import_origins=(value); end

    sig { returns(T.nilable(::Register)) }
    def register; end

    sig { params(value: T.nilable(::Register)).void }
    def register=(value); end

    sig { returns(T.nilable(::Exchange)) }
    def reload_exchange; end

    sig { returns(T.nilable(::Register)) }
    def reload_register; end

    sig { returns(T::Array[T.untyped]) }
    def tag_ids; end

    sig { params(ids: T::Array[T.untyped]).returns(T::Array[T.untyped]) }
    def tag_ids=(ids); end

    sig { returns(T::Array[T.untyped]) }
    def tagging_ids; end

    sig { params(ids: T::Array[T.untyped]).returns(T::Array[T.untyped]) }
    def tagging_ids=(ids); end

    # This method is created by ActiveRecord on the `Split` class because it declared `has_many :taggings`.
    # 🔗 [Rails guide for `has_many` association](https://guides.rubyonrails.org/association_basics.html#the-has-many-association)
    sig { returns(::Tagging::PrivateCollectionProxy) }
    def taggings; end

    sig { params(value: T::Enumerable[::Tagging]).void }
    def taggings=(value); end

    # This method is created by ActiveRecord on the `Split` class because it declared `has_many :tags, through: :taggings`.
    # 🔗 [Rails guide for `has_many_through` association](https://guides.rubyonrails.org/association_basics.html#the-has-many-through-association)
    sig { returns(::Tag::PrivateCollectionProxy) }
    def tags; end

    sig { params(value: T::Enumerable[::Tag]).void }
    def tags=(value); end
  end

  module GeneratedAssociationRelationMethods
    sig { returns(PrivateAssociationRelation) }
    def all; end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def and(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def annotate(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def create_with(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def distinct(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def eager_load(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def except(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def excluding(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def extending(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def extract_associated(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def from(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def group(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def having(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def in_order_of(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def includes(*args, &blk); end

    sig do
      params(
        attributes: Hash,
        returning: T.nilable(T.any(T::Array[Symbol], FalseClass)),
        unique_by: T.nilable(T.any(T::Array[Symbol], Symbol))
      ).returns(ActiveRecord::Result)
    end
    def insert(attributes, returning: nil, unique_by: nil); end

    sig do
      params(
        attributes: Hash,
        returning: T.nilable(T.any(T::Array[Symbol], FalseClass))
      ).returns(ActiveRecord::Result)
    end
    def insert!(attributes, returning: nil); end

    sig do
      params(
        attributes: T::Array[Hash],
        returning: T.nilable(T.any(T::Array[Symbol], FalseClass)),
        unique_by: T.nilable(T.any(T::Array[Symbol], Symbol))
      ).returns(ActiveRecord::Result)
    end
    def insert_all(attributes, returning: nil, unique_by: nil); end

    sig do
      params(
        attributes: T::Array[Hash],
        returning: T.nilable(T.any(T::Array[Symbol], FalseClass))
      ).returns(ActiveRecord::Result)
    end
    def insert_all!(attributes, returning: nil); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def invert_where(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def joins(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def left_joins(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def left_outer_joins(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def limit(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def lock(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def merge(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def none(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def offset(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def only(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def optimizer_hints(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def or(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def order(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def preload(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def readonly(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def references(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def reorder(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def reselect(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def reverse_order(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def rewhere(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def scope_if(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def scope_unless(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def select(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def strict_loading(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def structurally_compatible?(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def uniq!(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def unscope(*args, &blk); end

    sig do
      params(
        attributes: Hash,
        returning: T.nilable(T.any(T::Array[Symbol], FalseClass)),
        unique_by: T.nilable(T.any(T::Array[Symbol], Symbol))
      ).returns(ActiveRecord::Result)
    end
    def upsert(attributes, returning: nil, unique_by: nil); end

    sig do
      params(
        attributes: T::Array[Hash],
        returning: T.nilable(T.any(T::Array[Symbol], FalseClass)),
        unique_by: T.nilable(T.any(T::Array[Symbol], Symbol))
      ).returns(ActiveRecord::Result)
    end
    def upsert_all(attributes, returning: nil, unique_by: nil); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelationWhereChain) }
    def where(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateAssociationRelation) }
    def without(*args, &blk); end
  end

  module GeneratedAttributeMethods
    sig { returns(::Integer) }
    def amount; end

    sig { params(value: ::Integer).returns(::Integer) }
    def amount=(value); end

    sig { returns(T::Boolean) }
    def amount?; end

    sig { returns(T.nilable(::Integer)) }
    def amount_before_last_save; end

    sig { returns(T.untyped) }
    def amount_before_type_cast; end

    sig { returns(T::Boolean) }
    def amount_came_from_user?; end

    sig { returns(T.nilable([::Integer, ::Integer])) }
    def amount_change; end

    sig { returns(T.nilable([::Integer, ::Integer])) }
    def amount_change_to_be_saved; end

    sig { returns(T::Boolean) }
    def amount_changed?; end

    sig { returns(T.nilable(::Integer)) }
    def amount_in_database; end

    sig { returns(T.nilable([::Integer, ::Integer])) }
    def amount_previous_change; end

    sig { returns(T::Boolean) }
    def amount_previously_changed?; end

    sig { returns(T.nilable(::Integer)) }
    def amount_previously_was; end

    sig { returns(T.nilable(::Integer)) }
    def amount_was; end

    sig { void }
    def amount_will_change!; end

    sig { returns(T.nilable(::Integer)) }
    def counterpart_amount; end

    sig { params(value: T.nilable(::Integer)).returns(T.nilable(::Integer)) }
    def counterpart_amount=(value); end

    sig { returns(T::Boolean) }
    def counterpart_amount?; end

    sig { returns(T.nilable(::Integer)) }
    def counterpart_amount_before_last_save; end

    sig { returns(T.untyped) }
    def counterpart_amount_before_type_cast; end

    sig { returns(T::Boolean) }
    def counterpart_amount_came_from_user?; end

    sig { returns(T.nilable([T.nilable(::Integer), T.nilable(::Integer)])) }
    def counterpart_amount_change; end

    sig { returns(T.nilable([T.nilable(::Integer), T.nilable(::Integer)])) }
    def counterpart_amount_change_to_be_saved; end

    sig { returns(T::Boolean) }
    def counterpart_amount_changed?; end

    sig { returns(T.nilable(::Integer)) }
    def counterpart_amount_in_database; end

    sig { returns(T.nilable([T.nilable(::Integer), T.nilable(::Integer)])) }
    def counterpart_amount_previous_change; end

    sig { returns(T::Boolean) }
    def counterpart_amount_previously_changed?; end

    sig { returns(T.nilable(::Integer)) }
    def counterpart_amount_previously_was; end

    sig { returns(T.nilable(::Integer)) }
    def counterpart_amount_was; end

    sig { void }
    def counterpart_amount_will_change!; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def created_at; end

    sig { params(value: ::ActiveSupport::TimeWithZone).returns(::ActiveSupport::TimeWithZone) }
    def created_at=(value); end

    sig { returns(T::Boolean) }
    def created_at?; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def created_at_before_last_save; end

    sig { returns(T.untyped) }
    def created_at_before_type_cast; end

    sig { returns(T::Boolean) }
    def created_at_came_from_user?; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def created_at_change; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def created_at_change_to_be_saved; end

    sig { returns(T::Boolean) }
    def created_at_changed?; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def created_at_in_database; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def created_at_previous_change; end

    sig { returns(T::Boolean) }
    def created_at_previously_changed?; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def created_at_previously_was; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def created_at_was; end

    sig { void }
    def created_at_will_change!; end

    sig { returns(T.untyped) }
    def exchange_id; end

    sig { params(value: T.untyped).returns(T.untyped) }
    def exchange_id=(value); end

    sig { returns(T::Boolean) }
    def exchange_id?; end

    sig { returns(T.untyped) }
    def exchange_id_before_last_save; end

    sig { returns(T.untyped) }
    def exchange_id_before_type_cast; end

    sig { returns(T::Boolean) }
    def exchange_id_came_from_user?; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def exchange_id_change; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def exchange_id_change_to_be_saved; end

    sig { returns(T::Boolean) }
    def exchange_id_changed?; end

    sig { returns(T.untyped) }
    def exchange_id_in_database; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def exchange_id_previous_change; end

    sig { returns(T::Boolean) }
    def exchange_id_previously_changed?; end

    sig { returns(T.untyped) }
    def exchange_id_previously_was; end

    sig { returns(T.untyped) }
    def exchange_id_was; end

    sig { void }
    def exchange_id_will_change!; end

    sig { returns(T.untyped) }
    def id; end

    sig { params(value: T.untyped).returns(T.untyped) }
    def id=(value); end

    sig { returns(T::Boolean) }
    def id?; end

    sig { returns(T.untyped) }
    def id_before_last_save; end

    sig { returns(T.untyped) }
    def id_before_type_cast; end

    sig { returns(T::Boolean) }
    def id_came_from_user?; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def id_change; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def id_change_to_be_saved; end

    sig { returns(T::Boolean) }
    def id_changed?; end

    sig { returns(T.untyped) }
    def id_in_database; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def id_previous_change; end

    sig { returns(T::Boolean) }
    def id_previously_changed?; end

    sig { returns(T.untyped) }
    def id_previously_was; end

    sig { returns(T.untyped) }
    def id_was; end

    sig { void }
    def id_will_change!; end

    sig { returns(T.nilable(::String)) }
    def memo; end

    sig { params(value: T.nilable(::String)).returns(T.nilable(::String)) }
    def memo=(value); end

    sig { returns(T::Boolean) }
    def memo?; end

    sig { returns(T.nilable(::String)) }
    def memo_before_last_save; end

    sig { returns(T.untyped) }
    def memo_before_type_cast; end

    sig { returns(T::Boolean) }
    def memo_came_from_user?; end

    sig { returns(T.nilable([T.nilable(::String), T.nilable(::String)])) }
    def memo_change; end

    sig { returns(T.nilable([T.nilable(::String), T.nilable(::String)])) }
    def memo_change_to_be_saved; end

    sig { returns(T::Boolean) }
    def memo_changed?; end

    sig { returns(T.nilable(::String)) }
    def memo_in_database; end

    sig { returns(T.nilable([T.nilable(::String), T.nilable(::String)])) }
    def memo_previous_change; end

    sig { returns(T::Boolean) }
    def memo_previously_changed?; end

    sig { returns(T.nilable(::String)) }
    def memo_previously_was; end

    sig { returns(T.nilable(::String)) }
    def memo_was; end

    sig { void }
    def memo_will_change!; end

    sig { returns(T.untyped) }
    def register_id; end

    sig { params(value: T.untyped).returns(T.untyped) }
    def register_id=(value); end

    sig { returns(T::Boolean) }
    def register_id?; end

    sig { returns(T.untyped) }
    def register_id_before_last_save; end

    sig { returns(T.untyped) }
    def register_id_before_type_cast; end

    sig { returns(T::Boolean) }
    def register_id_came_from_user?; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def register_id_change; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def register_id_change_to_be_saved; end

    sig { returns(T::Boolean) }
    def register_id_changed?; end

    sig { returns(T.untyped) }
    def register_id_in_database; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def register_id_previous_change; end

    sig { returns(T::Boolean) }
    def register_id_previously_changed?; end

    sig { returns(T.untyped) }
    def register_id_previously_was; end

    sig { returns(T.untyped) }
    def register_id_was; end

    sig { void }
    def register_id_will_change!; end

    sig { void }
    def restore_amount!; end

    sig { void }
    def restore_counterpart_amount!; end

    sig { void }
    def restore_created_at!; end

    sig { void }
    def restore_exchange_id!; end

    sig { void }
    def restore_id!; end

    sig { void }
    def restore_memo!; end

    sig { void }
    def restore_register_id!; end

    sig { void }
    def restore_status!; end

    sig { void }
    def restore_updated_at!; end

    sig { returns(T.nilable([::Integer, ::Integer])) }
    def saved_change_to_amount; end

    sig { returns(T::Boolean) }
    def saved_change_to_amount?; end

    sig { returns(T.nilable([T.nilable(::Integer), T.nilable(::Integer)])) }
    def saved_change_to_counterpart_amount; end

    sig { returns(T::Boolean) }
    def saved_change_to_counterpart_amount?; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def saved_change_to_created_at; end

    sig { returns(T::Boolean) }
    def saved_change_to_created_at?; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def saved_change_to_exchange_id; end

    sig { returns(T::Boolean) }
    def saved_change_to_exchange_id?; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def saved_change_to_id; end

    sig { returns(T::Boolean) }
    def saved_change_to_id?; end

    sig { returns(T.nilable([T.nilable(::String), T.nilable(::String)])) }
    def saved_change_to_memo; end

    sig { returns(T::Boolean) }
    def saved_change_to_memo?; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def saved_change_to_register_id; end

    sig { returns(T::Boolean) }
    def saved_change_to_register_id?; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def saved_change_to_status; end

    sig { returns(T::Boolean) }
    def saved_change_to_status?; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def saved_change_to_updated_at; end

    sig { returns(T::Boolean) }
    def saved_change_to_updated_at?; end

    sig { returns(T.untyped) }
    def status; end

    sig { params(value: T.untyped).returns(T.untyped) }
    def status=(value); end

    sig { returns(T::Boolean) }
    def status?; end

    sig { returns(T.untyped) }
    def status_before_last_save; end

    sig { returns(T.untyped) }
    def status_before_type_cast; end

    sig { returns(T::Boolean) }
    def status_came_from_user?; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def status_change; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def status_change_to_be_saved; end

    sig { returns(T::Boolean) }
    def status_changed?; end

    sig { returns(T.untyped) }
    def status_in_database; end

    sig { returns(T.nilable([T.untyped, T.untyped])) }
    def status_previous_change; end

    sig { returns(T::Boolean) }
    def status_previously_changed?; end

    sig { returns(T.untyped) }
    def status_previously_was; end

    sig { returns(T.untyped) }
    def status_was; end

    sig { void }
    def status_will_change!; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def updated_at; end

    sig { params(value: ::ActiveSupport::TimeWithZone).returns(::ActiveSupport::TimeWithZone) }
    def updated_at=(value); end

    sig { returns(T::Boolean) }
    def updated_at?; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def updated_at_before_last_save; end

    sig { returns(T.untyped) }
    def updated_at_before_type_cast; end

    sig { returns(T::Boolean) }
    def updated_at_came_from_user?; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def updated_at_change; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def updated_at_change_to_be_saved; end

    sig { returns(T::Boolean) }
    def updated_at_changed?; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def updated_at_in_database; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def updated_at_previous_change; end

    sig { returns(T::Boolean) }
    def updated_at_previously_changed?; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def updated_at_previously_was; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def updated_at_was; end

    sig { void }
    def updated_at_will_change!; end

    sig { returns(T::Boolean) }
    def will_save_change_to_amount?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_counterpart_amount?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_created_at?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_exchange_id?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_id?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_memo?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_register_id?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_status?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_updated_at?; end
  end

  module GeneratedRelationMethods
    sig { returns(PrivateRelation) }
    def all; end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def and(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def annotate(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def create_with(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def distinct(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def eager_load(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def except(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def excluding(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def extending(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def extract_associated(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def from(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def group(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def having(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def in_order_of(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def includes(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def invert_where(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def joins(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def left_joins(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def left_outer_joins(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def limit(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def lock(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def merge(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def none(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def offset(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def only(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def optimizer_hints(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def or(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def order(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def preload(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def readonly(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def references(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def reorder(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def reselect(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def reverse_order(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def rewhere(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def scope_if(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def scope_unless(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def select(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def strict_loading(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def structurally_compatible?(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def uniq!(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def unscope(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelationWhereChain) }
    def where(*args, &blk); end

    sig { params(args: T.untyped, blk: T.untyped).returns(PrivateRelation) }
    def without(*args, &blk); end
  end

  class PrivateAssociationRelation < ::ActiveRecord::AssociationRelation
    include CommonRelationMethods
    include GeneratedAssociationRelationMethods

    Elem = type_member { { fixed: ::Split } }

    sig { returns(T::Array[::Split]) }
    def to_ary; end
  end

  class PrivateAssociationRelationWhereChain < PrivateAssociationRelation
    Elem = type_member { { fixed: ::Split } }

    sig { params(args: T.untyped).returns(PrivateAssociationRelation) }
    def associated(*args); end

    sig { params(args: T.untyped).returns(PrivateAssociationRelation) }
    def missing(*args); end

    sig { params(opts: T.untyped, rest: T.untyped).returns(PrivateAssociationRelation) }
    def not(opts, *rest); end
  end

  class PrivateCollectionProxy < ::ActiveRecord::Associations::CollectionProxy
    include CommonRelationMethods
    include GeneratedAssociationRelationMethods

    Elem = type_member { { fixed: ::Split } }

    sig do
      params(
        records: T.any(::Split, T::Enumerable[T.any(::Split, T::Enumerable[::Split])])
      ).returns(PrivateCollectionProxy)
    end
    def <<(*records); end

    sig do
      params(
        records: T.any(::Split, T::Enumerable[T.any(::Split, T::Enumerable[::Split])])
      ).returns(PrivateCollectionProxy)
    end
    def append(*records); end

    sig { returns(PrivateCollectionProxy) }
    def clear; end

    sig do
      params(
        records: T.any(::Split, T::Enumerable[T.any(::Split, T::Enumerable[::Split])])
      ).returns(PrivateCollectionProxy)
    end
    def concat(*records); end

    sig do
      params(
        records: T.any(::Split, Integer, String, T::Enumerable[T.any(::Split, Integer, String, T::Enumerable[::Split])])
      ).returns(T::Array[::Split])
    end
    def delete(*records); end

    sig do
      params(
        records: T.any(::Split, Integer, String, T::Enumerable[T.any(::Split, Integer, String, T::Enumerable[::Split])])
      ).returns(T::Array[::Split])
    end
    def destroy(*records); end

    sig { returns(T::Array[::Split]) }
    def load_target; end

    sig do
      params(
        records: T.any(::Split, T::Enumerable[T.any(::Split, T::Enumerable[::Split])])
      ).returns(PrivateCollectionProxy)
    end
    def prepend(*records); end

    sig do
      params(
        records: T.any(::Split, T::Enumerable[T.any(::Split, T::Enumerable[::Split])])
      ).returns(PrivateCollectionProxy)
    end
    def push(*records); end

    sig do
      params(
        other_array: T.any(::Split, T::Enumerable[T.any(::Split, T::Enumerable[::Split])])
      ).returns(T::Array[::Split])
    end
    def replace(other_array); end

    sig { returns(PrivateAssociationRelation) }
    def scope; end

    sig { returns(T::Array[::Split]) }
    def target; end

    sig { returns(T::Array[::Split]) }
    def to_ary; end
  end

  class PrivateRelation < ::ActiveRecord::Relation
    include CommonRelationMethods
    include GeneratedRelationMethods

    Elem = type_member { { fixed: ::Split } }

    sig { returns(T::Array[::Split]) }
    def to_ary; end
  end

  class PrivateRelationWhereChain < PrivateRelation
    Elem = type_member { { fixed: ::Split } }

    sig { params(args: T.untyped).returns(PrivateRelation) }
    def associated(*args); end

    sig { params(args: T.untyped).returns(PrivateRelation) }
    def missing(*args); end

    sig { params(opts: T.untyped, rest: T.untyped).returns(PrivateRelation) }
    def not(opts, *rest); end
  end
end
