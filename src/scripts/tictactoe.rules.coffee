X = new Game.Player("X")
O = new Game.Player("O")

X.opponent = O
O.opponent = X

Game.setPlayers [X, O]
Game.setActivePlayer X

class GridSpace extends Game.Piece
	constructor: (@i, @j) ->
		@controller = null
		for player in [X, O]
			@setVisibleToPlayer(player, true)
			player.addOption new Game.Option
				id: [@i, @j]
				condition: =>
					@controller == null
				effect: do (player) => 
					=>
						@controller = player
						Game.alertListeners({i: @i, j: @j, symbol: player.name})
						if win(player)
							Game.end(winner: player.name)
						else if draw()
							Game.end(winner: null)	
						#demonstrate this bug
						
				nextActivePlayer: player.opponent
	
grid = ((new GridSpace(i, j) for i in [0..2]) for j in [0..2])
	
win = (player) ->
	for i in [0..2]
		if (player is grid[0][i].controller is grid[1][i].controller is grid[2][i].controller)
			return true
			
		if (player is grid[i][0].controller is grid[i][1].controller is grid[i][2].controller)
			return true
			
	if (player is grid[0][0].controller is grid[1][1].controller is grid[2][2].controller)
		return true
		
	if (player is grid[0][2].controller is grid[1][1].controller is grid[2][0].controller)
		return true
		
	return false	

draw = () ->
	for i in [0..2]
		for j in [0..2]
			if grid[i][j].controller is null
				return false
	return true
	
#Further steps: do something when game ends.
#Mention how this setup allows easy AI or network play