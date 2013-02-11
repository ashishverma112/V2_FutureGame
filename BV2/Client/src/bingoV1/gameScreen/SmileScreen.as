package bingoV1.gameScreen 
{
	import bingoV1.chat.PublicChatHandler;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import gameCommon.screens.BaseScreen;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ashish
	 */
	public class SmileScreen extends BaseScreen
	{
		
		public static var smileArr:Array=["A","B","C","D","E","F","G","K"];
		public static var emoticonString:Array = [":$", ":9", ":b", ":s", ":p", ":)", ":(", ":*"];
		
		
//	SYMBOL A = :$
//SYMBOL B = :9
//SYMBOL C = :B
//SYMBOL D = :S
//SYMBOL E =  :P
//SYMBOL F =  :)
//SYMBOL G =  :(
//SYMBOL K =  :*


		
		public function SmileScreen() 
		{
			
			screenUI = new Resources.smilies();
			addChild(screenUI);
			//addEvent();
		}
		public function addEvent(ps:*):void
		{
			ps.emosStr = "";
			
			for (var i:int = 0; i < smileArr.length; i++)
			{
				addGameEventListener(screenUI[smileArr[i]], MouseEvent.CLICK, ps.smileFun);
			}
		
		}
		public function removeEvent(ps:*):void
		{
			for (var i:int = 0; i <  smileArr.length; i++)
			{
				removeGameEventListener(screenUI[smileArr[i]], MouseEvent.CLICK, ps.smileFun);
			}
		}
		
		
	}

}