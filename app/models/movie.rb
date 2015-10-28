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

  def self.search_title(movies, params)
    if params != nil
      movies.where("title like ?", "%#{params}%")
    else
      movies
    end
  end

  def self.search_director(movies, params)
    if params != nil
      movies.where("director like ?", "%#{params}%")
    else
      movies
    end
  end

  def self.filter_by_runtime(movies, params)
    if params != nil
      case params
        when "under90"
          movies.where("runtime_in_minutes < ?", 90)
        when "between90and120"
          movies.where("runtime_in_minutes >= ? AND runtime_in_minutes <= ?", 90, 120)
        when "over120"
          movies.where("runtime_in_minutes > ?", 120)
      end
    else
      movies
    end
  end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end

end
