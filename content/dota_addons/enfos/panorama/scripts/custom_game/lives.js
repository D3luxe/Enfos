var radTeam = {};
var dirTeam = {};
var selectedPlayer = -1;

GameEvents.Subscribe("lives_update",UpdateLivesCount);

function UpdateLivesCount(table) {
	leftLives = table.leftlives;
	rightLives = table.rightlives;
	$('#LivesBackLeft').text = table.leftlives;
	$('#LivesBackRight').text = table.rightlives;
}