var glyph = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("minimap_container").FindChildTraverse("GlyphScanContainer").FindChildTraverse("glyph");
var glyphBack = $.CreatePanel("Panel", $.GetContextPanel(), "ManaDial");
var glyphTip = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Tooltips").FindChildTraverse("DOTAHUDGlyphTooltip");
glyphBack.BLoadLayoutSnippet("ManaDial");
glyphBack.SetParent(glyph);
glyphBack.hittest = false;
var glyphNew = $.CreatePanel("Button", $.GetContextPanel(), "SpellbringerButton");
glyphNew.BLoadLayoutSnippet("SpellbringerButton");
glyphNew.SetParent($.GetContextPanel().FindChildTraverse("SpellbringerButtonBox"));
glyph.FindChildTraverse("GlyphButton").style.visibility = "collapse";
glyph.FindChildTraverse("GlyphButton").hittest = false;
//glyph.FindChildTraverse("GlyphButton").style.backgroundImage = 'url("s2r://panorama/images/custom_game/icon_glyph_on_psd_png.vtex")';
//glyph.FindChildTraverse("GlyphButton").SetPanelEvent("onmouseover","GlyphTooltip()");
//glyph.FindChildTraverse("GlyphButton").SetPanelEvent("onmouseout","DOTAHideTitleTextTooltip()");
//var manaBar = 0;
var sbActive = 0;
var nowMana = 0;
var prevMana = 0;
var ttOn = false;
glyphNew.SetPanelEvent("onmouseover",function(){
	GlyphTooltipOn();
});
glyphNew.SetPanelEvent("onmouseout",function(){
	GlyphTooltipOff();
});
glyph.FindChildTraverse("GlyphCooldown").style.visibility = "collapse";
//glyph.FindChildTraverse("GlyphCooldown").RemoveAndDeleteChildren();
//glyph.FindChildTraverse("GlyphCooldown").contentheight = "0px";
glyph.FindChildTraverse("GlyphCooldown").hittest = false;
//glyphTip.style.visibility = "collapse";
//glyphTip.FindChildTraverse("Contents").contentheight = "0px";
//glyphTip.GetChild(1).RemoveAndDeleteChildren();
//glyphTip.RemoveAndDeleteChildren();

function ManaBarUpdate(event) {
	var sb = event.sb;
	if (sb == sbActive) {
		//var manaBarDeg = manaBar*0.18;
		var manaBarDeg = Entities.GetMana(sb)*0.18;
		nowMana = Math.floor(Entities.GetMana(sb));
		if (prevMana != nowMana && ttOn) {
			prevMana = nowMana;
			GlyphTooltipOn();
		}
		glyphBack.style.clip = "radial(50.0% 50.0%, 0.0deg, "+manaBarDeg+"deg)";
		//$.Msg(manaBar+"/2000");
		//manaBar = manaBar+1;
		var wowNew = {};
		wowNew.sb = sb;
		$.Schedule(0.1,function() {ManaBarUpdate(wowNew);});
	}
}
function ManaBarUpdateNew(event) {
	sbActive = event.sb;
	glyphNew.SetPanelEvent(
	"onactivate",
	function(){
		GameUI.SelectUnit(sbActive,false);
	});
	var wowNew = {};
	wowNew.sb = sbActive;
	ManaBarUpdate(wowNew);
}

function GlyphTooltipOn() {
	$.DispatchEvent( "DOTAShowTitleTextTooltip",glyphNew,
	"Spellbringer",
	"<b>Mana: "+nowMana+"/2000</b>");
	//$.Localize("#DOTA_HeroSelector_SelectHero_Label")
	ttOn = true;
}
function GlyphTooltipOff() {
	$.DispatchEvent("DOTAHideTitleTextTooltip", glyphNew);
	ttOn = false;
}

(function () {
	GameEvents.Subscribe("spellbringer_mana_update", ManaBarUpdateNew)
})();