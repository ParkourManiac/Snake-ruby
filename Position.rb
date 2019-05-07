class Position
    attr_accessor :x, :y
    def initialize(x = 0, y = 0)
        @x = x
        @y = y
    end

    def clone
        return Position.new(self.x, self.y)
    end
end