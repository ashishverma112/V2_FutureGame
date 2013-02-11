package bingoV1.gameScreen 
{
	import gameCommon.screens.BaseScreen;
	import flash.events.MouseEvent;
	import gameCommon.lib.SoundPlayer;
	import bingoV1.lobbyScreen.MainLobbyScreen
	
	/**
	 * ...
	 * @author ashish
	 */
	public class LineWinner extends BaseScreen
	{
		private var _name:String;
		private var _cardArr:Array;
		private var _winnerScreen:WinnerScreen;
		private var _amt:Number;
		private var _cardno:Array;
		private var _id:String;
		private var _winInfo:Array;
		private var _totalCards:uint;
		private var _noOfwinningCards:uint;
	
		
		public function LineWinner(wnrScr:WinnerScreen, winInfo:String)// name:String, cardArr:String, amt:Number, markNo:String, id:String) 
		{
			_winnerScreen = wnrScr;
			_winInfo = winInfo.split("@");
			
			_name = _winInfo[0];// .split("@");
			_cardArr = _winInfo[1].split(",");
			_amt = _winInfo[2];
			_id = _winInfo[6];
			_cardno = _winInfo[5].split(",");
			_totalCards = _winInfo[3];
			_noOfwinningCards = _winInfo[4];
			screenUI = GetDisplayObject.getSymbol("WinnerCard");
			screenUI.popupcolor.gotoAndStop(MainLobbyScreen._bgcolor);
			addGameEventListener(screenUI.closeB, MouseEvent.CLICK, closeScreen);
			//screenUI = new Resources.winnerInfo();
			addChild(screenUI);
			screenUI.userName.text = _name;
			screenUI.winid.text = _id;
			screenUI.winnerLine.text =_winnerScreen.lineArray[_id];
			screenUI.winBalane.text = setAmount();
			showWinnerCard();
			//screenUI.buttonMode = true;
			//addGameEventListener(screenUI, MouseEvent.CLICK, showWinnerCard);
			
		}
		private function closeScreen(e:MouseEvent):void
		{
		//	trace("kya aaya "+e)
			//if (e != null)
			 SoundPlayer.playSound("buttonClick");
			//_closeScreen();
			if (screenUI)
			{
			
			removeGameEventListener(screenUI.closeB, MouseEvent.CLICK, closeScreen);
			removeChild(screenUI);
			screenUI = null;
			
			}
			//clearTimeout(_timeIntervalID);
		}
		private function setAmount():String
		{
			var str:String = "";
			str = _amt.toFixed(2);
			var arr:Array = str.split(".");
			if (int(arr[1]) == 0)
			 arr[1]="-"
			str ="€ " + arr[0] + "," + arr[1];
			return str;
		}
		public function showWinnerCard():void
		{
			
			//SoundPlayer.playSound("buttonClick");
			var	card:BingoCard = new BingoCard(_cardArr,fun);
			card.setCardBackGround(BingoGameScreen.roundno);
			for (var i:int = 0; i < _cardno.length;++i )
			{
				card.checkNumber(_cardno[i]);
			}
			screenUI.addChild(card);
			card.x = screenUI.startP.x;
			card.y = screenUI.startP.y;
			card.width = screenUI.endP.x - screenUI.startP.x;
			card.height = screenUI.endP.y - screenUI.startP.y;
			//_winnerScreen.setHeadName(_name,card,_totalCards,_noOfwinningCards);
		}
		private function fun(str:String):void
		{
			
		}
		
	
	}

}