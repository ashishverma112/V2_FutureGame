package bingoV1.loginScreen 
{
	/**
	 * ...
	 * @author dwijendra
	 */
	import flash.events.MouseEvent;
	import bingoV1.lobbyScreen.MainLobbyScreen;
	import gameCommon.smartFoxAPI.SfsMain;
	
	public class LobbyButtonHandeler
	{
	    private var _mls:MainLobbyScreen;
		 private var _MLS:*;
		public function LobbyButtonHandeler(scrn:MainLobbyScreen,scrrenui:*) 
		{
			_mls = scrn;
			_MLS = scrrenui;
			addCommonListener();
		}
		public function addCommonListener():void
		{
           for (var j:int = 1; j <= 5; j++)
		   {
			for (var i:int = 1; i <=8;i++)
			{
			     _MLS["room"+j]["btn" + i].addEventListener(MouseEvent.CLICK,_mls.setbgcolor);
				_MLS["room"+j]["mark"+i].addEventListener(MouseEvent.CLICK,_mls.setmarkcolor);
			}
			_MLS["room"+j]["mark9"].addEventListener(MouseEvent.CLICK,_mls.setmarkcolor);
			_MLS["room" + j]["mark10"].addEventListener(MouseEvent.CLICK, _mls.setmarkcolor);
			_MLS["room" + j].currentcolor.gotoAndStop(1);
			_MLS["room" + j].currentmark.gotoAndStop(1);
			_MLS["room" + j].go.stop();
		   }
			
			
		}
		public function addListener(scr:*):void
		{
			for (var i:int = 1; i <= 6;i++ )
			{
				scr["buycard_" + i].addEventListener(MouseEvent.CLICK, _mls.buycard);
			
			}
			
		}
		public function removeListener(scr:*):void
		{
			for (var i:int = 1; i <= 6;i++ )
			{
				scr["buycard_"+i].removeEventListener(MouseEvent.CLICK,_mls.buycard);
			}
			
		}
		
	}

}