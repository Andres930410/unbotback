class Building < ApplicationRecord
  mount_uploader :image, ImageUploader

  validates_presence_of :number,:name,:lat,:lng
  validates_uniqueness_of :number,:name,:lat,:lng
end
