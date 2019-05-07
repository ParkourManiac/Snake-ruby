# Controlling shapes
require "ruby2d"
require_relative "MyMap"
require_relative "Shape"
require_relative "Game"

cmd_args = ARGV

size_x = 10
size_y = 10
difficulty_steps = 0.1.to_f
speed = 3
easy_mode = false
i = 0
while(i < cmd_args.length)
    arg = cmd_args[i]
    if(arg != nil)
        case(i)
        when 0
            size_x = arg.to_i
        when 1
            size_y = arg.to_i
        when 2
            difficulty_steps = arg.to_f
        when 3
            speed = arg.to_f
        when 4
            if(arg.downcase == 'true')
                easy_mode = true
            end
        end
    end
    i += 1
end


game = Game.new
game.setup(size_x, size_y, difficulty_steps, speed, easy_mode)
game.start
