package bingoV1.gameScreen 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.Point;
	import gameCommon.screens.BaseScreen;
	import bingoV1.GameConstants;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import gameCommon.lib.SoundPlayer;
	import bingoV1.gameScreen.MovingBall;
	import gameCommon.lib.BitmapUtility;
	import flash.geom.Rectangle;
	import flash.events.FocusEvent;
	import flash.utils.setTimeout;
	import flash.utils.clearInterval;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class NumberGenerationScreen extends BaseScreen
	{
		private var _showNumberArray:Array;
		private var _moveBallArray:Array;
		private var _stoppedBallArray:Array;
		private var _showAnm:Boolean;
		private var _maxStopBall:int = 5;
		private var _lastPosX:Number = 0.0;
		private var _ballNumber:int;
		
		private var _currentNum:int;
		static public const  _ballDiameter:Number = 60.0;
		static private var _ballSpeed:Number = 10.1;
		static private const _rotationSpeed:Number = -20.0;// original cvommented for test
		
		
		//private var _glass:*;
		
		private var _ballGenerationPos:Point;
		private var _numBallsStopped:int;
		private var _bingoGameScreen:BingoGameScreen;
		
		
		private var _bmpData:BitmapData;
		private var _bmp:Bitmap;
		private var _lastTime:int;
		private var soundId:uint;

	
		public function NumberGenerationScreen(bgs:BingoGameScreen) 
		{
			_moveBallArray = new Array();
			_stoppedBallArray = new Array();
			_showNumberArray = new Array();
			
			//screenUI = ui;
			_bingoGameScreen = bgs;
			var ui:* =  new Resources.ballGenerator();
			
			_ballGenerationPos = new Point();
			_ballGenerationPos.x = ui.ballPos.x-160;
			_ballGenerationPos.y = ui.ballPos.y;
			screenUI = ui.numGenerator;
		  //	addChild(ui);
			//screenUI.visible = false;

		//	addChild(screenUI);
			screenUI.gotoAndStop(1);
			_showAnm = false;
			//_glass = new Resources.ballGeneratorGlass();
			
			_numBallsStopped = 0;
			
			//addChild(_glass);
			
			
			
			//initialize();
		}
		
		public function setBallSpeedAsPerGenerationSpeed(ballGenSpeed:int):void
		{
			//speed will be in pixels per milliseconds
			var totalDistance:Number = this.x;
			
			var totalTime:Number = ballGenSpeed * 600;
			_ballSpeed = totalDistance / totalTime;
		//	trace (this.y, ballGenSpeed, totalDistance / totalTime, " here they are");
		//	trace (_ballSpeed , " this is the ball speed set");			
		}
		
		override public function initialize():void
		{
			//setTimer();
			super.initialize();
			
			
			_lastTime = -1;
			addGameEventListener(stage, Event.ENTER_FRAME, doEveryFrame);
			
			screenUI.y = -this.y;
		}
		
		
		public function setFocus(e:MouseEvent):void
		{
	         // _bingoGameScreen.setFocus(e);
		}
		public function resizeScreen(hsf:Number,vsf:Number):void
		{
			
			screenUI.y = -this.y;
			for (var k:int = 0 ; k < _numBallsStopped; ++k)
			{
				_moveBallArray[k]._stopped = false;
			}
			_numBallsStopped = 0;
		//	if (_bmpData)
		//		_bmpData.dispose();
			//_bmpData = BitmapUtility.createEmptyBitmapData(stage.stageWidth, this.y + MovingBall._ballDiameter);
			//trace (stage.stageWidth, MovingBall._ballDiameter , " adding bitmap");
			//_bmpData = BitmapUtility.createEmptyBitmapData(stage.stageWidth,  MovingBall._ballDiameter + 10);
			//_bmp = new Bitmap(_bmpData);
			//addChild(_bmp);
			//_bmp.x = -stage.stageWidth;
			//_bmp.y = -_bmp.height;
			//_bmp.bitmapData = _bmpData;	
			//addChild(_bmp);
		}
		
		public function removeAllBall():void
		{
			/*for (var i:int = 0; i < _stoppedBallArray.length;++i )
			{
				if (_stoppedBallArray[i])
				{
					var t:*= _stoppedBallArray.splice(i, 1);
					t[0].parent.removeChild(t[0]);
					t[0] = null;
					--i;
				}
			}*/
		}
		private function moveBalls():void
		{
			
			var ts:int;
			if (_lastTime == -1)
			{
				_lastTime = getTimer();
				return;
			}
			else
			{
				ts = getTimer() - _lastTime;
				_lastTime = getTimer();
			}
			var i:int = 0;
			while (i < _moveBallArray.length )
			{
				//trace ( " value of is ", i, " value of _numballs stopped is " , _numBallsStopped);
				if (_moveBallArray[i])
				{
					var ball:MovingBall = _moveBallArray[i];
					//trace ("Moving balls", getTimer());
					if (!ball._stopped)
					{
					//	ball.ballX -= _ballSpeed*ts;	
					     ball.ballX -= 5;	
						//_moveBallArray[i].rotateBall( _rotationSpeed);	
						_moveBallArray[i].rotateBall( );	
					
					
						var lastX:Number =  _lastPosX + _numBallsStopped * _ballDiameter ;
						//trace (_moveBallArray[i].x, lastX , " debug message");
						if (ball.ballX <= lastX)
						{

							if (_numBallsStopped == -1)     //-1 refers balls are now moving after getting hit from nwe one
							{
								ball.removeBall();
								_moveBallArray.splice(i, 1);
								//removeChild();
								//i--;
								_numBallsStopped++;	
								continue;
							}
							ball.ballX = lastX;						
							ball._stopped = true;
							_numBallsStopped++;	
							_bingoGameScreen.markNumberAfterBallStops(ball._ballNumber);
							
						}
						
					}	
				//	drawBall(ball);
					i++;
				}			
			}		
			if (_numBallsStopped > _maxStopBall)
			{
				for (var k:int = 0 ; k < _numBallsStopped; ++k)
				{
					///trace (" Value of k is ", k, " ball is ", _moveBallArray[k] );
					_moveBallArray[k]._stopped = false;
				}
				_numBallsStopped = -1;
			}
			//drawAllBalls();
		}
		
		private function moveStoppedBalls():void
		{
			var i:int = 0;
			if (_stoppedBallArray.length <= _maxStopBall)
				return;
				
			while (i < _stoppedBallArray.length )
			{
				if (_stoppedBallArray[i])
				{
					if (_stoppedBallArray[i].x < - _lastPosX - _ballDiameter / 2)
					{
						removeChild(_stoppedBallArray.shift());
						i--;
					}
					else
					{
						_stoppedBallArray[i].x -= _ballSpeed;
						_stoppedBallArray[i].movable.rotation -= -_rotationSpeed;						
					}
				}
				i++;
			}			
		}
		
		private function doEveryFrame(evt:Event):void
		{

			//stage.focus
			_lastPosX = globalToLocal(new Point(0, 0)).x;
			//trace (" last position in x is ", _lastPosX);
			//trace ("hererere");
			//var timeStart:int = getTimer();
			//screenUI.addChild(screenUI.upper);
			
			if (_showNumberArray.length > 0 && !_showAnm)
			{
				//trace (_showNumberArray.length, " asdfadsf before");
				_currentNum = _showNumberArray.shift();
				//trace (_showNumberArray.length, " asdfadsf after");
				showBallGeneratedAnm();
			}
			moveBalls();
			//drawAllBalls();
			//_bmpData.draw(screenUI);
			//var timeEnd:int = getTimer();
			//trace (" Time taken is " , timeEnd - timeStart);
			//moveStoppedBalls();
		}
		
		private function generateBall(ballNum:int):void
		{
					
			var ball:MovingBall = new MovingBall(ballNum);
			addChild(ball);
			ball.moveBallToPosition(_ballGenerationPos.x, _ballGenerationPos.y - _ballDiameter);
			_moveBallArray.push(ball);
		}
		
		private function showBallGeneratedAnm():void
		{
			/*//ballSoundPlay();
			
			//showAnm(null);
			screenUI.gotoAndPlay(1);
			addGameEventListener(screenUI,Event.ENTER_FRAME, showAnm);
			_showAnm = true;*/
			soundId = setTimeout(ballSoundPlay, 500);
			screenUI.gotoAndPlay(1);
			addGameEventListener(screenUI,Event.ENTER_FRAME, showAnm);
			_showAnm = true;
			
			
			
		}
		private function ballSoundPlay():void
		{
			clearInterval(soundId);
			var str1:String = "male" +_currentNum;
			var str2:String = "female" + _currentNum;
			if (SoundScreen._femaleSounDClicked)
			{
			       SoundPlayer.playSound(str2);
				   //SoundScreen._currentSound = str2;
			}
			else
			{
			    SoundPlayer.playSound(str1);
				//SoundScreen._currentSound = str1;
			}
			
		}
		
		private function showAnm(evt:Event):void
		{
			
			var object:* = evt.currentTarget;
			if (object.hasOwnProperty("movingBall"))
			{
				if(object.movingBall)
				      object.movingBall.imd.movable.gotoAndStop(_currentNum);
			}
		    if (object.currentFrame == object.totalFrames)
			{
				removeGameEventListener(screenUI,Event.ENTER_FRAME, showAnm);
				object.gotoAndStop(1);
				//object.movable.gotoAndStop(1);
				_showAnm = false;
				generateBall(_currentNum);
			}
		}
		
		public function showNumberBall(ballNumber:int):void
		{

			//trace (_showNumberArray.length, " asdfadsf ");
			/*if (_showNumberArray.length > 0)

			{
				generateBall(_showNumberArray[0]);
				_showNumberArray = new Array();
				screenUI.gotoAndStop(1);
				_showAnm = false;
			}*/
			//if (_showNumberArray.length > 0)
			//{
			//	_bingoGameScreen.markNumberAfterBallStops(_showNumberArray[_showNumberArray.length - 1]);
				
			//}
			//_showNumberArray.push(ballNumber);
			
			
			if (_showNumberArray.length > 0)
			{
				removeGameEventListener(screenUI,Event.ENTER_FRAME, showAnm);
				screenUI.gotoAndStop(1);
				//object.movable.gotoAndStop(1);
				_showAnm = false;
				for (var i:int = 0; i < _showNumberArray.length; ++i)
				{
					generateBall(_showNumberArray[i]);
				}
				
				//_bingoGameScreen.markNumberAfterBallStops(_showNumberArray[_showNumberArray.length - 1]);
			}
			_showNumberArray = new Array();
			_showNumberArray.push(ballNumber);
			
		}
		
		private function setTimer():void
		{
			var timer:Timer = new Timer(1400, 300);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function onTimer(evt:TimerEvent):void
		{			
			var numGenerated:int = Math.random() * 90;
			//trace ("Number generated is ", numGenerated);
			showNumberBall(numGenerated);
		}		
		
		private function drawAllBalls():void
		{
			BitmapUtility.clearBitmapData(_bmpData);
			for (var i:int = 0; i < _moveBallArray.length; ++i)
			{
				var ball:MovingBall = _moveBallArray[i];
				if (ball)
				{
					drawBall(ball);
				}
			}
		}
		private function drawBall(ball:MovingBall):void
		{
			
			var destPoint:Point = new Point(stage.stageWidth + ball.ballX, 0);
			//var destPoint:Point = new Point(0, 0);
			//trace (destPoint);
			_bmp.bitmapData.copyPixels(ball.bitmapData, new Rectangle(0, 0, MovingBall._ballDiameter, MovingBall._ballDiameter), destPoint);
		}
		
	}
}