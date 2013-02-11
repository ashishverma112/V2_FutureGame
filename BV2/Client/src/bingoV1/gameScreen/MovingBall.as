package bingoV1.gameScreen 
{
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import gameCommon.screens.BaseScreen;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import gameCommon.lib.BitmapUtility;
	/**
	 * ...
	 * @author Siddhant
	 */
	public class MovingBall extends Bitmap
	{
		static public var _ballDiameter:Number = 60.0;
		//public static var _ball:Bitmap = new Resources.ballClass() as Bitmap;
		private var _ball:Bitmap;
		public var _stopped:Boolean;
		public var _ballNumber:int;
		//public var _tf:TextField;
		
		public var _bmpData:BitmapData;
		public var _bmp:Bitmap;
		public var _currentRotation:int;
		public static const _maxRotationFrame:int = 59;
		
		public function MovingBall(ballNum:int) 
		{
			//var ball:* = new Resources.redBall();
			
			//var ball:Bitmap = new Resources.ballClass() as Bitmap;
			//trace (ball , " ui type is ", ball as Bitmap);
			//ball.width = _ballDiameter;
			//ball.height = _ballDiameter;
			//ball.cacheAsBitmap = true;
			//addChild(ball);
			//mouseEnabled = false;
			//mouseEnabled = false;
			//mouseChildren = false;
			//tabChildren = false;
			//tabEnabled = false;
			
			_ball = BallResources.ballInstancesA[ballNum - 1];
			_bmpData = BitmapUtility.createEmptyBitmapData(_ballDiameter, _ballDiameter);
			//_bmp = new Bitmap(_bmpData);
			//addChild(_bmp);
			bitmapData = _bmpData;
			var copyRectangle:Rectangle = new Rectangle(0, 0, _ballDiameter, _ballDiameter);
			
			//trace (BallResources.bgInstanceA[int(ballNum / 5)] , " asdfasdf");
			//_bmpData.copyPixels(BallResources.bgInstanceA[int((ballNum - 1)/15)].bitmapData, copyRectangle, new Point(0, 0));
			//trace (_ball, ballNum, "test trace");
			_bmpData.copyPixels(_ball.bitmapData, copyRectangle, new Point(0, 0),null,null,true);
						
			//_tf = new TextField();
			//_tf.text = ballNum.toString();
			//_tf.embedFonts = true;
			//addChild(_tf);
			_currentRotation = 0;
			_ballNumber = ballNum;
			
			//ball.x = -_ballDiameter/2;			
			//ball.y = -_ballDiameter/2;			
			//ball.y = ballYPos - _ballDiameter / 2;
			//ball.movable.gotoAndStop(ballNum);			
			//_ball = ball;
			_stopped = false;
			//var timer:Timer = new Timer(30, 9999);
			//timer.addEventListener(TimerEvent.TIMER, rotateBall);
			//timer.start();
		}
		
		public function moveBallToPosition(xpos:Number, ypos:Number):void
		{
			this.x = xpos;
			this.y = ypos;
			//_ball.x = xpos;
			//_ball.y = ypos;
		}
		
		public function set ballX(xpos:Number):void
		{
			this.x = xpos;
			//_ball.x = xpos;
		}
		
		public function get ballX():Number
		{
			return this.x;
		}
		
		public function rotateBall(timer:TimerEvent = null):void
		{
			//_ball.movable.rotation += rotateAdd;			
			//_ball.rotation += rotateAdd;	
			//_tf.rotation += rotateAdd;
			BitmapUtility.clearBitmapData(_bmpData);
			var copyRectangle:Rectangle = new Rectangle(_ballDiameter * _currentRotation, 0, _ballDiameter, _ballDiameter);
			var bgRectangle:Rectangle = new Rectangle(0, 0, _ballDiameter, _ballDiameter);
			//_bmpData.copyPixels(BallResources.bgInstanceA[int((_ballNumber - 1)/15)].bitmapData, bgRectangle, new Point(0, 0));
			_bmpData.copyPixels(_ball.bitmapData, copyRectangle, new Point(0, 0),null,null,true);
			//_bmpData.copyPixels(_ball.bitmapData, copyRectangle, new Point(0, 0));
			++_currentRotation;
			if (_currentRotation == _maxRotationFrame )
				_currentRotation = 0;
		}
		
		public function removeBall():void
		{
			_bmpData.dispose();
			if (parent)
			parent.removeChild(this);
		}		
	}
}