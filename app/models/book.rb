class Book < ApplicationRecord
	belongs_to :user
	has_many :favorites,dependent: :destroy
	has_many :book_comments,dependent: :destroy
	scope :latest, -> {order(created_at: :desc)}
	scope :ratest, -> {order(rate: :desc)}
	has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day))}, class_name: "Favorite"
  is_impressionable

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
	validates :category, presence: true
	
	scope :today_book, -> { where(created_at: Time.zone.now.all_day) }
	scope :yesterday_book, -> { where(created_at: 1.day.ago.all_day) }
	scope :this_week_book, -> { where(created_at: 6.day.ago.at_beginning_of_day .. Time.zone.now.at_end_of_day) }
	scope :last_week_book, -> { where(created_at: 13.day.ago.at_beginning_of_day .. 1.week.ago.at_end_of_day) }
	
	

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def Book.search(search_word)
  	Book.where(["category LIKE ?","#{search_word}"])
  end
end
