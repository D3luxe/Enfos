var secretList = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("shop").FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("GridSecretShopItems").FindChildTraverse("ShopItems_secretshop");

//forgive me for what i am about to do
var itemCenter = secretList.Children();
for (var ds of itemCenter) {ds.style.horizontalAlign = "center";}
//secretList.FindChildTraverse("SecretShopItem").style.horizontalAlign = "center";

var exchangeBox = $.CreatePanel("Panel", $.GetContextPanel(), "ExchangeBase");
exchangeBox.BLoadLayoutSnippet("ExchangeBase");
exchangeBox.SetParent(secretList);

var topLabel = $.CreatePanel("Label", $.GetContextPanel(), "ExchangeLabel");
topLabel.BLoadLayoutSnippet("ExchangeLabel");
topLabel.SetParent(exchangeBox);
topLabel.text = "LUMBER EXCHANGE";

var innerBox = $.CreatePanel("Panel", $.GetContextPanel(), "ExchangeBuffer");
innerBox.BLoadLayoutSnippet("ExchangeBuffer");
innerBox.SetParent(exchangeBox);

	var labelBoxOne = $.CreatePanel("Panel", $.GetContextPanel(), "LabelPanel");
	labelBoxOne.BLoadLayoutSnippet("LabelPanel");
	labelBoxOne.SetParent(innerBox);
	
		var topLabel = $.CreatePanel("Label", $.GetContextPanel(), "BuyLabel");
		topLabel.BLoadLayoutSnippet("BuyLabel");
		topLabel.SetParent(labelBoxOne);
		topLabel.text = "BUY";
	
	var buttonBoxOne = $.CreatePanel("Panel", $.GetContextPanel(), "ButtonPanel");
	buttonBoxOne.BLoadLayoutSnippet("ButtonPanel");
	buttonBoxOne.SetParent(innerBox);
	
		var buyButtonOne = $.CreatePanel("Button", $.GetContextPanel(), "BuyButton1");
		buyButtonOne.BLoadLayoutSnippet("BuyButton1");
		buyButtonOne.SetParent(buttonBoxOne);
		buyButtonOne.SetPanelEvent("onactivate","DoExchange(0)");
		
			var reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "BuyAmountLabel");
			reusableLabel.BLoadLayoutSnippet("BuyAmountLabel");
			reusableLabel.SetParent(buyButtonOne);
			reusableLabel.text = "1";
			
			reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "BuyCostLabel");
			reusableLabel.BLoadLayoutSnippet("BuyCostLabel");
			reusableLabel.SetParent(buyButtonOne);
			reusableLabel.text = "125";
			
		var forgotAboutThisOne = $.CreatePanel("Panel", $.GetContextPanel(), "Buffer1");
		forgotAboutThisOne.BLoadLayoutSnippet("Buffer1");
		forgotAboutThisOne.SetParent(buttonBoxOne);
			
		var buyButtonTwo = $.CreatePanel("Button", $.GetContextPanel(), "BuyButton2");
		buyButtonTwo.BLoadLayoutSnippet("BuyButton2");
		buyButtonTwo.SetParent(buttonBoxOne);
		buyButtonTwo.SetPanelEvent("onactivate","DoExchange(1)");
		
			reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "BuyAmountLabel");
			reusableLabel.BLoadLayoutSnippet("BuyAmountLabel");
			reusableLabel.SetParent(buyButtonTwo);
			reusableLabel.text = "10";
			
			reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "BuyCostLabel");
			reusableLabel.BLoadLayoutSnippet("BuyCostLabel");
			reusableLabel.SetParent(buyButtonTwo);
			reusableLabel.text = "1250";
		
		var forgotAboutThisTwo = $.CreatePanel("Panel", $.GetContextPanel(), "Buffer2");
		forgotAboutThisTwo.BLoadLayoutSnippet("Buffer2");
		forgotAboutThisTwo.SetParent(buttonBoxOne);
		
		var buyButtonThree = $.CreatePanel("Button", $.GetContextPanel(), "BuyButton3");
		buyButtonThree.BLoadLayoutSnippet("BuyButton3");
		buyButtonThree.SetParent(buttonBoxOne);
		buyButtonThree.SetPanelEvent("onactivate","DoExchange(2)");
		
			reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "BuyAmountLabel");
			reusableLabel.BLoadLayoutSnippet("BuyAmountLabel");
			reusableLabel.SetParent(buyButtonThree);
			reusableLabel.text = "100";
			
			reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "BuyCostLabel");
			reusableLabel.BLoadLayoutSnippet("BuyCostLabel");
			reusableLabel.SetParent(buyButtonThree);
			reusableLabel.text = "12500";
			
	var labelBoxTwo = $.CreatePanel("Panel", $.GetContextPanel(), "LabelPanel2");
	labelBoxTwo.BLoadLayoutSnippet("LabelPanel2");
	labelBoxTwo.SetParent(innerBox);
	
		var botLabel = $.CreatePanel("Label", $.GetContextPanel(), "SellLabel");
		botLabel.BLoadLayoutSnippet("SellLabel");
		botLabel.SetParent(labelBoxTwo);
		botLabel.text = "SELL";
		
	var buttonBoxTwo = $.CreatePanel("Panel", $.GetContextPanel(), "ButtonPanel2");
	buttonBoxTwo.BLoadLayoutSnippet("ButtonPanel2");
	buttonBoxTwo.SetParent(innerBox);
	
		var sellButtonOne = $.CreatePanel("Button", $.GetContextPanel(), "SellButton1");
		sellButtonOne.BLoadLayoutSnippet("SellButton1");
		sellButtonOne.SetParent(buttonBoxTwo);
		sellButtonOne.SetPanelEvent("onactivate","DoExchange(3)");
		
			reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "SellAmountLabel");
			reusableLabel.BLoadLayoutSnippet("SellAmountLabel");
			reusableLabel.SetParent(sellButtonOne);
			reusableLabel.text = "100";
			
			reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "SellCostLabel");
			reusableLabel.BLoadLayoutSnippet("SellCostLabel");
			reusableLabel.SetParent(sellButtonOne);
			reusableLabel.text = "1";
			
		var forgotAboutThisThree = $.CreatePanel("Panel", $.GetContextPanel(), "Buffer3");
		forgotAboutThisThree.BLoadLayoutSnippet("Buffer3");
		forgotAboutThisThree.SetParent(buttonBoxTwo);
			
		var sellButtonTwo = $.CreatePanel("Button", $.GetContextPanel(), "SellButton2");
		sellButtonTwo.BLoadLayoutSnippet("SellButton2");
		sellButtonTwo.SetParent(buttonBoxTwo);
		sellButtonTwo.SetPanelEvent("onactivate","DoExchange(4)");
		
			reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "SellAmountLabel");
			reusableLabel.BLoadLayoutSnippet("SellAmountLabel");
			reusableLabel.SetParent(sellButtonTwo);
			reusableLabel.text = "1000";
			
			reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "SellCostLabel");
			reusableLabel.BLoadLayoutSnippet("SellCostLabel");
			reusableLabel.SetParent(sellButtonTwo);
			reusableLabel.text = "10";
		
		var forgotAboutThisFour = $.CreatePanel("Panel", $.GetContextPanel(), "Buffer4");
		forgotAboutThisFour.BLoadLayoutSnippet("Buffer4");
		forgotAboutThisFour.SetParent(buttonBoxTwo);
		
		var sellButtonThree = $.CreatePanel("Button", $.GetContextPanel(), "SellButton3");
		sellButtonThree.BLoadLayoutSnippet("SellButton3");
		sellButtonThree.SetParent(buttonBoxTwo);
		sellButtonThree.SetPanelEvent("onactivate","DoExchange(5)");
		
			reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "SellAmountLabel");
			reusableLabel.BLoadLayoutSnippet("SellAmountLabel");
			reusableLabel.SetParent(sellButtonThree);
			reusableLabel.text = "10000";
			
			reusableLabel = $.CreatePanel("Label", $.GetContextPanel(), "SellCostLabel");
			reusableLabel.BLoadLayoutSnippet("SellCostLabel");
			reusableLabel.SetParent(sellButtonThree);
			reusableLabel.text = "100";

var itemRemoval = secretList.FindChildrenWithClassTraverse("SecretShopItem");
//$.Msg(itemRemoval);
for (var bg of itemRemoval) {bg.style.visibility = "collapse";}

function DoExchange(event){
	var data = {};
	//0-2 - Buy lumber
	//3-5 - Sell lumber
	//$.Msg(radTeam[selectedPlayer])
	//$.Msg(selectedPlayer)
	data.player = Game.GetLocalPlayerID();
	data.type = event;
	GameEvents.SendCustomGameEventToServer("wood_ui_event",data);
}