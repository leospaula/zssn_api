class SurvivorReport
  def infected_survivors
    percentage_of(Survivor.infecteds.count, Survivor.count)
  end

  def not_infected_survivors
    percentage_of(Survivor.not_infecteds.count, Survivor.count)
  end

  def average_resources
    survivors_count = Survivor.count.to_f
    averages = {}

    Resource::RESOURCE_TYPES.each do |resource_type|
      resource_amount = Resource.where(name: resource_type).sum(:quantity).to_f
      averages[resource_type] = resource_amount / survivors_count
    end

    return averages
  end

  def lost_infected_points
    infecteds = Survivor.infecteds.pluck(:id)
    resources = Resource.where(survivor_id: infecteds)

    "#{sum_resource_points(resources)} points lost"
  end

  private

  def percentage_of(value, total)
    (value.to_f / total.to_f * 100.0).round(2).to_s + "%"
  end

  def sum_resource_points(survivor_resources)
    survivor_resources.sum { |resource| 
      resource['quantity'].to_i * Resource::RESOURCE_POINTS[resource['name'].to_sym]
    }
  end
end