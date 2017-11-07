class Report < ApplicationRecord
  validates_presence_of :subject, :text
  validates_length_of :subject, minimum: 5
  validates_length_of :text, minimum: 20

  belongs_to :user
end
