package bingoV1.gameScreen 
{
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
	public class PageAnimation extends BaseScreen
	{
		private var _back:Sprite;
		private var delay:uint = 1;
         private var repeat:uint =9;
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
		public function PageAnimation(p1:*,p2:*=null,en:Function=null) 
		{
			 end = en;
			if (p2==null)
			{
				//trace("p2 is null now++++++++++++++++++++++++");
				p2 = new Sprite();
				p2.height = BingoBook._cardHeight;
			    p2.width=BingoBook._cardWidth;
			}
			page1 =p1;
			page2 = p2;
			line = new Resources.Line();
			line.visible = false;
			//_mask = new Sprite();
		   _mask  = new Resources.rectangleMask1();
		   //_back.name = "_back";
		  // _mask.addChild(_back);
		    _mask1 = new Resources.rectangleMask1();
			_mask1.height = _mask1.height + 40;
		   _bookContainer = new Resources.BookContainer();
		 //  setheightwidth(_mask);
		   // setheightwidth(_mask1);
			// setheightwidth(_bookContainer);
		    page_spine = BingoBook._cardWidth;
		    page_edge = BingoBook._cardWidth * 2;
	     	myTimer.start(); 
						
			addChild(page2);
			//setCoOrdinate(page2)
			
			page2.x = BingoBook._cardWidth+11;
			
			addChild(line);
			addChild(_mask);
			addChild(_mask1);
			addChild(_bookContainer);
			//_bookContainer.addChild(page1);
			_mask["back"].addChild(page1);
			//page1.x = -_mask.width;
			//page1.y = -_mask.height;
			//page1.x = -280;
			page1.y =-590;
			page1.height =_mask.height;
			page1.width=_mask.width;
		    _mask.mask = _bookContainer;
			_bookContainer.rotation = 90 * (line.x - page_spine) / BingoBook._cardWidth;
			_bookContainer.cacheAsBitmap = true;
            _mask.cacheAsBitmap = true;
		    _bookContainer.filters = [new DropShadowFilter(4, 45,55, .8,15, 15, 2)];
		    _mask.filters = [new DropShadowFilter(4, 45,55, .8,15,15, 2)];
			 page2.mask = _mask1;
			_bookContainer.x = BingoBook._cardWidth * 2;
			_bookContainer.y = BingoBook._cardHeight;
			setCoOrdinate(_mask);
		     setCoOrdinate(_mask1);
			setCoOrdinate(line);
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
			
			end();
		}
		public function setCoOrdinate(sp:Sprite):void
		{
			sp.x = BingoBook._cardWidth * 2;
		   sp.y=BingoBook._cardHeight;
		}
		public function timerHandler(evt:TimerEvent):void
		{
			
			//trace("timer is called+++++++++++++++++++++++++++");
			line.x -=30;
			
			if (line.x>page_edge)
			{
				line.x = page_edge;
			}
			if (line.x<page_spine)
			{
				line.x = page_spine;
			}
			_bookContainer.x = line.x;
			_mask.x = line.x;
			_mask1.x = line.x;
			_mask["back"].x = -(page_edge-line.x);
			line.rotation =45* (line.x - page_spine) / BingoBook._cardWidth;
			_mask.rotation = 90 * (line.x - page_spine) / BingoBook._cardWidth;
			_mask1.rotation = 45* (line.x - page_spine) / BingoBook._cardWidth;
			_bookContainer.rotation = 45 * (line.x - page_spine) / BingoBook._cardWidth;
			_currentAngle= 90 * (line.x - page_spine) / BingoBook._cardWidth;
			
			
		}
		
		
	}

}