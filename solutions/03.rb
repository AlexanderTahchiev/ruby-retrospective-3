require 'matrix'
module Graphics
class Canvas
  attr_accessor :field
  attr_reader :width, :height
  def initialize(width, height)
    @width = width
    @height = height
    @field = Matrix.build(@width, @height){|row, col| "-"}
  end

  def set_pixel(x, y)
    if not pixel_at?(x, y)
      p pixel_at?(x, y)
      matrix_1 = @field
      matrix_2 = *matrix_1
      matrix_2[x][y] = "@"
      @field = Matrix[*matrix_2]
    end
  end

  def pixel_at?(x, y)
    return @field.[](x, y) == "@"
  end

  def draw (figure)
    if figure.is_a? Point
      set_pixel(figure.x, figure.y)

    end
  end
  def render_as(constant)
    if constant == Graphics::Renderers::Ascii
      return @field.to_a.map{|i| i.join("")}.join("\n")
    end
    #Graphics::Renderers::Html::FIRST_HTML_PART + "\n" +
    @field.to_a.
    flatten.map{|i| i == '-' ? '<i></i>' :  '<b></b>' }.each_slice(width).to_a.
    join("<br>\n") #+ Graphics::Renderers::Html::SECOND_HTML_PART
  end
end
module Renderers
  class Ascii

  end
  class Html
    FIRST_HTML_PART = '<!DOCTYPE html>
  <html>
  <head>
    <title>Rendered Canvas</title>
    <style type="text/css">
      .canvas {
        font-size: 1px;
        line-height: 1px;
      }
      .canvas * {
        display: inline-block;
        width: 10px;
        height: 10px;
        border-radius: 5px;
      }
      .canvas i {
        background-color: #eee;
      }
      .canvas b {
        background-color: #333;
      }
    </style>
  </head>
  <body>
    <div class="canvas">'
    SECOND_HTML_PART = '</div>
  </body>
  </html>'
  end
end
class Point < Canvas
  def initialize(x, y)
    @x = x
    @y = y
  end

  def x
    @x
  end

  def y
    @y
  end

  def ==(other)
    @x == other.x and @y == other.y
  end

  def eql?(other)
    @x.eql? other.x and @y.eql? other.y
  end

  def draw_figure(field)
    set_pixel(field.x, field.y)
  end
end
class Line
  attr_reader :from, :to
  def initialize(from, to)
    if from.x > to.x
      from, to = to, from
    if from.x == to.x and from.y > to.y
        from, to = to, from
    end
    end
    @from, @to = from, to
  end

# private
#   deltax = @from.x - @to.x
#   deltay = @from.y - @to.y
#   def draw_line() #(x0, x1, y0, y1)
#     error = 0
#     real deltaerr =  (deltay / deltax).abs
#     int y = to.y
#     for x in (@from.x..@to.x)
#       plot(x,y)
#       error = error + deltaerr
#       if error >= 0.5
#         y = y + 1
#         error = error - 1.0
#       end
#     end
#   end
end
end