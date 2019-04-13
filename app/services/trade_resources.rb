class TradeResources
  def initialize(params)
    @params = params
  end

  attr_accessor :params, :status, :message

  def execute
    begin
      validate_survivors
      validate_resources
      validate_resource_points
      execute_trade

      set_status(:ok)
      set_message('Trade successfully completed')

      self
    rescue Error::TradeError => e
      set_status(e.status)
      set_message(e.message)

      self
    end
  end

  private

  def validate_survivors
    survivors.each_with_index do |survivor, index|
      if survivor.infected?
        raise Error::TradeError.new(:unprocessable_entity, "#{survivors[index].name} is infected") 
      end
    end
  end

  def survivors
    [survivor_one, survivor_two]
  end

  def survivor_one
    survivor_one ||= find_survivor(params.dig('survivor_1', 'id'))
  end

  def survivor_two
    survivor_two ||= find_survivor(params.dig('survivor_2', 'id'))
  end

  def find_survivor(survivor_id)
    begin
      Survivor.find(survivor_id)
    rescue ActiveRecord::RecordNotFound
      raise Error::TradeError.new(:not_found, "Survivor with id #{survivor_id} does not exist")
    end
  end

  def validate_resources
    survivors.each_with_index do |survivor, index|
      unless survivor.has_enough_resources?(params.dig("survivor_#{index + 1}", "resources"))
        raise Error::TradeError.new(:conflict, "#{survivor.name} doesn't have enough resources")
      end
    end
  end

  def validate_resource_points
    survivor_one_points = sum_resource_points(params.dig('survivor_1', 'resources')) 
    survivor_two_points = sum_resource_points(params.dig('survivor_2', 'resources'))

    if survivor_one_points != survivor_two_points
      raise Error::TradeError.new(:conflict, "Resources points is not balanced both sides")
    end
  end

  def sum_resource_points(survivor_resources)
    survivor_resources.sum { |resource| 
      resource['quantity'].to_i * Resource::RESOURCE_POINTS[resource['name'].to_sym]
    }
  end

  def execute_trade
    ActiveRecord::Base.transaction do
      survivor_one.remove_resources(params.dig('survivor_1', 'resources'))
      survivor_one.add_resources(params.dig('survivor_2', 'resources'))

      survivor_two.remove_resources(params.dig('survivor_2', 'resources'))
      survivor_two.add_resources(params.dig('survivor_1', 'resources'))
    end
  end

  def set_status(status)
    self.status = status
  end

  def set_message(message)
    self.message = message
  end
end