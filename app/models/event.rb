class Event < ApplicationRecord
  belongs_to :event_category
  has_many :purchases
  has_many :favorites, dependent: :destroy
  
  validates :event_category, :title, :location, :start_at, :ticket_price, :ticket_quantity, presence: true
  validates :title, length: { maximum: 80 }, uniqueness: true
  validates :location, length: { maximum: 20 }
  validates :ticket_price, :ticket_quantity, numericality: { only_integer: true, greater_than: 0 }
    
  validates_each :start_at do |record, attr, value|
    record.errors.add(attr, 'must be at least a week from now') if value < Time.current + 1.week
  end
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
