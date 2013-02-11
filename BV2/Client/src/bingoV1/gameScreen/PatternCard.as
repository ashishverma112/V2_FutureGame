package bingoV1.gameScreen 
{
	import gameCommon.screens.BaseScreen;
	import multiLanguage.LanguageXMLLoader;
	import multiLanguage.ResizeableContainer;
	/**
	 * ...
	 * @author Siddhant
	 */
	public class PatternCard extends BaseScreen
	{
		
		public function PatternCard() 
		{
			screenUI = GetDisplayObject.getSymbol("patScreen");
			//addChild(screenUI);
			screenUI.gotoAndStop(1);
			//ResizeableContainer.setTextToUI(screenUI, LanguageXMLLoader._loadedXML.PatternScreen);
			
			//screenUI.visible = false;
			//screenUI.patternOver_res.text = "";
			for (var i:int = 0; i < 24;++i )
			{				
				var str:String = "balloon" + i;
				screenUI[str].visible = false;							
			}			
		}
		public function patternWin():void
		{
			screenUI.gotoAndStop(2);
			
		}
		
		
		public function setPattern(pattern:String):void
		{
			var patArray:Array = pattern.split(",");
			
			for (var j:int; j < patArray.length;++j )
			{
				var balStr:String = "balloon" + patArray[j];
			//	screenUI[balStr].visible = true;-----------------
			}
				//var str:String = "balloon" + 12;
			//	screenUI[str].visible = true;
		}
		
		public function showPatternOver():void
		{
			for (var i:int = 0; i < 24;++i )
			{
				var str:String = "balloon" + i;
				screenUI[str].visible = false;
			}
			screenUI.visible = true;
		}
		
	}

}