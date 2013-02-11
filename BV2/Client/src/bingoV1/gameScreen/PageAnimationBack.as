package bingoV1.gameScreen 
{
	import gameCommon.screens.BaseScreen;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import gameCommon.screens.BaseScreen;
	import flash.utils.Timer ;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author dwijendra
	 */
	public class PageAnimationBack extends BaseScreen
	{
		
		
	   private var _back:Sprite;
		private var delay:uint = 1;
         private var repeat:uint=9;
         public var myTimer:Timer = new Timer(delay, repeat);
		 private var page_spine:Number;
		 private var page_edge:Number;
		 private  var line:Sprite;
		 private var _mask:Sprite;
		  private var _mask1:Sprite;
		 private var _bookContainer:Sprite;
		 private var page1:*;
  	     private var page2:*;
		 private var _currentAngle:Number = 0.0;
		  private var end:Function;
		public function PageAnimationBack(p1:*,p2:*,en:Function=null) 
		{
			 end = en;
			page1 = p1;
			page2 = p2;
			line = new Resources.Line();
			line.visible = false;
			//_mask = new Sprite();
		   _mask  = new Resources.maskBack();
		 
		    _mask1 = new Resources.BookContainer();
		   _bookContainer = new Resources.rectangleMask1();
		   addChild(line);
			addChild(_mask);
			addChild(_mask1);
			addChild(_bookContainer);
		  
		    page_spine = BingoBook._cardWidth+12;
		    page_edge = BingoBook._cardWidth * 2;
			_mask["back"].addChild(page2);
		   	myTimer.start(); 
		    addChild(page1);
			//trace("_mask[back].height",_mask.height," BingoBook._cardheight", BingoBook._cardHeight);
			page2.y=-BingoBook._cardHeight;
			
			
			_bookContainer.x = 0;
			_bookContainer.y = BingoBook._cardHeight;
			_mask.mask = _bookContainer;
			_bookContainer.rotation = -90 * (page_spine-line.x) / BingoBook._cardWidth;
			
			//addChild(page1);
			//_mask.addChild(page2);
			
			//page2.height = _mask.height;
			//page2.width = _mask.width;
			_bookContainer.cacheAsBitmap = true;
            _mask.cacheAsBitmap = true;
		     _bookContainer.filters = [new DropShadowFilter(4, 45,55, .8,15,15, 2)];
		     _mask.filters = [new DropShadowFilter(4, 45,55, .8,15,15, 2)];
			 //new DropShadowFilter(
			page1.mask = _mask1;
			
			setCoOrdinate(_mask);
			setCoOrdinate(_mask1);
			setCoOrdinate(line);
			//_mask.y = _mask.y -28;
			 myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
       	     myTimer.addEventListener(TimerEvent.TIMER_COMPLETE,done);
		}
		public function setheightwidth(sp:*):void
		{
			sp.width = BingoBook._cardWidth;
			sp.height=BingoBook._cardHeight;
		}
		public function done(evt:TimerEvent):void
		{ 
			//removeChild(line);
			//removeChild(_mask);
			//removeChild(_mask1);
			//removeChild(_bookContainer);
			_bookContainer.filters = [];
		     _mask.filters = [];
			page1.x = 0.0;
			page1.y = 0.0;
			page2.x = 0.0;
			page2.y =0.0;
			_bookContainer.rotation = 45;
			end();
		}
		public function setCoOrdinate(sp:Sprite):void
		{
			
		   sp.y=BingoBook._cardHeight;
		}
		public function timerHandler(evt:TimerEvent):void
		{
			
			//trace("timer is called+++++++++++++++++++++++++++");
			line.x +=30;
			
			if (line.x>page_spine)
			{
				line.x = page_spine;
			}
			if (line.x<0.0)
			{
				line.x=page_spine
			}
			_bookContainer.x = line.x;
			_mask.x = line.x;
			_mask1.x = line.x;
			
			_mask["back"].x =-(page_spine-line.x);
			
			line.rotation =-45* (page_spine-line.x) / BingoBook._cardWidth;
			_mask.rotation = -90 * (page_spine-line.x) / BingoBook._cardWidth;
			_mask1.rotation = -45* (page_spine-line.x) / BingoBook._cardWidth;
			_bookContainer.rotation = -45 * (page_spine-line.x) / BingoBook._cardWidth;
			
		}
		
	
	}

}