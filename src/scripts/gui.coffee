Multigame.load("scripts/tictactoe.rules.js", (rules) ->
	gameState = rules.newGame()
	$("#activePlayerFrame").html("It's player " + gameState.activePlayer.name + "'s turn")
	global "chooseSpace", (i, j) ->
		if gameState.ended
			return
		activePlayer = gameState.activePlayer
		symbol = activePlayer.name
		commitResult = gameState.commitOption(activePlayer, [i, j], [i, j])
		if commitResult.success
			gameState = commitResult.newState
			$("#board").children().eq(3*i+j).html(symbol)
			if gameState.ended
				if gameState.winner?
					alert("Player " +  gameState.winner.name + " wins!")
				else
					alert("It's a draw!")
			else
				$("#activePlayerFrame").html("It's player " + gameState.activePlayer.name + "'s turn")
		else
			console.log(commitResult.error)
)

