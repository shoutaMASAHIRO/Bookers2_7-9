class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy


  validates :title, presence: true 
  validates :body, presence: true, length: {maximum: 200}
  validates :category, presence: true
  validates :star, presence: true, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.days.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.weeks.ago.beginning_of_day..1.week.ago.end_of_day) }
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search(method, word)
    case method
    when "perfect"
      where(title: word)
    when "forward"
      where("title LIKE ?", "#{word}%")
    when "backward"
      where("title LIKE ?", "%#{word}")
    when "partial"
      where("title LIKE ?", "%#{word}%")
    end
  end

  def self.search_for(word, method)
    case method
    when 'perfect'
      where(title: word).or(where(category: word))
    when 'forward'
      where('title LIKE ?', "#{word}%").or(where('category LIKE ?', "#{word}%"))
    when 'backward'
      where('title LIKE ?', "%#{word}").or(where('category LIKE ?', "%#{word}"))
    when 'partial'
      where('title LIKE ?', "%#{word}%").or(where('category LIKE ?', "%#{word}%"))
    end
  end
end
