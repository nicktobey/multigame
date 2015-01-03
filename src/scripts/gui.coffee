Multigame.load("tictactoe.rules.js", (game) ->
	$("#activePlayerFrame").html("It's player " + game.getActivePlayer() + "'s turn")
	game.addListener ({i, j, symbol}) ->
		console.log($("#board"))
		console.log($("#board").children())
		console.log($("#board").children().eq(3*i+j))
		console.log(symbol)
		$("#board").children().eq(3*i+j).html(symbol)
		$("#activePlayerFrame").html("It's player " + game.getActivePlayer() + "'s turn")
	global "game", game
)