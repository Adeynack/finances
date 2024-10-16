# frozen_string_literal: true

# == Schema Information
#
# Table name: taggings
#
#  id           :uuid             not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tag_id       :uuid             not null, indexed, indexed => [subject_type, subject_id]
#  subject_type :string           not null, indexed => [subject_id], indexed => [subject_id], indexed => [tag_id, subject_id]
#  subject_id   :uuid             not null, indexed => [subject_type], indexed => [subject_type], indexed => [tag_id, subject_type]
#  book_id      :uuid             not null, indexed
#
class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :subject, polymorphic: true
  belongs_to :book

  validate :validate_book_id_with_subject

  before_validation do
    self.book_id = subject.book.id if book_id.blank?
  end

  private

  def validate_book_id_with_subject
    errors.add "book must be the same as the subject's" if subject.respond_to?(:book_id) && book_id != subject.book_id
  end
end
