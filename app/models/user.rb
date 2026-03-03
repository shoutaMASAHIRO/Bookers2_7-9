class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # フォローしている関係（自分がフォロワー）
  has_many :active_relationships, class_name: "Relationship",
  foreign_key: "follower_id",
  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  # フォローされている関係（自分がフォローされている）
  has_many :passive_relationships, class_name: "Relationship",
      foreign_key: "followed_id",
      dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :user_rooms, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, through: :user_rooms
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users

  validates :name, presence: true,length: { minimum: 2 ,maximum: 20},uniqueness: true
  validates :introduction,length: { maximum: 50}

  has_one_attached :profile_image #ファイルを保存するためのメソッドで変数を定義

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    # ImageMagickがない場合はvariantが使えないため、一旦オリジナルを返すように変更します
    # profile_image.variant(resize_to_limit: [width, height]).processed
    profile_image
  end

  # フォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # フォローを外す
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id)&.destroy
  end

  # フォローしているか？
  def following?(other_user)
    following.include?(other_user)
  end

  def self.search(method, word)
    case method
    when "perfect"
      where(name: word)
    when "forward"
      where("name LIKE ?", "#{word}%")
    when "backward"
      where("name LIKE ?", "%#{word}")
    when "partial"
      where("name LIKE ?", "%#{word}%")
    end
  end

  def self.search_for(word, method)
    case method
    when 'perfect'
      where(name: word)
    when 'forward'
      where('name LIKE ?', "#{word}%")
    when 'backward'
      where('name LIKE ?', "%#{word}")
    when 'partial'
      where('name LIKE ?', "%#{word}%")
    end
  end

end
