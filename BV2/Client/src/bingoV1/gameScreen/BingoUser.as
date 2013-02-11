package bingoV1.gameScreen 
{
	import flash.events.MouseEvent;
	import gameCommon.screens.BaseScreen;
	import bingoV1.lobbyScreen.MainLobbyScreen;
	
	/**
	 * ...
	 * @author vipul
	 */
	public class BingoUser extends BaseScreen
	{
		//public var _userId:int;
		public var _userName:String;
		public var _utype:int;
		public var _userHeight:Number=25;
		public var _userWidth:Number = 200;
		public var _isBlocked:Boolean;
		static private var _userClickedScr:UserClickedScreen;
		private var _blockSymbol:*;
		public var _isAdmin:Boolean = false;;
		private var winner:WinnerScreen;
		public function BingoUser(userobj:Object) 
		{
			_userName = userobj.name;
			_utype =int(userobj.type);
				
			_isBlocked = false;
			screenUI = new Resources.userSymbol();
			screenUI.fwinner.visible = false;
			screenUI.swinner.visible = false;
			screenUI.bwinner.visible = false;
			
			//screenUI.width = _userWidth;
			//screenUI.height = _userHeight;
			addChild(screenUI);
			addUserClickedScreen();
			screenUI.username.text = _userName;
			screenUI.username.mouseEnabled = false;
			
			setState(_utype);
		}
		public function setState(state:int):void
		{
			if (state>=10)
			{
				//state = state-10;
				 screenUI.onoff.gotoAndStop(3); 
				_isAdmin = true;
			}
		
	     	if (_isAdmin)				
		    screenUI.username.htmlText = "<font color='#0000ff'>" + _userName +"</font>";
			
			if (state == 1) 
			{
			   screenUI.onoff.gotoAndStop(1); 
			}
		
			if (state == 2) 
			{
			 screenUI.onoff.gotoAndStop(2);
			}
				   _utype = state;
					
		}
		
		override public function initialize():void
		{
			super.initialize();
			//addUserClickedScreen();
		
			//adding private chat option screen

		}
		public function get weight():int
		{
			var returnVal:int = 0;
			if (_utype == 4 || _utype == 5 || _utype==3)
			{
				returnVal += _utype * 100;
			}
			if (_isAdmin)
			{
				returnVal = 1000;
			}
			return returnVal;
		 
		}
		private function addUserClickedScreen():void
		{
			if (_userName != Main._userName)
			{
				addGameEventListener(this, MouseEvent.CLICK, userClicked);
				buttonMode = true;
			}			
		}
		
		private function removeUserClickedScreen():void
		{
			removeGameEventListener(this, MouseEvent.CLICK, userClicked);
			buttonMode = false;

		}
		
		
		public function userClicked(evt:MouseEvent):void
		{
		//	trace ("User Clicked");
			if (_userClickedScr == null)
				_userClickedScr = new UserClickedScreen(_userName);
			this.parent.parent.addChild(_userClickedScr);
			//if (_userClickedScr)
			{
				//_userClickedScr.setName(_userName);
				_userClickedScr.showUI(this);
				_userClickedScr.x = this.parent.x + this.x + _userClickedScr.width;
				_userClickedScr.y = this.parent.y + this.y;				
			}		
		}
		
		public function setName(noOfWinningCard:int,noOfTotalCard:String,WinningAmount:String):void
		{
			//screenUI.winningCards.text= noOfWinningCard.toString();
		//	screenUI.totalCards.text = noOfTotalCard;
		 //   screenUI.winningAmount.text = ((Number(WinningAmount)*noOfWinningCard).toFixed(2)).toString();
			
		}
		
		public function setUserBlocked(block:Boolean):void
		{
			//addGameEventListener(this, MouseEvent.CLICK, userClicked);
			//buttonMode = true;
			_isBlocked = block;
			if (_isBlocked )
			{
				screenUI.username.htmlText = "<font color='#ff0000'>" + _userName +"</font>";
				if (_blockSymbol)
					return;
				_blockSymbol = new Resources.userBlockSymbol();
			//	addChild(_blockSymbol);
				//var bs:* = new Resources.userBlockSymbol();			
				//addChild(bs);
				//trace ("Adding blocked symbol");
			}
			else
			{
				if (_blockSymbol)
				{
			    if (_isAdmin)				
				      screenUI.username.htmlText = "<font color='#0000ff'>" + _userName +"</font>";
				else
			        screenUI.username.htmlText = _userName;
					//removeChild(_blockSymbol);
					_blockSymbol = null;
				}
			}
		}
	}
}