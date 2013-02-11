package bingoV1.gameScreen 
{
	import it.gotoandplay.smartfoxserver.data.Room;	
	import flash.events.MouseEvent;
	import gameCommon.screens.BaseScreen;
	import multiLanguage.LanguageXMLLoader;
	import multiLanguage.ResizeableContainer;
	import bingoV1.gameScreen.BingoGameScreen;
	import gameCommon.smartFoxAPI.SfsMain;
	
	/**
	 * ...
	 * @author vipul
	 */
	public class BuyCardsScreen extends BaseScreen
	{
		//private var _joinedRoom:Room;
		private var _cardButtonArray:Array;
		private var _currentCards:int;
		private var _maxCard:int;
		private var _bgs:BingoGameScreen;
		
		public function BuyCardsScreen(currentCards:int,maxCards:int,bingoGameScreen:BingoGameScreen) 
		{
			_currentCards = currentCards;
			_maxCard = maxCards;
			_bgs = bingoGameScreen;
			
			//screenUI = new Resources.buyCardScreen();
			  screenUI = GetDisplayObject.getSymbol("buyCardScreen");
			addChild(screenUI);
			screenUI.cardPrice.text = Number(_bgs._joinedRoom.getVariable("cp"));
			screenUI.maxCards.text = maxCards.toString();
		}
		override public function initialize():void
		{
			super.initialize();

			_cardButtonArray = [screenUI.buy1cardB, screenUI.buy5cardB, screenUI.buy10cardB];// , screenUI.done];
			//ResizeableContainer.setTextToUI(screenUI, LanguageXMLLoader._loadedXML.buyCardScreen);
			enableBuyButtons(true);
			addGameEventListener(screenUI.done, MouseEvent.CLICK, closeScreen);	
		}
		
		private function closeScreen(evt:MouseEvent):void
		{
			_bgs.removeCardsBuyScreen();
		}
		
		public function enableScreen(newCurrentCards:int):void
		{
			_currentCards = newCurrentCards;
			enableBuyButtons(true);
		}
		
		private function enableBuyButtons(enable:Boolean):void
		{
			for (var i:int = 0; i < _cardButtonArray.length;++i )
			{
				if (enable)
				{
					//_cardButtonArray[i].buttonMode = true;
					addGameEventListener(_cardButtonArray[i], MouseEvent.CLICK, onClicked);
					_cardButtonArray[i].enabled = true;
					//_cardButtonArray[i].buttonMode = true;
				}
				else	
				{
					removeGameEventListener(_cardButtonArray[i], MouseEvent.CLICK, onClicked);
					_cardButtonArray[i].enabled = false;
					//_cardButtonArray[i].buttonMode = false;
				}
			}				
		}
		
		private function onClicked(evt:MouseEvent):void
		{
			var buttonName:String = evt.currentTarget.name;
			//var maxCard:int = int(_bgs._joinedRoom.getVariable("mcpRV"))
			//trace("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$", _currentCards);
			var cardsToBuy:int = 0;
			var card_price:Number = Number(_bgs._joinedRoom.getVariable("cp"));
			//var totalAmount:Number = Number(_bgs.screenUI.cashAmount.text)+Number(_bgs.screenUIgameAmount.text)
			var totalAmount:Number = _bgs.total_Amount;
			switch(buttonName)
			{
				case "buy1cardB":
				if (((_currentCards + 1)<=_maxCard )&&totalAmount>=card_price)
				{
					cardsToBuy = 1;		
				}
				    break;
					  
				case "buy5cardB":
				
				if ((_currentCards + 5)<= _maxCard&&totalAmount>=(card_price*5))
				{
					cardsToBuy = 5;		
				}
				    break;	 
					  
				case "buy10cardB":
					if ((_currentCards + 10)<= _maxCard&&totalAmount>=(card_price*10))
				{
					cardsToBuy = 10;		
				}
				    break;
					  
				//case "done":
				    /*for (var i:int = 0; i < _cardButtonArray.length;++i )
					{
						removeGameEventListener(_cardButtonArray[i], MouseEvent.CLICK, onClicked);
					}
				    removeChild(screenUI);*/
					//_bgs.removeCardsBuyScreen();
				   // break;	  
			}
			/*if (cardsToBuy + _currentCards > _maxCards)
			{
				cardsToBuy = _maxCards - _currentCards;
				
			}*/	
			
				//trace("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$card to buy", cardsToBuy);
			if (cardsToBuy>0)
			{
			sendCardBuyRequest(cardsToBuy);
			}
		}
		
		private function sendCardBuyRequest(numCards:int):void
		{
			//trace ("Sending Card buy request for ", numCards);
			var sendParam:Array=[ServerConstants.CARD_BUY_REQUEST,numCards.toString()];
			SfsMain.sfsclient.sendXtMessage("gameExt", ServerConstants.CARD_BUY_REQUEST, sendParam, "str");
			enableBuyButtons(false);
		}
	}
}