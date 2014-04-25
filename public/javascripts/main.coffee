# Game Class
class GameOfLife
  cellSize: 7
  constructor: ->
    @canvas = $('canvas')[0]
    @resizeCanvas()
    @createDrawingContext()

    @seed()

    @tick()

  resizeCanvas: ->
    @canvas.height = @cellSize * @numberOfRows
    @canvas.width = @cellSize * @numberOfColumns

  createDrawingContext: ->
    @context = @canvas.getContext '2d'


#----ON CLICK LISTENERS-------

$(document).ready( ->
  $(document).on('click', '.play', (e) ->
    $('#canvas').show()
    $('.play').hide()
    new GameOfLife()
    e.preventDefault()
  )
)
