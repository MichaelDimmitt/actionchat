class Room < ApplicationRecord
  has_many :messages
  validates :user1, presence: true, if: :is_private?
  validates :user2, presence: true, if: :is_private?

  def is_private?
    is_private
  end
end
