class Survivor < ApplicationRecord
  validates :name, :age, :gender, :last_location , :presence => true

  enum gender: [ :male, :female ]

  def last_location
    read_attribute(:last_location).with_indifferent_access
  end
end
