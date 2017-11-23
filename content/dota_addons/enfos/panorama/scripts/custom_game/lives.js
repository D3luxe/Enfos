var radTeam = {};
var dirTeam = {};
var selectedPlayer = -1;

GameEvents.Subscribe("lives_update",UpdateLivesCount);

function UpdateLivesCount(table) {
	var livesleft = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("topbar").FindChildTraverse("TopBarRadiantTeam").FindChildTraverse("TopBarRadiantPlayers").FindChildTraverse("RadiantTeamScorePlayers").FindChildTraverse("TopBarRadiantScore");
	var livesright = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("topbar").FindChildTraverse("TopBarDireTeam").FindChildTraverse("TopBarDirePlayers").FindChildTraverse("DireTeamScorePlayers").FindChildTraverse("TopBarDireScore");
	leftLives = table.leftlives;
	rightLives = table.rightlives;
	livesleft.text = table.leftlives;
	livesright.text = table.rightlives;
	$.Msg(livesleft.text);
}

(function () {
	var table = {};
	table.leftlives = 100;
	table.rightlives = 100;
	UpdateLivesCount(table);
})();