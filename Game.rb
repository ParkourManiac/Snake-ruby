require "ruby2d"
require_relative "Position"

#  Setup game rules
#     Change player direction on arrow press. 
#     Check for collision with food (if true, delete food and add +1 to length)
#     Move player in direction each update (and collision check)
#     If food is gone spawn new food

class Game
    def start(no_window = false)
        @tick = 0
        Window.update do
            game_loop()
            draw_game()
        end

        if(!no_window) then Window.show() end
    end

    def setup(size_x = 30, size_y = 30, difficulty_steps = 1/15.0, starting_speed = 3, easy_mode = false)
        Window.set(title: "Snake", borderless: false, background: 'black', width: 400, height: 400)
        @map = MyMap.new(size_x, size_y)
        @updates_per_second = starting_speed.to_f
        @difficulty_steps = difficulty_steps.to_f
        @easy_mode = easy_mode
        @fps = 60
        @debug = false
        @player = Player.new(size_x / 2, size_y / 2, 2)
        @previous_dir = Position.new(0,0)
        @food_eaten = 0
        @food_pos = random_position()

        Window.on(:key_down) do |event|
            if(@debug) 
                puts event.key 
            end

            case event.key
            when 'up'
                if(@previous_dir.x == 0 && @previous_dir.y == 1)
                else
                    @player.dir.x = 0
                    @player.dir.y = -1
                    if(@easy_mode) then @tick = 0 end
                end
            when 'left'
                if(@previous_dir.x == 1 && @previous_dir.y == 0)
                else
                    @player.dir.x = -1
                    @player.dir.y = 0
                    if(@easy_mode) then @tick = 0 end
                end
            when 'right'
                if(@previous_dir.x == -1 && @previous_dir.y == 0)
                else
                    @player.dir.x = 1
                    @player.dir.y = 0
                    if(@easy_mode) then @tick = 0 end
                end
            when 'down'
                if(@previous_dir.x == 0 && @previous_dir.y == -1)
                else
                    @player.dir.x = 0
                    @player.dir.y = 1
                    if(@easy_mode) then @tick = 0 end
                end
            when 'keypad +'
                if(@debug)
                    @player.length += 1
                end
            when 'keypad -'
                if(@debug)
                    @player.length -= 1
                end
            when 'keypad 1'
                Window.close()
            when 'keypad *'
                @debug = !@debug
                puts "Debug enabled"
            end
        end
    end

    def game_loop
        if(@tick % (@fps / @updates_per_second).to_i == 0)
            #Update start

            # TODO: Move snake, check collision, collider with food (lengthen snake), collide with wall or self (game_over).
            if(!(@player.dir.x == 0 && @player.dir.y == 0))
                if(validate_player_move(@player.dir))
                    @previous_dir = @player.dir.clone
                    @player.body.each { |pos| @map.convert_position_to_map(pos, 0) }
                    move_player(@player.dir)
                    @player.body.each { |pos| @map.convert_position_to_map(pos) }
                    
                    if(@player.pos.x == @food_pos.x && @player.pos.y == @food_pos.y)
                        eat_food()
                    end
                    
                else
                    game_over()
                end
            end
                
            #Update end
        end
        @tick += 1
    end

    def draw_game
        @map.clean_screen
        @map.draw_map_outline()
        
        @map.draw_position(@food_pos, 'red')

        @map.draw_map('gray')

        @map.draw_position(@player.pos, 'white')
    end

    def eat_food()
        @food_pos = random_position()
        @player.length += 1
        @food_eaten += 1
        p @food_eaten
        @updates_per_second += @difficulty_steps
    end

    def random_position()
        return Position.new((0..(@map.map_size_x - 1)).to_a.sample, (0..(@map.map_size_y - 1)).to_a.sample)
    end

    def validate_player_move(diff = Position.new(0,0))
        output = false
        new_x = @player.pos.x + diff.x
        new_y = @player.pos.y + diff.y
        if(!@map.out_of_range(new_x, new_y)) 
            if(!@map.occupied(new_x, new_y))
                output = true
            end
        end

        return output
    end

    def move_player(diff)
        @player.pos.x += diff.x
        @player.pos.y += diff.y
        @player.update_position()
    end

    def game_over
        puts "\nFoodies eaten: " + @food_eaten.to_s
        puts "Speed " + @updates_per_second.to_s
        debug_map_size_colored(false)
    end

    def restart_game() # Todo
        Window.new()
        setup()
        start()
    end

    def debug_map_size_colored(outline = true)
        restart_game = false
        Window.on(:key_down) do |event|
            case event.key
            when 'keypad 1'
                Window.close()
            when 'keypad 0'
                # TODO: Restart game
            end
        end

        @tick = 0
        Window.update do
            if(@tick % 3 == 0)
                @map.clean_screen
                if(outline) then @map.draw_map_outline end
                @map.map_size_x.times do |x|
                    @map.map_size_y.times do |y|
                    @map.draw_block(x, y, 'random') 
                    end
                end
            end 
            @tick += 1
        end
    end
end

class Player
    attr_accessor :pos, :length, :dir, :body

    def initialize(x, y, length, dir_x = 0, dir_y = 0)
        @pos = Position.new(x, y)
        @length = length
        @dir = Position.new(dir_x, dir_y)
        @body = [] # positions of all bodyparts
        @length.times do 
            @body.push(@pos.clone)
        end
    end

    def update_position()
        #unshift, add to front
        #pop, delete last

        @body.unshift(@pos.clone)
        i = 0
        while(i < @body.length)
            if(i >= @length)
                @body.pop()
            else
                i += 1
            end
        end
    end
end