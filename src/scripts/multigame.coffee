$(document).ajaxError( (event, jqxhr, settings, thrownError ) ->
	alert thrownError
)

class Player
	constructor: (@name) ->
		@options = {}
		@pieces = []
	
	addOption: (option) -> @options[option.id] = option
	
	setPieceAsVisible: (piece, visible) ->
		if visible
			@pieces.push piece unless piece in @pieces
		else
			@pieces = @pieces.filter (p) -> p isnt piece
				
	
class Option
	constructor: (params) ->
		(this[key] = value) for key, value of params
		
class Piece
	setVisibleToPlayer: (player, visible) ->
		player.setPieceAsVisible(this, visible)
		
Game: class Game
		constructor: ->
			@players = []
			@running = false
			@history = []
			@listeners = []
		
		initializer: ->
			Player: Player
			Option: Option
			Piece: Piece
			
			setPlayers: (players) =>
				@players = (player for player in players)
				
			setActivePlayer: (activePlayer) =>
				@history.push new Option
					nextActivePlayer: activePlayer
				
			alertListeners: (data) => listener(data) for listener in @listeners
			
			end: (outcome) =>
				if outcome.winner?
					alert "The winner is " + outcome.winner
				else
					alert "The game is a draw."
				
			
		runner: ->
			game: this
			getActivePlayer: =>
				@history[@history.length-1].nextActivePlayer.name
				#Talk about why we don't just access activePlayer. It's not about security. It's about accidents and implementation.
				
			getOptions: =>
				@history[@history.length-1].nextActivePlayer.options
			
			commitOption: (optionId) =>
				options = @runner().getOptions()
				if optionId not of options
					return false
				option = options[optionId]
				if not option.condition()
					return false
				@history.push option
				option.effect()
				return true
				
			addListener: (listener) =>
				@listeners.push listener unless listener in @listeners
				


Multigame =
	load: (filename, callback) ->
		game = new Game
		$.ajax
			url: filename
			dataType: "text"
		.done (data) -> 
			initializer = game.initializer()
			new Function("Game", data).call(initializer, initializer)
			game.running = true

			#Talk about why we didn't put a loop here. We don't want to unneccerily restrict the flow of the program.
			callback(game.runner())
				
			
global "Multigame", Multigame