# * Position
# * Array constructing shape
# * ypos falling
# * Rotation
# * Random shape


class Shape
    attr_accessor :position, :shape, :name

    def initialize(name, position = {x:0, y:0}, shape = nil)
        @position = position
        @name = name.upcase
        @shape = shape
        
        if(@shape == nil)
            case name.upcase
            when "O"
                @shape = Array.new(2) {Array.new(2, 1)}
            when "I"
                @shape = Array.new(4) {Array.new(1, 1)}
            when "S"
                @shape = Array.new(2) {Array.new(3, 1)}
                @shape[0][0] = 0
                @shape[1][2] = 0
            when "Z"
                @shape = Array.new(2) {Array.new(3, 1)}
                @shape[1][0] = 0
                @shape[0][2] = 0
            when "L"
                @shape = Array.new(3) {Array.new(2, 1)}
                @shape[0][1] = 0
                @shape[1][1] = 0
            when "J"
                @shape = Array.new(3) {Array.new(2, 1)}
                @shape[0][0] = 0
                @shape[1][0] = 0
            when "T"
                @shape = Array.new(2) {Array.new(3, 1)}
                @shape[1][0] = 0
                @shape[1][2] = 0
            when "W" # Testing shape
                @shape = Array.new(3) {Array.new(3, 1)}
                @shape[0][0] = 0
                @shape[1][0] = 0
                @shape[0][1] = 0
                @shape[2][2] = 0
            when "RANDOM"
                random_shape = "O,I,S,Z,L,J,T".split(",").sample
                initialize(random_shape)
            else
                @shape = Array.new(1) {Array.new(1, 1)}
            end
        end
    end

    def rotate_clockwise
        new_shape = Array.new(@shape[0].length) {Array.new(@shape.length, 0)}
        
        r = 0
        while(r < @shape.length)
            c = 0
            while(c < @shape[r].length)
                new_shape[c][(new_shape[0].length - 1) - r] = @shape[r][c]
                c += 1
            end
            r += 1
        end
        @shape = new_shape
    end

    def rotate_counterclockwise
        new_shape = Array.new(@shape[0].length) {Array.new(@shape.length, 0)}
        
        r = 0
        while(r < @shape.length)
            c = 0
            while(c < @shape[r].length)
                new_shape[(new_shape.length - 1) - c][r] = @shape[r][c]
                c += 1
            end
            r += 1
        end
        @shape = new_shape
    end

    def print
        r = 0
        while(r < @shape.length)
            p(@shape[r])
            r += 1;
        end
    end

    def self.clone(shape_to_clone)
        return Shape.new(shape_to_clone.name.clone, 
            shape_to_clone.position.clone, 
            shape_to_clone.shape.clone)
    end

    def foreach_occupied_position(debug = false)
        # r_max = 0 # Debug
        # c_max = 0 # Debug
        shape = @shape
        shape_pos = @position
        r = 0
        while(r < shape.length)
            # if(r_max < r) then r_max = r end # Debug
            c = 0
            while(c < shape[r].length)
                # if(c_max < c) then c_max = c end # Debug
                if(shape[r][c] == 1)
                    yield(r + shape_pos[:y], c + shape_pos[:x])
                    # if(debug) then puts "r, c: " + (r + shape_pos[:y]).to_s + ", " + (c + shape_pos[:x]).to_s end# Debug
                end
                c += 1
            end
            r += 1
        end
    end
end