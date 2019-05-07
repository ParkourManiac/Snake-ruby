require "ruby2d"
require_relative "Shape"
# * Shape integration
# * Map outline
# * Shape collision


class MyMap
    attr_accessor :map_size_x, :map_size_y, :map

    def initialize(map_size_x, map_size_y)
        @map = Array.new(map_size_y) { Array.new(map_size_x, 0)}
        @map_size_x = map_size_x
        @map_size_y = map_size_y
        @window_margin = 2
        @block_size = 1
        calculate_block_size()
        calculate_map_info()
    end

    def calculate_block_size 
        window_min_size = 1
        if(Window.get(:width) < Window.get(:height))
            window_min_size = Window.get(:width)
        else
            window_min_size = Window.get(:height)
        end

        map_max_size = 10
        if(@map_size_x > @map_size_y)
            map_max_size = @map_size_x
        else
            map_max_size = @map_size_y
        end
        
        @block_size = window_min_size / (map_max_size + @window_margin * 2).to_f # Maybe multiply @window_margin by 2 ???
    end

    def calculate_map_info
        @map_start_x = @map_start_y = @window_margin * @block_size
        @map_end_x = @map_start_x + @map_size_x * @block_size
        @map_end_y = @map_start_y + @map_size_y * @block_size
    end

    def print() 
        r = 0
        while(r < @map.length)
            p(@map[r])
            r += 1;
        end
    end

    def draw_shapes(shape_arr, color = "white")
        shapes = shape_arr
        i = 0
        while(i < shapes.length)
            draw_shape(shapes[i], color)
            i += 1
        end
    end

    def draw_shape(shape_to_draw, color = "white")
        shape_to_draw.foreach_occupied_position() do |r, c|
            draw_block(c, r, color) 
        end
    end

    def draw_position(pos, color = 'white')
        draw_block(pos.x, pos.y, color)
    end

    def draw_positions(pos_arr, color = 'white')
        positions = pos_arr
        i = 0
        while(i < positions.length)
            draw_position(positions[i], color)
            i += 1
        end
    end

    def draw_map(color = 'white')
        r = 0
        while(r < @map.length)
            c = 0
            while(c < @map[r].length)
                if(@map[r][c] == 1) then draw_block(c, r, color) end
                c += 1
            end
            r += 1
        end
    end

    def draw_map_outline(thickness = 2, color = 'white')
        #Top
        Rectangle.new(x: @map_start_x - thickness, 
            y: @map_start_y - thickness, 
            width: @map_end_x - @map_start_x + (thickness * 2), 
            height: thickness,
            color: color)
        #Left
        Rectangle.new(x: @map_start_x - thickness, 
            y: @map_start_y - thickness, 
            width: thickness, 
            height: @map_end_y - @map_start_y + (thickness * 2), 
            color: color)
        #Right
        Rectangle.new(x: @map_end_x, 
            y: @map_start_y - thickness, 
            width: thickness, 
            height: @map_end_y - @map_start_y + (thickness * 2), 
            color: color)
        #Bottom
        Rectangle.new(x: @map_start_x - thickness, 
            y: @map_end_y, 
            width: @map_end_x - @map_start_x + (thickness * 2), 
            height: thickness,
            color: color)
    end

    def draw_block(posX, posY, color = "white")
        Square.new(x: posX * @block_size + @map_start_x, 
                   y: posY * @block_size + @map_start_y, 
                   size: @block_size, 
                   color: color)
    end

    def clean_screen
        Window.clear()
    end

    def reset
        r = 0
        while(r < @map.length)
            c = 0
            while(c < @map[r].length)
                @map[r][c] = 0

                c += 1
            end
            r += 1
        end
    end

    def convert_shape_to_map(shape_to_convert)
        shape_to_convert.foreach_occupied_position() do |r, c|
            if(c >= 0 && c < @map_size_x && r >= 0 && r < @map_size_y) 
                @map[r][c] = 1
            end
        end
    end

    def convert_position_to_map(position_to_convert, new_value = 1)
        c = position_to_convert.x
        r = position_to_convert.y
        if(c >= 0 && c < @map_size_x && r >= 0 && r < @map_size_y) 
            @map[r][c] = new_value
        end
    end

    def check_collision_with_map(shape_to_check)
        output = false

        shape_to_check.foreach_occupied_position() do |r, c| 
            if(@map[r] != nil)
                if(@map[r][c] == 1)
                    output = true
                end
            end
        end

        return output
    end

    def occupied(c, r)
        return (@map[r][c] == 1)
    end

    def out_of_range(c, r)
        if(c < 0 || c >= @map_size_x ||
            r < 0 || r >= @map_size_y)
            return true
        end
        return false
    end
end