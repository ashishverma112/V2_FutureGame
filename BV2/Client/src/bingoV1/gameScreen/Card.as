package bingoV1.gameScreen 
{
	import gameCommon.screens.BaseScreen;
	
	/**
	 * ...
	 * @author vipul
	 */
	public class Card extends BaseScreen
	{
		public var _noArray:Array;
		private var _onCheckNumber:Function;
		//private var _pattarnArray:Array;
		
		public function Card(noArray:Array) 
		{
		     _noArray = noArray;
			 //_pattarnArray = patternArray;
			 
		}
		override public function initialize():void
		{
			super.initialize();
			screenUI = new Resources.card();
			addChild(screenUI);
			screenUI.bg.gotoAndStop(1);
			setNumberOncards();
			//setPatternOnCard();
			
		}
		private function setNumberOncards():void
		{
			for (var i:int = 0; i < _noArray.length;++i )
			{
				var str:String = "text" + i;
				screenUI[str].txt.text = _noArray[i];
				screenUI[str]["mark"].visible = false;
				
				//screenUI[str]["pattern"].visible=false;
				//screenUI[str].gotoAndStop(1);
			}
		}
		public function checkNumber(number:String):void
		{
			for (var i:int = 0; i < _noArray.length;++i )
			{
				if (_noArray[i] == number)
				{
					var str:String = "text"+i;
					screenUI[str]["mark"].visible=true;
				}
			}
		}
		
		
	}

}