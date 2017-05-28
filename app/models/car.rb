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
    update_status # For customers who get on where the car is at.

    # Total_time needed
    current_location.manhattan_distance_to(customer_location) + 
      customer_location.manhattan_distance_to(destination)
  end

  def move
    return if available? || next_loc.blank?

    if x_ref.zero?
      move_y(y_ref / y_ref.abs)
    else
      move_x(x_ref / x_ref.abs)
    end

    update_status
  end

  def reset
    available!
    @current_location = Node.new(0, 0)
  end

  private

  # The next location the car should move to
  def next_loc
    customer_location.presence || destination.presence
  end

  # Move vertically to next location
  def move_y(unit)
    @current_location = Node.new(current_location.x, current_location.y + unit)
  end

  def y_ref
    next_loc.y_reference_to(current_location)
  end

  # Move horizontally to next location
  def move_x(unit)
    @current_location = Node.new(current_location.x + unit, current_location.y)
  end

  def x_ref
    next_loc.x_reference_to(current_location)
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
