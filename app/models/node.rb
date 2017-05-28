class Node
  attr_accessor :x, :y

  MAX = 2 ** 31 -1
  MIN = - 2 ** 31

  def initialize(x, y)
    x = x.to_i
    y = y.to_i
    check_boundary(x)
    check_boundary(y)

    @x = x
    @y = y
  end

  def check_boundary(n)
    if n < MIN or n > MAX
      raise StandardError, 'Coordinates are outside of world boundaries.' 
    end
  end

  # Calcualte manhattan distance
  def manhattan_distance_to(node)
    x_reference_to(node).abs + y_reference_to(node).abs
  end

  def x_reference_to(node)
    x - node.x
  end

  def y_reference_to(node)
    y - node.y
  end

  def ==(n)
    x == n.x && y == n.y
  end
end
