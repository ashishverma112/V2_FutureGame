package bingoV1.gameScreen 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import gameCommon.screens.BaseScreen;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author vipul
	 */
	public class RunningText extends BaseScreen
	{
		private var _announceMask:Sprite;
		private var _movingText:String;
		private var _screen:*	
		private var strWidth:Number;
		public var _height:Number;
		public function RunningText(movingText:String) 
		{
			//trace("moving text is called");
			if (screenUI)
			{
				removeChild(screenUI);
				screenUI = null;
			}
			_height = 22.4;
		//	_screen = screen;
			screenUI = new Resources.announceSymbol();
			addChild(screenUI);
			
			screenUI.txt.autoSize = TextFieldAutoSize.CENTER;
			screenUI.txt.multiline = false;
			_movingText = movingText;
			strWidth = Number(screenUI.announcestrip.width);
			screenUI.txt.text = _movingText;
			screenUI.txt.x = screenUI.announcestrip.x+screenUI.announcestrip.width;
			
			//screenUI.txt.width = movingText.length * 2;
			screenUI.txt.mask =screenUI.announcestrip;
			//screenUI.txt.y = _screen.endtextP.y;
			addGameEventListener(screenUI, Event.ENTER_FRAME, moveText);
		}
		
	
		
		private function moveText(evt:Event):void
		{
			if ( (screenUI.txt.x + screenUI.txt.width)<=screenUI.announcestrip.x &&screenUI)
			{
				screenUI.txt.x = screenUI.announcestrip.x+strWidth;
				//screenUI = null;
				//screenUI = new Resources.movingText();
					//screenUI.txt.text = _movingText;

			   // addChild(screenUI);
			}
			else
			{
				screenUI.txt.x -= 2;
			}
		}
		public function resizeScreen(hsf:Number,vsf:Number):void
		{
			//trace("hi al")
			screenUI.scaleX = hsf;
			screenUI.scaleY = vsf;
			_height = height * vsf;
			
		}
		public function cardHandler(_cardCon:CardContainer2):void
		{
			/*if (_cardCon)
			{
				if (_cardCon.noOfRoomCard > 3)
				{
					
					//screenUI.nextB.enabled = true;
					//screenUI.backB.enabled = true;
				//	addGameEventListener(screenUI.nextB, MouseEvent.CLICK, _cardCon.showNextScreen);
			       // addGameEventListener(screenUI.backB, MouseEvent.CLICK, _cardCon.showPreviousScreen);
				}
				else
				      screenUI.nextB.enabled = false;
					  screenUI.backB.enabled = false;
			}8*/

		}
	}

}