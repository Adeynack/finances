# frozen_string_literal: true

# == Schema Information
#
# Table name: import_origins
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  subject_type    :string           not null, indexed => [subject_id], indexed => [subject_id], indexed => [subject_id, external_system, external_id]
#  subject_id      :bigint           not null, indexed => [subject_type], indexed => [subject_type], indexed => [subject_type, external_system, external_id]
#  external_system :string           not null, indexed => [subject_type, subject_id, external_id]
#  external_id     :string           not null, indexed => [subject_type, subject_id, external_system]
#
class ImportOrigin < ApplicationRecord
  belongs_to :subject, polymorphic: true

  validates :subject, presence: true
  validates :external_system, presence: true
  validates :external_id, presence: true
end
