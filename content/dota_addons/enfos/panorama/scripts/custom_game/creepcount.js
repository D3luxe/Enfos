function OnCreepCountChange ( args ) {
	var rad = args.radC
	var dir = args.dirC
	$('#RadCounter').text = rad
	$('#DirCounter').text = dir
	if (rad < 100) $('#RadCounter').style.color = "#ccc";
	else {
		if (rad < 150) $('#RadCounter').style.color = "#fff";
		else {
			if (rad < 190) $('#RadCounter').style.color = "#ff0";
			else {
				if (rad < 200) $('#RadCounter').style.color = "#f90";
				else $('#RadCounter').style.color = "#f00";
			}
		}
	}
	if (dir < 100) $('#DirCounter').style.color = "#ccc";
	else {
		if (dir < 150) $('#DirCounter').style.color = "#fff";
		else {
			if (dir < 190) $('#DirCounter').style.color = "#ff0";
			else {
				if (dir < 200) $('#DirCounter').style.color = "#f90";
				else $('#DirCounter').style.color = "#f00";
			}
		}
	}
}

function AbilityShowTooltip()
{
	$.DispatchEvent( "DOTAShowTitleTextTooltip", $("#CountBox"), "Creep Count", "The total number of creeps on your side of the map and on the other side. Bonus Wave is counted here. If the count reaches 200, creeps on that side will be teleported into the goal until the count reaches 190." );
}

function AbilityHideTooltip()
{
	$.DispatchEvent( "DOTAHideTitleTextTooltip");
}

(function () {
	GameEvents.Subscribe( "creep_count_update", OnCreepCountChange );
})();