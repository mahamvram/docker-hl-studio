class Assignment < ApplicationRecord
  belongs_to :node
  belongs_to :user
  has_many :notes, dependent: :destroy
  attribute_choices :status ,  [['p', 'Assigned'], ['r', 'Revision'], ['a', 'Approved'], ['wa', 'Sent for Approval']]
  # accepts_nested_attributes_for :notes
end
