package bingoV1.gameScreen 
{
	import flash.events.MouseEvent;
	import gameCommon.screens.BaseScreen;
	
	/**
	 * ...
	 * @author vipul
	 */
	public class BallScreen extends BaseScreen
	{
		private const MAX_BALL:int = 90;
		private var _bgs:BingoGameScreen;
		
		public function BallScreen(bingoGameScreen:BingoGameScreen) 
		{
			_bgs = bingoGameScreen;
			screenUI = new Resources.ballScreen();
			addChild(screenUI);
			//stopAllBall();
			addGameEventListener(screenUI.closeB, MouseEvent.CLICK, closeScreen);
		}
		override public function initialize():void
		{
			super.initialize();
			
		}
		public function showball(baalNo:String):void
		{
			
			var str:String = "ball" + baalNo;
			//trace("ball passed symbol trace",str);
		//	screenUI[str].cover.visible = false;
			
		}
		
		private function closeScreen(evt:MouseEvent):void
		{
			_bgs.removeBallScreen();
			
		}
		private function stopAllBall():void
		{
			for (var i:int = 1; i <=MAX_BALL; ++i )
			{
				var str:String = "ball" + i;
				//screenUI[str].gotoAndStop(i);
			}
		}
		public function showBall(showBallArray:Array):void
		{
			for (var i:int = 0; i < showBallArray.length;++i )
			{
				var str:String = "ball" + showBallArray[i];
				 screenUI[str].cover.visible = false;
			}
		}
	}

}