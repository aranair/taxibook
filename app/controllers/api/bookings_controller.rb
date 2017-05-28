class Api::BookingsController < Api::ApiController
  rescue_from StandardError, with: :deny_invalid_input

  # Inputs { source: { x: x1, y: y1 }, destination: { x: x2, y: y2 }}
  def create
    car_id, total_time = 
      Grid.assign_booking(
        Node.new(source[:x], source[:y]),
        Node.new(destination[:x], destination[:y])
      )

    if car_id
      render json: { car_id: car_id, total_time: total_time }
    else
      head :ok
    end
  end

  def print
    render json: Grid.cars
  end

  # Advance system by 1 time unit.
  def tick
    Grid.tick
    head :ok
  end

  # Reset all cars back to initial state _regardless_ of cars that are currently booked.
  def reset
    Grid.reset
    head :ok
  end

  protected

  def deny_invalid_input(exception)
    render json: { errors: exception.message }
  end

  private

  def source
    booking_params.require(:source)
  end

  def destination
    booking_params.require(:destination)
  end

  def booking_params
    params.require(:booking).permit(source: [:x, :y], destination: [:x, :y])
  end
end
