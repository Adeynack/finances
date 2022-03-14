# frozen_string_literal: true

# == Schema Information
#
# Table name: taggings
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tag_id       :bigint           not null, indexed, indexed => [subject_type, subject_id]
#  subject_type :string           not null, indexed => [subject_id], indexed => [subject_id], indexed => [tag_id, subject_id]
#  subject_id   :bigint           not null, indexed => [subject_type], indexed => [subject_type], indexed => [tag_id, subject_type]
#
class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :subject, polymorphic: true
end
