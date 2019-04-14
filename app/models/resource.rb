class Resource < ApplicationRecord
  RESOURCE_TYPES = ['water', 'food', 'medication', 'ammunition'].freeze

  RESOURCE_POINTS = {
    water: 4,
    food: 3,
    medication: 2,
    ammunition: 1
  }.freeze

  validates :name, :quantity, presence: true
  validates :name, inclusion: { in: RESOURCE_TYPES }

  belongs_to :survivor
end