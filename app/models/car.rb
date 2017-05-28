class Car
  attr_accessor :current_location, :customer_location, :destination, :id

  # 3 statuses:
  # - available
  # - busy - implicit status (booked but not picked up customer yet)
  # - booked
  
  delegate :manhattan_distance_to, to: :current_location

  def initialize(id)
    @id = id
    reset
  end

  def available?
    @status == :available
  end

  def book(customer_location, destination)
    return unless available?

    @customer_location = customer_location
    @destination = destination
    booked!
    update_status

    # Total_time needed
    current_location.manhattan_distance_to(customer_location) + 
      customer_location.manhattan_distance_to(destination)
  end

  # Move t units towards customer or destination
  def move(units = 1)
    return if available? || next_target.blank?

    # If x is done, move y, otherwise move x
    move_x(next_target).zero? && move_y(next_target)
    update_status
  end

  def reset
    available!
    @current_location = Node.new(0, 0)
  end

  private

  # The next location the car should move to
  def next_target
    customer_location.presence || destination.presence
  end

  # Move vertically to next location
  def move_y(loc)
    dist = loc.y_distance_to(current_location)
    return dist if dist.zero?

    @current_location = Node.new(
      current_location.x, 
      current_location.y + (dist / dist.abs)
    )

    dist
  end

  # Move horizontally to next location
  def move_x(loc)
    dist = loc.x_distance_to(current_location)
    return dist if dist.zero?

    @current_location = Node.new(
      current_location.x + (dist / dist.abs), 
      current_location.y
    )

    dist
  end

  # Checks if pick up is done, or if drop off is done.
  def update_status
    picked_up! if customer_location && current_location == customer_location
    dropped_off! if destination && current_location == destination
  end

  def available!
    @status = :available
  end

  def booked!
    @status = :booked
  end

  def picked_up!
    @customer_location = nil 
  end

  def dropped_off!
    @destination = nil 
    available!
  end
end
