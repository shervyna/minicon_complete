class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :event
  
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: :event_id }
  validates :event, presence: true
end
