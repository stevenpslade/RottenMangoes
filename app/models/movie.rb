class Movie < ActiveRecord::Base

  mount_uploader :image, ImageUploader

  has_many :reviews

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_future

  def review_average
    if reviews.size == 0
      "No average can be shown (no reviews)"
    else
      reviews.sum(:rating_out_of_ten)/reviews.size
    end
  end

  def self.search_all(keyword)
    if !keyword.blank?
      where("director like ? OR title like ?", "%#{keyword}%", "%#{keyword}%")
    else
      all
    end
  end

  def self.filter_by_runtime(runtime_label)
    if !runtime_label.blank?
      case runtime_label
        when "under90"
          where("runtime_in_minutes < ?", 90)
        when "between90and120"
          where("runtime_in_minutes >= ? AND runtime_in_minutes <= ?", 90, 120)
        when "over120"
          where("runtime_in_minutes > ?", 120)
      end
    else
      all
    end
  end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end

end
