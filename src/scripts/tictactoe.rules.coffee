X = new Player("X")
O = new Player("O")

X.opponent = O
O.opponent = X

class GridSpace extends UnownedPiece
	constructor: (@i, @j) ->
		super
		@id = [@i, @j]
		@controller = null
		@addOption
			id: [@i, @j]
			condition: (player) ->
				@controller == null
			playerCondition: -> true
			effect: (gameState, player) ->
				@controller = player
				if win(gameState.pieces, @i, @j)
					gameState.ended = true
					gameState.winner = player
				else if draw(gameState.pieces)
					gameState.ended = true
					gameState.winner = null
			nextActivePlayer: (player) ->
				player.opponent
	

# Determine whether the spot claimed a i, j created a win for the player who put it there
win = (pieces, i, j) ->
	if(pieces[[i, 0]].controller is pieces[[i, 1]].controller is pieces[[i, 2]].controller)
		return true
	if(pieces[[0, j]].controller is pieces[[1, j]].controller is pieces[[2, j]].controller)
		return true
	if(i == j and pieces[[0, 0]].controller is pieces[[1, 1]].controller is pieces[[2, 2]].controller)
		return true
	if(i + j == 2 and pieces[[0, 2]].controller is pieces[[1, 1]].controller is pieces[[2, 0]].controller)
		return true
	return false	

draw = (pieces) ->
	for i in [0..2]
		for j in [0..2]
			if pieces[[i, j]].controller is null
				return false
	return true
	
#Further steps: do something when game ends.
#Mention how this setup allows easy AI or network play



Rules(
	activePlayer: X
	initialize: ->
		pieces = {}
		(((pieces[[i, j]] = new GridSpace(i, j) for i in [0..2]) for j in [0..2]))
		return pieces
)