package bingoV1.gameScreen 
{
	import flash.utils.Timer;
	import gameCommon.screens.BaseScreen;
	import flash.events.*;
	import bingoV1.GameConstants;
	
	/**
	 * ...
	 * @author vipul
	 */
	public class Ball extends BaseScreen
	{
		private var _ballArray:Array;
		private var _lastPosX:Number = 700;
		private var _number:int;
		
		public function Ball(number:int) 
		{
			//_ballArray = new Array();
			_number = number;
			
		}
		override public function initialize():void
		{
			super.initialize();
			setBall();
			//addGameEventListener(stage, Event.ENTER_FRAME, doEveryframe);
		}
		
		private function doEveryframe(evt:Event):void
		{
			if (screenUI)
			{
			
			if (screenUI.x >= _lastPosX&&_ballArray.length<=5)
			{
				//trace(screenUI.x, " xpos");
				screenUI.x += 0;
				screenUI.rotation += 0;
				
			}
			else {
				screenUI.rotation+= 10;
			    screenUI.x += 8;
			}
			if (_ballArray.length > 5&&screenUI.hitTestObject(_ballArray[4]))
			{
				screenUI.x -= 8;
				screenUI.rotation += 0;
				for (var i:int = 0; i < _ballArray.length;++i )
				{
					_ballArray[i].x += GameConstants.BALL_SPEED;
					_ballArray[i].rotation += GameConstants.BALL_ROTATION;
					if (_ballArray[0].x >=700)
					{
						_ballArray[i].x += 0;
					    _ballArray[i].rotation += 0;
						var t:*= _ballArray.splice(0, 1);
						t[0].parent.removeChild(t[0]);
						t[0] = null;
						--i;
					}
				}
			}
			}
		}
		private function setTimer():void
		{
			var timer:Timer = new Timer(4000, 30);
			addGameEventListener(timer, TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function onTimer(evt:TimerEvent):void
		{
			
			screenUI = new Resources.ball();
			addChild(screenUI);
			screenUI.x = 20;
			screenUI.y = 40;
			_ballArray.push(screenUI);
			if(_ballArray.length<=5)
			  _lastPosX -= 80;
		}
		private function setBall():void
		{
			screenUI = new Resources.ball();
			addChild(screenUI);
			//screenUI.goto
			screenUI.x = 40;
			screenUI.y = 40;
			//screenUI.gotoAndSto(_number);
		}
	}

}