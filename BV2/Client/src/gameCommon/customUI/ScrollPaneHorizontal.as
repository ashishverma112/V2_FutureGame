package gameCommon.customUI 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import gameCommon.screens.BaseScreen;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Siddhant
	 */
	public class ScrollPaneHorizontal extends BaseScreen
	{
		private var _ui:*;
		private var _slider:*;
		private var _visibleHeight:Number;
		private var _visibleWidth:Number;
		private var _Height:Number;
		private var _Width:Number;
		//private var _width:Number;
		private var _intX:Number;
		private var _initUIX:Number;
		private var _scrollMask:Sprite;
		private var _windowX:Number;
		private var _windowY:Number;
		
		public function ScrollPaneHorizontal(visibleWidth:Number,visibleHeight:Number,ui:*,slider:*,windowx:Number = 0,windowy:Number = 0) 
		{
			//_width = width;
			//trace("trace kiya re",slider);
			_visibleHeight = visibleHeight;
			_visibleWidth = visibleWidth;
			_Height = visibleHeight;
			_Width = visibleWidth;
			_windowX = windowx;
			_windowY = windowy;
			
			_ui = ui;
			_slider = slider;
			_slider.slider.buttonMode = true;			
			_slider.addEventListener(MouseEvent.MOUSE_DOWN, mousePressed);
			setMask();
			addChild(ui);
			this.x = ui.x;
			this.y = ui.y;
			ui.x = 0;
			ui.y = 0;
			ui.mask = _scrollMask;
			_initUIX = ui.x;
			_slider.slider.x = _slider.startP.x;
			//shiftUI();
			if (_ui.width <= _visibleWidth)
			{
				_slider.slider.visible = false;
				return;
			}
		}
		
		public function setScrollInBetween():void
		{
			_slider.slider.x = (_slider.endP.x -  _slider.startP.x)/2;
			shiftUI();
		}
		public function setResize(hsf:Number,vsf:Number):void
		{
			_visibleHeight=_Height*vsf;
			_visibleWidth = _Width * hsf;
			//_visibleHeight=_visibleHeight*vsf;
			//_visibleWidth = _visibleHeight * hsf;
			setMask();
			_ui.mask = _scrollMask;
			setFullScroll();
			
		}
		
		/*override public function initialize():void
		{
			
		}*/
		
		private function mousePressed(e:MouseEvent):void 
		{
			_slider.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			_slider.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUP);			
			_intX = e.stageX;
		}
		
		private function mouseUP(e:MouseEvent):void 
		{
			_slider.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			_slider.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUP);			
		}
		
		private function mouseMoved(e:MouseEvent):void 
		{
			if (_ui.width <= _visibleWidth)
				return;
			var currentX:Number = e.stageX;
			var diff:Number = currentX - _intX;
			
			//var sliderPos:Point = new Point(_slider.slider.x, _slider.slider.y);
			//var globalSliderX:Number = _slider.localToGlobal(sliderPos).x;
			//sliderPos.x += diff;
			
			//var newSliderX:Number = _slider.globalToLocal(sliderPos).x;
			
			//trace (newSliderX, sliderPos, diff);
			//trace (_sli , " asdasdfasdf ");
			
			_slider.slider.x += diff;
			//trace("difference is shown+++++++++++++",diff,_slider.slider.y);
			_intX = currentX;
			
			
			if (_slider.slider.x >= _slider.endP.x - _slider.slider.width)
					_slider.slider.x = _slider.endP.x - _slider.slider.width;
					
			if (_slider.slider.x <= _slider.startP.x)
			{
					_slider.slider.x = _slider.startP.x;
					_ui.x = _initUIX;
			}
			shiftUI();


			//trace (" Ui height ", _ui.height," Total uis ", totalUIShift, " total slider M ", totalSliderMovement, " UI Pos ", _ui.y);
		}	
		
		private function shiftUI():void
		{
			if (_ui.width <= _visibleWidth)
			{
				_slider.slider.visible = false;
				return;
			}
			_slider.slider.visible = true;
			var totalSliderMovement:Number = _slider.endP.x -  _slider.startP.x - _slider.slider.width;
			//var totalSliderMovement:Number = _slider.endP.x -  _slider.startP.x;
			//var totalSliderMovement:Number = _slider.endP.y -  _slider.startP.y ;
			var totalUIShift:Number = _ui.width - _visibleWidth;
			
			var uiToBeShifted:Number = (totalUIShift / totalSliderMovement) * (_slider.slider.x - _slider.startP.x);			
			//trace (" UI to be shifted and total UI shift ",uiToBeShifted , totalUIShift);
			_ui.x = _initUIX - uiToBeShifted;		
			_ui.mask = _scrollMask;
		}
		
		private function setMask():void
		{
			_scrollMask = new Sprite();
            addChild(_scrollMask);
			//_scrollMask.y = 10;
           _scrollMask.graphics.lineStyle(3,0x00ff00);
           _scrollMask.graphics.beginFill(0x0000FF);
           _scrollMask.graphics.drawRect(_windowX ,_windowY,_visibleWidth,_visibleHeight + 20);
			_scrollMask.visible = false;
		}
		
		public function setFullScroll():void
		{
			_slider.slider.x = _slider.endP.x -  _slider.slider.width;
			shiftUI();			
		}
		public function setInitialScroll():void
		{
			//_slider.slider.y = _slider.endP.y -  _slider.slider.height;
			_slider.slider.x = _slider.startP.x;
			shiftUI();			
		}
	}
}