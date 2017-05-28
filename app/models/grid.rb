class Grid
  class << self

    #######################################################################################
    #
    # NOTE: This should be moved to a persistent storage or an-memory storage like Redis.
    # Otherwise, multiple server instances _will_ cause issues due to each instance initializing
    # the stack / class separately.
    #
    # This class variable approach was used since storage was *explicitly* disallowed. 
    # The assignment was given in the weekends and I wasn't able to get confirmation if Redis
    # was allowed so I kept to the safe side.
    #
    ########################################################################################
    def cars
      @@cars ||= 3.times.map { |i| Car.new(i+1) }
    end

    def assign_booking(customer_location, destination)
      car = nearest_car(customer_location)
      [car.id, car.book(customer_location, destination)] if car
    end

    def reset
      cars.each { |c| c.reset }
    end
    
    def tick
      cars.each { |c| c.move }
    end

    private

    def nearest_car(customer_location)
      available_cars.min_by { |c| c.manhattan_distance_to(customer_location) }
    end

    def available_cars
      cars.select { |c| c.available? }
    end
  end
end
