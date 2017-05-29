class Building < ApplicationRecord
  mount_uploader :image, ImageUploader

  validates_presence_of :number,:name,:lat,:lng

  def self.all_buildings
    all
  end

  def self.building_by_id(id)
    find_by_id(id)
  end

  def self.building_by_number(number)
    find_by_number(number)
  end

  def self.building_by_name(name)
    where("name LIKE ?","%#{name.downcase}%").first
  end

  def self.building_by_nickname(nickname)
    where("name LIKE ?","%#{nickname.downcase}%").first
  end
end
