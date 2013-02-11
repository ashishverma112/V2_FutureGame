package bingoV1.gameScreen 
{
	/**
	 * ...
	 * @author dwijendra
	 */
	import gameCommon.screens.BaseScreen;
    import flash.text.TextField;
	import flash.events.MouseEvent
	import flash.utils.setTimeout;
	import flash.utils.clearInterval;
	
	public class Winner extends BaseScreen
	{
		public var	card:BingoCard ;
		public var _winType:int;
		public var _userName:String;
		private var _cardArr:Array;
		private var _cardno:Array;
		private var isVisible:Boolean = false;
		private var timerId:uint;
		private var timerStagId:uint;
		private var _bgs:BingoGameScreen;
		//public var _name:TextField;
		//public var 
		public function Winner(typeOfWinner:int,userName:String,cardnos:String,generatenums:String,bgs:BingoGameScreen)  
		{
			//trace("winner type", typeOfWinner);
			_winType = typeOfWinner;
			_userName = userName;
			_cardArr = cardnos.split(",");
			_cardno = generatenums.split(",");
			_bgs = bgs;
			card= new BingoCard(_cardArr,fun);
			card.setCardBackGround(BingoGameScreen.roundno);
			for (var i:int = 0; i < _cardno.length;++i )
			{
				card.checkNumber(_cardno[i],false);
			}
			addUser();
			//addChild(screenUI);
			
		}
		public function showWinnerCard(me:MouseEvent):void
		{
			if (!isVisible)
			{
				
				
				WinnerList.userscreen.parent.parent.addChild(card);
				card.x =WinnerList. userscreen.winnerliststartP.x-60;
				card.y =WinnerList. userscreen.winnerliststartP.y;
				isVisible = true;
				//_bgs.addStagEvent();
				timerStagId = setTimeout(_bgs.addStagEvent, 10);
				timerId = setTimeout(removeCard, 4000);
			}
			else
			{
				
				_bgs.removeStagEvent();
				WinnerList.userscreen.parent.parent.removeChild(card);
				isVisible = false;
			}
			
			//_winnerScreen.setHeadName(_name,card,_totalCards,_noOfwinningCards);
		}
		public function removeCard():void
		{
			//trace("hi listener6");
			if (isVisible)
			{
				//trace("hi listener7");
				_bgs.removeStagEvent();
				clearInterval(timerId);
				clearInterval(timerStagId);
				WinnerList.userscreen.parent.parent.removeChild(card);
				isVisible = false;
			}
			
		}
		public function addUser():void
		{
			if (_winType==3)
			{
			  screenUI = new Resources.fwinner();
			}
			if (_winType==4)
			{
			   screenUI = new Resources.swinner();
			}
			if (_winType==5)
			{
			   screenUI = new Resources.vwinner();
			}
			screenUI.userName.text = _userName;
			addChild(screenUI);
		//	trace("username#############################3",_userName);
			addGameEventListener(screenUI.userName, MouseEvent.CLICK, showWinnerCard);
			
		}
		private function fun(str:String):void
		{
			
		}
		
	}

}