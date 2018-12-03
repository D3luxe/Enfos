var newUI = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");
var fuck = newUI.FindChildTraverse("StatBranchHotkey").GetChild(0).text;

$.Msg(fuck);

function WrapFunction(name) {
    return function() {
        Game[name]();
    };
}

Game.CreateCustomKeyBind(fuck, 'AttributeHotkey');
Game.AddCommand('AttributeHotkey', WrapFunction('AttributeHotkey'), '', 0);