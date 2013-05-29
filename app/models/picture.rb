class Picture < ActiveRecord::Base
  attr_accessible :author, :date_of_shot, :file

  scope :all_ordered, lambda{ order('date_of_shot ASC')  }

  has_attached_file :file, :styles => { :thumb => "250x170>" }

  acts_as_taggable

  def self.no_resource?
    Picture.count == 0
  end

  def self.get_date_of_shot file
    return EXIFR::JPEG.new(file.tempfile.path).date_time
  end
end