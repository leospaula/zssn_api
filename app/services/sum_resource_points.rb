class SumResourcePoints
  def initialize(resources)
    @resources = resources 
  end

  attr_reader :resources

  def execute
    resources.sum do |resource| 
      resource['quantity'].to_i * Resource::RESOURCE_POINTS[resource['name'].to_sym]
    end
  end
end