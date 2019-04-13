class Survivor < ApplicationRecord

  INFECTION_MAX = 3

  validates :name, :age, :gender, :last_location , :presence => true

  enum gender: [ :male, :female ]

  has_many :resources

  accepts_nested_attributes_for :resources

  def last_location
    read_attribute(:last_location)&.with_indifferent_access
  end

  def infected?
    infection_count >= INFECTION_MAX
  end

  def has_enough_resources?(resources)
    resources.each do |resource|
      return false if resources_count(resource) < resource['quantity'].to_i
    end
    return true
  end

  def resources_count(resource)
    survivor_resource = self.resources.find_by(name: resource['name'])
    survivor_resource.present? ? survivor_resource.quantity : 0
  end

  def add_resources(trade_resources)
    trade_resources.each do |trade_resource|
      self.resources.find_or_create_by(name: trade_resource[:name]).increment!(:quantity, trade_resource[:quantity])
    end
  end

  def remove_resources(trade_resources)
    trade_resources.each do |trade_resource|
      resource = self.resources.find_by(name: trade_resource[:name])
      if resource.quantity <= trade_resource[:quantity]
        resource.destroy!
      else
        resource.decrement!(:quantity, trade_resource[:quantity])
      end
    end
  end
end
