package bingoV1.lobbyScreen 
{
	import flash.display.Sprite;
	import gameCommon.customUI.ScrollPaneHorizontal;
	import gameCommon.screens.BaseScreen;
	import flash.display.Graphics;
	import flash.events.MouseEvent
	/**
	 * ...
	 * @author Siddhant
	 */
	public class RoomListForFutureGame extends BaseScreen
	{
		
		private var _roomListArray:Object;
		private static const _maxRooms:int = 25;
		private var _roomHolder:Sprite;
		private var _roomMask:Sprite;
		private var _slidervalue:Number = 0.0;
		private var _scroller:ScrollPaneHorizontal;
	
		
		public function RoomListForFutureGame(fun:Function) 
		{
			
			screenUI = new Resources.futureGameListScreen();
			screenUI.closeB.addEventListener(MouseEvent.CLICK,fun);
			addChild(screenUI);
			_roomHolder = new Sprite();
			_roomHolder.x = screenUI .startP.x;
			_roomHolder.y = screenUI .startP.y;
			var ht:Number=screenUI.endP.y-screenUI .startP.y
			var wt:Number=screenUI.endP.x-screenUI .startP.x
			_scroller = new ScrollPaneHorizontal(wt,ht,_roomHolder,screenUI.slider);
		    addChild(_scroller);
		}
		
		
		public function createRooms(respose:String):void
		{
			if (respose == "")
			return;
			_roomListArray = new Object();
			var resArr:Array = respose.split("#");
			for (var j:int = 0; j < resArr.length; j++ )
			{
				//trace("hi" + resArr[j]);
				if (resArr[j] == "")
				continue;
				var nextSplit:Array = resArr[j].split("*");
				for (var k:int = 1; k < nextSplit.length; k++ )
				{
					var rm:RoomSym = new RoomSym(nextSplit[0]);
					 rm.filltext(nextSplit[k]);
					_roomListArray[String(rm._gameID)]=rm;
				}
			}
			showRooms();
		}
		
		
	
		public function showRooms():void
		{
			
				
			//_roomHolder = new Sprite();
			var currentX:Number = 0.0;
			for (var i:String in _roomListArray)
			{
				if (_roomListArray[i])
				{
					_roomHolder.addChild(_roomListArray[i]);
					_roomListArray[i].x = currentX;
					//trace("currenty  ", currentY);
					currentX += _roomListArray[i].width+2;
				}
			}
			//_scroller.ui
			_scroller.setInitialScroll();
			
			//addChild(_roomHolder);
			
			
		}
		public function updatePurchsedBooks(resp:String):void
		{
			var arr:Array = resp.split(",");
			if (_roomListArray[arr[0]])
			    _roomListArray[arr[0]].updateRoom(arr[1]);
		}
	
	}

}