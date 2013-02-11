package bingoV1.gameScreen 
{
	import flash.events.MouseEvent;
	import gameCommon.screens.BaseScreen;
	import multiLanguage.LanguageXMLLoader;
	import multiLanguage.ResizeableContainer;
	import flash.utils.*;
	import bingoV1.lobbyScreen.MainLobbyScreen;
	/**
	 * ...
	 * @author vipul
	 */
	public class BingoWinnerScreen extends BaseScreen
	{
		private var _patternString:String;
		private var _winnerName:String;
		private var  _timeIntervalID:uint;
		private var _winAmount:String;
		
		public function BingoWinnerScreen(pattrnString:String,winnerName:String,winAmount:String) 
		{
			_patternString = pattrnString;
			_winnerName = winnerName;
			_winAmount = winAmount;
		}
		
		override public function initialize():void
		{
			super.initialize();
			//screenUI = new Resources.bingoWinnerScreen();
			
		     screenUI = GetDisplayObject.getSymbol("bingoWinnerScreen");
			addChild(screenUI);
			//MainLobbyScreen._bgcolor
			screenUI.winnerName.text = _winnerName;
			screenUI.winAmount.text = Number(_winAmount).toFixed(2);
			//ResizeableContainer.setTextToUI(screenUI, LanguageXMLLoader._loadedXML.bingoWinnerScreen);
			setWinningCard();
			addGameEventListener(screenUI.playB, MouseEvent.CLICK, closeScreen);
			_timeIntervalID = setTimeout(closeScreen, 5000, null);
		}
		
		private function closeScreen(evt:MouseEvent):void
		{
			removeGameEventListener(screenUI.playB, MouseEvent.CLICK, closeScreen);
			removeChild(screenUI);
			clearTimeout(_timeIntervalID);
		}
		private function setWinningCard():void
		{
			var patArray:Array = _patternString.split(",");
			var card:BingoCard = new BingoCard(patArray);
			  	screenUI.addChild(card); 
			for (var i:int = 0; i < patArray.length;++i )
			{
				//trace("pattern to be marked??????????????????????????", patArray[i]);
				card.checkNumber(patArray[i]);
			}
		
			card.x = screenUI.top.x;
			card.y = screenUI.top.y;
			card.width = screenUI.bottom.x - screenUI.top.x;
			card.height = screenUI.bottom.y - screenUI.top.y;
			
		}
		
	}

}