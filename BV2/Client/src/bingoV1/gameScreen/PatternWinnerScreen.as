package bingoV1.gameScreen 
{
	import flash.events.MouseEvent;
	import gameCommon.screens.BaseScreen;
	import multiLanguage.LanguageXMLLoader;
	import multiLanguage.ResizeableContainer;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author vipul
	 */
	public class PatternWinnerScreen extends BaseScreen
	{
		
		private var _patternString:String;
		private var _winnerName:String;
		private var  _timeIntervalID:uint;
		private var _cardNumber:String;
		private var _winAmount:String;
		
		public function PatternWinnerScreen(cardNumber:String,pattrnString:String,winnerName:String,winAmount:String) 
		{
			_patternString = pattrnString;
			_winnerName = winnerName;
			_cardNumber = cardNumber;
			_winAmount = winAmount;
			
		}
		override public function initialize():void
		{
			super.initialize();
			//screenUI = new Resources.patternWinnerScreen();
			  screenUI = GetDisplayObject.getSymbol("patternWinnerScreen");
			addChild(screenUI);
			screenUI.winnerName.text = _winnerName;
			screenUI.winAmount.text = Number(_winAmount).toFixed(2);
			//ResizeableContainer.setTextToUI(screenUI, LanguageXMLLoader._loadedXML.patternWinnerScreen);
			setWinningCard();
			//checkMarksOntheNumber();
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
			var patArray:Array = _cardNumber.split(",");
			var card:BingoCard = new BingoCard(patArray);
			patArray = new Array();
		  //  trace("pattern to be marked??????????????????????????::::::::::::::::::::::::::::::::::::::::::::",_patternString);
			patArray = _patternString.split(",");  
			screenUI.addChild(card);
			for (var i:int = 0; i <patArray.length;++i )
			{
			//	trace("pattern to be marked??????????????????????????", patArray[i]);
			       card.checkNumber(patArray[i]);
			}
			//trace("pattern winner executed....................:::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
			
			card.x = screenUI.top.x;
			card.y = screenUI.top.y;
			card.width = screenUI.bottom.x - screenUI.top.x;
			card.height = screenUI.bottom.y - screenUI.top.y;
			
			
		}
		

		
	}

}