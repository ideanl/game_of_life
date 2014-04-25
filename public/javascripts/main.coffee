# Game Class
class GameOfLife
  cellSize: 7
  numberOfRows: 50
  numberOfColumns: 50
  seedProbability: 0.5
  tickLength: 100

  constructor: ->
    @createCanvas()
    @resizeCanvas()
    @createDrawingContext()

    @seed()

    @tick()

  createCanvas: ->
    @canvas = document.createElement('canvas')
    $('#body-container').append(@canvas)

  resizeCanvas: ->
    @canvas.height = @cellSize * @numberOfRows
    @canvas.width = @cellSize * @numberOfColumns
    $(@canvas).css({'position': 'absolute', 'left': '50%', 'top': '50%'})
    $(@canvas).css('margin-left', "-#{@canvas.width / 2}px")
    $(@canvas).css('margin-top', "-#{@canvas.height / 2}px")

  createDrawingContext: ->
    @context = @canvas.getContext('2d')

  seed: ->
    @currentCells = []
    for row in [0...@numberOfRows]
      @currentCells[row] = []

      for column in [0...@numberOfColumns]
        seedCell = @createSeedCell(row, column)
        @currentCells[row][column] = seedCell

  createSeedCell: (row, column) ->
    isAlive: Math.random() < @seedProbability
    row: row
    column: column

  drawGrid: ->
    for row in [0...@numberOfRows]
      for column in [0...@numberOfColumns]
        @drawCell(@currentCells[row][column])

  drawCell: (cell) ->
    y = @cellSize * cell.row
    x = @cellSize * cell.column
    if (cell.isAlive)
      fillStyle = 'rgb(242, 198, 65)'
    else
      fillStyle = 'rgb(38, 38, 38)'

    @context.strokeStyle = 'rgba(242, 198, 65, 0.1)'
    @context.strokeRect(x, y, @cellSize, @cellSize)

    @context.fillStyle = fillStyle
    @context.fillRect(x, y, @cellSize, @cellSize)

  
  tick: =>
    @drawGrid()
    @evolveCellGeneration()
    setTimeout @tick, @tickLength

  evolveCellGeneration: ->
    newCellGeneration = []

    for row in [0...@numberOfRows]
      newCellGeneration[row] = []

      for column in [0...@numberOfColumns]
        evolvedCell = @evolveCell(@currentCells[row][column])
        newCellGeneration[row][column] = evolvedCell

    @currentCells = newCellGeneration

  evolveCell: (cell) ->
    evolvedCell =
      row: cell.row
      column: cell.column
      isAlive: cell.isAlive

    numberOfAliveNeighbors = @countAliveNeighbors(cell)

    if cell.isAlive or numberOfAliveNeighbors is 3
      evolvedCell.isAlive = 1 < numberOfAliveNeighbors < 4

    evolvedCell

  countAliveNeighbors: (cell) ->
    lowerRowBound = Math.max cell.row - 1, 0
    upperRowBound = Math.min cell.row + 1, @numberOfRows - 1
    lowerColumnBound = Math.max cell.column - 1, 0
    upperColumnBound = Math.min cell.column + 1, @numberOfColumns - 1
    numberOfAliveNeighbors = 0

    for row in [lowerRowBound..upperRowBound]
      for column in [lowerColumnBound..upperColumnBound]
        continue if row is cell.row and column is cell.column
        
        if @currentCells[row][column].isAlive
          numberOfAliveNeighbors++

    numberOfAliveNeighbors
    
window.GameOfLife = GameOfLife

#----ON CLICK LISTENERS-------

$(document).ready( ->
  $(document).on('click', '.play', (e) ->
    $('#canvas').show()
    $('.play').hide()
    new GameOfLife()
    e.preventDefault()
  )
)
