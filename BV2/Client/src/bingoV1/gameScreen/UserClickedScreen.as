package bingoV1.gameScreen 
{
	import gameCommon.screens.BaseScreen;
	import flash.events.MouseEvent;
	import multiLanguage.ResizeableContainer;
	import multiLanguage.LanguageXMLLoader;
	import GetDisplayObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * ...
	 * @author Siddhant
	 */
	public class UserClickedScreen extends BaseScreen
	{
		private var _currentName:String;
		private var _bingoUser:BingoUser;
		private var _username:String;
		
		
		public function UserClickedScreen(userName:String) 
		{
			
			_username = userName;
			
			//_bingoUser = bingouser;
			//screenUI = new Resources.userClickedScreen();
			  screenUI = GetDisplayObject.getSymbol("userClickedScreen");
			   screenUI.block_res.mouseEnabled = false;
			  addChild(screenUI);
			addGameEventListener(screenUI.closeB, MouseEvent.CLICK, hideUI);			
			//addGameEventListener(screenUI.privateChatB, MouseEvent.CLICK, privateChatClicked);
			addGameEventListener(screenUI.blockB, MouseEvent.CLICK, blockUserClicked);
			addGameEventListener(screenUI.profileB, MouseEvent.CLICK, profileButtonClicked);
			//ResizeableContainer.setTextToUI(screenUI, LanguageXMLLoader._loadedXML.UserClickedScreen);
			//trace("userclick")
		}
		private function profileButtonClicked(e:MouseEvent):void
		{
			var str:String = GetDisplayObject.getProfileArray()+_currentName;
		
		var request:URLRequest = new URLRequest(str);
	     	try {
				navigateToURL(request, "_blank");
			   } 
		 catch (e:Error) {
						trace("Error occurred!");
					}
		}
		
		private function blockUserClicked(evt:MouseEvent):void
		{
			if (!_bingoUser._isAdmin)
			{
			
			IgnoreUserManager.addIgnoredUser(_bingoUser._userName, !_bingoUser._isBlocked);
			//_bingoUser._isBlocked = !_bingoUser._isBlocked;
			hideUI();
			}
		}
		
		private function privateChatClicked(evt:MouseEvent):void
		{
			//things to be done
			//remove the current UI
			hideUI();
			PrivateChatManager._pcManager.addChatMessage(_currentName, "");			
		}
		
		private function hideUI(evt:MouseEvent = null):void
		{
			//trace ("hide UI called");
			removeGameEventListener(screenUI.privateChatB, MouseEvent.CLICK, privateChatClicked);
			removeChild(screenUI);			
		}
		
		public function setName(name:String):void
		{
			_currentName = name;			
		}
		
		public function showUI(bingoUser:BingoUser):void
		{
			_currentName = bingoUser._userName;
			_bingoUser = bingoUser;
			addChild(screenUI);		
			if (bingoUser._isBlocked == false)
			{
				screenUI.block_res.text = "Blokkeer";
				
				addGameEventListener(screenUI.privateChatB, MouseEvent.CLICK, privateChatClicked);
			}
			else
			{
				 screenUI.block_res.text = "Deblokkeer" ;
				}
				//screenUI.block_res.text = "UnBlokker";
		}
	}

}