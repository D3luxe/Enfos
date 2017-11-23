var glyph = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("minimap_container").FindChildTraverse("GlyphScanContainer").FindChildTraverse("glyph");
var glyphBack = $.CreatePanel("Panel", $.GetContextPanel(), "ManaDial");
glyphBack.BLoadLayoutSnippet("ManaDial");
glyphBack.SetParent(glyph);
glyphBack.hittest = false;
glyph.FindChildTraverse("GlyphButton").style.backgroundImage = 'url("s2r://panorama/images/custom_game/icon_glyph_on_psd_png.vtex")';
//glyph.FindChildTraverse("GlyphButton").SetPanelEvent("onmouseover","GlyphTooltip()");
//glyph.FindChildTraverse("GlyphButton").SetPanelEvent("onmouseout","DOTAHideTitleTextTooltip()");
//var manaBar = 0;
var sbActive = 0;
var nowMana = 0;
var prevMana = 0;
var ttOn = false;
glyph.FindChildTraverse("GlyphButton").SetPanelEvent("onmouseover",function(){
	GlyphTooltipOn();
});
glyph.FindChildTraverse("GlyphButton").SetPanelEvent("onmouseout",function(){
	GlyphTooltipOff();
});

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
	glyph.FindChildTraverse("GlyphButton").SetPanelEvent(
	"onactivate",
	function(){
		GameUI.SelectUnit(sbActive,false);
	});
	var wowNew = {};
	wowNew.sb = sbActive;
	ManaBarUpdate(wowNew);
}

function GlyphTooltipOn() {
	$.DispatchEvent( "DOTAShowTitleTextTooltip",glyph.FindChildTraverse("GlyphButton"),
	"Spellbringer",
	"<b>Mana: "+nowMana+"/2000</b>");
	//$.Localize("#DOTA_HeroSelector_SelectHero_Label")
	ttOn = true;
}
function GlyphTooltipOff() {
	$.DispatchEvent("DOTAHideTitleTextTooltip", glyph.FindChildTraverse("GlyphButton"));
	ttOn = false;
}

(function () {
	GameEvents.Subscribe("spellbringer_mana_update", ManaBarUpdateNew)
})();