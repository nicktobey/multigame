$(document).ajaxError( (event, jqxhr, settings, thrownError ) ->
	alert thrownError
)

class Player
	constructor: (@name) ->
	
class Piece
	constructor: () ->
		@options = {}
		
	addOption: (option) ->
		@options[option.id] = option
		
class OwnedPiece extends Piece
	constructor: (@owner) ->
		super
		
	getOptions: (player) ->
		options = {}
		(options[option.id] = option) for option in @options when option.condition.call(this, player) and (if ownershipCondition in option then option.ownershipCondition.call(this, player) else player == @owner)
		return options

class UnownedPiece extends Piece
	getOptions: (player) ->
		options = {}
		(options[oid] = option) for oid, option of @options when option.condition.call(this, player)
		return options

class GameState
	constructor: (@pieces, @activePlayer) ->
		
	getOptions = (player) ->
		options = {}
		for pid, piece of @pieces
			options[pid] = {}
			for oid, option of piece.getOptions(player)
				options[pid][oid] = option
		return options
			
	commitOption: (player, pieceId, optionId) ->
		options = getOptions.call(this, player)
		if pieceId not of options
			return {success: false, newState: this, error: "bad piece" }
		if optionId not of options[pieceId]
			return {success: false, newState: this, error: "bad option" }
		option = options[pieceId][optionId]
		newPieces = Object.create(@pieces)
		newGameState = new GameState(newPieces, option.nextActivePlayer(player))
		#We need the piece id here? Or would this make it harder for an effect that changes different pieces
		#Assume this piece will change as a convenience. All others must be referenced by id.
		newPiece = Object.create(@pieces[pieceId])
		newGameState.pieces[pieceId] = newPiece
		option.effect.call(newPiece, newGameState, player)
		return {success: true, newState: newGameState }

Multigame =
	load: (filename, callback) ->
		$.ajax
			url: filename
			dataType: "text"
		.done (data) -> 
			rules = {}
			Rules = (r) ->
				rules = r
			(new Function("Player", "Option", "OwnedPiece", "UnownedPiece", "Rules", data))(Player, Option, OwnedPiece, UnownedPiece, Rules)
			rules.newGame = ->
				pieceList = @initialize()
				initialGameState = new GameState(pieceList, @activePlayer)
				return initialGameState
			callback(rules)
			
global "Multigame", Multigame