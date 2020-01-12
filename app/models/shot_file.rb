class ShotFile < ApplicationRecord
  has_attached_file :shot_image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :shot_image, content_type: /\Aimage\/.*\z/
  belongs_to :node
end
  