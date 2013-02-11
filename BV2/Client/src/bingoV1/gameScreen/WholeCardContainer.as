package bingoV1.gameScreen 
{
	import gameCommon.screens.BaseScreen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author dwijendra
	 */
	public class WholeCardContainer extends BaseScreen
	{
		public var close:Function;
		private var _closeB:*;
		public function WholeCardContainer(scr:*,clse:Function) 
		{
			close = clse;
			screenUI = new Resources.wholeCardContainer();
			_closeB = new Resources.closeB();
			
			//screenUI.height = BingoBook._cardHeight;
			//screenUI.width = BingoBook._cardWidth ;
			
			screenUI.addChild(scr);
			scr.y = screenUI.StartP.y-4;
			addChild(screenUI);
			addChild(_closeB);
			_closeB.x = screenUI.closeP.x+18;
			_closeB.y = screenUI.closeP.y-5;
			_closeB.height = 20;
			_closeB.width = 20;
			
		    addGameEventListener(_closeB, MouseEvent.CLICK,closeScreen);
		}
		public function closeScreen(evt:MouseEvent):void
		{
			close();
		}
	    public function resizeScreen(hsf:Number,vsf:Number):void
		 {
			    screenUI.scaleX = hsf;
				screenUI.scaleY = vsf;
					_closeB.x = (screenUI.closeP.x+18)*hsf;
			       _closeB.y = (screenUI.closeP.y-5)*vsf;
				
				
	     }
	}
}

