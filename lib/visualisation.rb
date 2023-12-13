# frozen_string_literal: true

require('colorized_string')

module Visualisation
  def self.print_grid(grid, centre_x: 20, centre_y: 20, x_dim: 40, y_dim: 40, sleep: 0.01, spacer: ' ', colour_char: nil, colour: nil, flip: false, empty_char: '.', no_clear: false, character_colours: nil)
    system('clear') unless no_clear
    x_origin = centre_x - (x_dim / 2) >= 0 ? centre_x - (x_dim / 2) : 0
    y_origin = centre_y - (y_dim / 2) >= 0 ? centre_y - (y_dim / 2) : 0
    if flip
      (x_origin + x_dim - 1).downto(x_origin).each do |x|
        (y_origin..y_origin + y_dim - 1).each do |y|
          grid_x = grid[x]
          val = grid[x].nil? ? nil : grid_x[y]
          val ||= empty_char
          print_and_flush("#{val}#{spacer}", colour_char, colour, character_colours)
        end
        puts ''.black
      end
    else
      (x_origin..x_origin + x_dim - 1).each do |x|
        (y_origin..y_origin + y_dim - 1).each do |y|
          grid_x = grid[x]
          val = grid[x].nil? ? nil : grid_x[y]
          val ||= empty_char
          print_and_flush("#{val}#{spacer}", colour_char, colour, character_colours)
        end
        puts ''.black
      end
    end
    sleep(sleep)
  end

  def self.print_and_flush(str, colour_char, colour, character_colours)
    if character_colours.nil?
      str = ColorizedString[str].colorize(colour) if str[0] == colour_char
    else
      coloured_chars = ''
      str.chars.each do |s|
        coloured_chars +=
          if character_colours[s].nil?
            s
          else
            ColorizedString[s].colorize(character_colours[s])
          end
      end
      str = coloured_chars
    end
    print(str)
    $stdout.flush
  end
end
