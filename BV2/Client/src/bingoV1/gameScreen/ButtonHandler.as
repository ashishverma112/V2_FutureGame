package bingoV1.gameScreen 
{
	import flash.events.MouseEvent;
	import bingoV1.lobbyScreen.MainLobbyScreen;
	import gameCommon.smartFoxAPI.SfsMain;
	/**
	 * ...
	 * @author Siddhant
	 */
	public class ButtonHandler
	{
		private var _gameScreen:BingoGameScreen;
		private var _screenUI:*;
		private var _roomId:int;
		private const buttonNameArray:Array = ["showBallsPassed_btn", "buyCards_btn", "funPlay_btn", "automate_btn", "gotoJackpot_btn"];
		private const functionNameA:Array = ["showBallsPassed", "buyCards", "funPlayClicked", "automateClicked", "gotoJackpotClicked"];

		
		public function ButtonHandler(bingoGameScreen:BingoGameScreen,screenUI:*) 
		{
			_gameScreen = bingoGameScreen;
			_roomId = int(_gameScreen ._joinedRoom.getVariable("rid"));
			_screenUI = screenUI;
			
		}
		
		public function enableAllButtons(enable:Boolean):void
		{
			if (Main.isRealPlay)
			{
				
				
			for (var i:int = 0; i < buttonNameArray.length;++i)
			{
				
				if (i!=3)
				{
					enableButton(i, enable);
				}
			}
			}
			else
			{
			    enableButton(2, enable);	
			}
			
		}
		
		public function enableButton(btnNum:int,enabled:Boolean):void
		{
			//trace ("hi",buttonNameArray[btnNum] , " button name",_screenUI[buttonNameArray[btnNum]]);
			//_screenUI[buttonNameArray[btnNum]].enabled = enabled;
			//_screenUI[buttonNameArray[btnNum]].buttonMode = enabled;
			if (Main.isRealPlay)
			{
				if (_roomId==25 && btnNum>1 )
				{
					_screenUI[buttonNameArray[btnNum]].visible = false;
					//_screenUI[buttonNameArray[4]].goldenTime.visible = false;
					_screenUI.autoState.visible = false;
					//_screenUI.fun.visible = false;
					//_screenUI.automate.visible = false;
					//_screenUI.golden.visible = false;
					//_screenUI.goldenTime.visible = false;
					//_screenUI.goldenTimeB.visible = false;
					
				}
				else
				{
							if (enabled)
						{
						_screenUI[buttonNameArray[btnNum]].addEventListener(MouseEvent.CLICK, this[functionNameA[btnNum]]);
						}
						else
						{
							_screenUI[buttonNameArray[btnNum]].removeEventListener(MouseEvent.CLICK, this[functionNameA[btnNum]]);
						}
				}
			}
			else
			{
				if (_roomId==25 && btnNum>1 )
				{
					_screenUI[buttonNameArray[btnNum]].visible = false;
					//_screenUI[buttonNameArray[4]].goldenTime.visible = false;
					_screenUI.autoState.visible = false;
					//_screenUI.fun.visible = false;
					//_screenUI.automate.visible = false;
					//_screenUI.golden.visible = false;
					//_screenUI.goldenTime.visible = false;
					//_screenUI.goldenTimeB.visible = false;
					
				}
				else
				{
				      if (enabled && btnNum==2)
			          {
				     _screenUI[buttonNameArray[btnNum]].addEventListener(MouseEvent.CLICK, this[functionNameA[btnNum]]);
			          }
			       else
			         {
				     _screenUI[buttonNameArray[btnNum]].removeEventListener(MouseEvent.CLICK, this[functionNameA[btnNum]]);
			         }
				}	 
			}
			
		}
		
		
		public function showBallsPassed(evt:MouseEvent):void
		{
			_gameScreen.showBallScreen();
		}
		
		public function buyCards(evt:MouseEvent):void
		{
			_screenUI[buttonNameArray[2]].removeEventListener(MouseEvent.CLICK, this[functionNameA[2]]);
			_gameScreen.showCardBuyScreen();
			
		}
		
		public function funPlayClicked(evt:MouseEvent):void
		{
			_gameScreen.addFunPlayer();
			//_screenUI[buttonNameArray[2]].removeEventListener(MouseEvent.CLICK, this[functionNameA[2]]);
		}
		
		public function automateClicked(evt:MouseEvent):void
		{
			_gameScreen.setAutomate();
		}
		
		public function gotoJackpotClicked(evt:MouseEvent):void
		{
			if (MainLobbyScreen.GOLDEN_ROOM!="")
			{
				//Main.setAnotherScreen(_gameScreen, MainLobbyScreen.GOLDEN_ROOM);
				// SfsMain.sfsclient.logout();
				//trace("phir bhi dil hai hindustani",MainLobbyScreen.GOLDEN_ROOM);
			   SfsMain.sfsclient.joinRoom(MainLobbyScreen.GOLDEN_ROOM);
			}
		}		
	}
}