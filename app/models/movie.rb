class Movie < ActiveRecord::Base

  has_many :reviews

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :image,
    presence: true

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_past

  mount_uploader :image, ImageUploader

  def review_average
    return 0 if reviews.empty?
    reviews.sum(:rating_out_of_ten)/reviews.size
  end

  # scope :title_and_director, -> (movie_title, director_name) { where("title LIKE ? AND director LIKE ?", movie_title, director_name) }
  # scope :by_title -> (movie_title) { where("title LIKE ?", movie_title) }
  # scope :by_director -> (director_name) { where("director LIKE ?", director_name) }
  # scope :under_90 -> { where("runtime_in_minutes < 90" }
  # scope :between_90_and_120 -> { where("runtime_in_minutes >= 90 AND runtime_in_minutes <= 120") }
  # scope :over_120 -> { where("runtime_in_minutes > 120") }

  def self.search(title, director, duration)
    if title.present? && director.present?
      @movies = Movie.where("title LIKE ? AND director LIKE ?", "%#{title}%", "%#{director}%") 
    elsif title.present?
      @movies = Movie.where("title LIKE ?", "%#{title}%") 
    elsif director.present?
      @movies = Movie.where("director LIKE ?", "%#{director}%")
    end
    case duration
      when "Any duration"
        unless title.present? || director.present? 
          @movies = Movie.all
        end  
      when "Under 90 minutes"
        @movies = Movie.where("runtime_in_minutes < 90")
      when "Between 90 and 120 minutes"
        @movies = Movie.where("runtime_in_minutes >= 90 AND runtime_in_minutes <= 120")
      when "Over 120 minutes"
        @movies = Movie.where("runtime_in_minutes > 120")
    end
    @movies
  end

  protected

  def release_date_is_in_the_past
    if release_date.present?
      errors.add(:release_date, "should be in the past") if release_date > Date.today
    end
  end

end