package bingoV1.gameScreen 
{
	import flash.events.MouseEvent;
	import gameCommon.screens.BaseScreen;
	import multiLanguage.ResizeableContainer;
	import multiLanguage.LanguageXMLLoader;
	import flash.events.MouseEvent;
	import gameCommon.smartFoxAPI.SfsMain;
	/**
	 * ...
	 * @author Siddhant
	 */
	public class KassaScreen extends BaseScreen
	{	
		public var _cashScreen:Function;
		
		public function KassaScreen(cscreen:Function) 
		{
			_cashScreen = cscreen;
			//screenUI = new Resources.kassaScreen();
			  screenUI = GetDisplayObject.getSymbol("kassaScreen");
			addChild(screenUI);
			//ResizeableContainer.setTextToUI(screenUI, LanguageXMLLoader._loadedXML.KaasaScreen);
			addGameEventListener(screenUI.logoutB, MouseEvent.CLICK, function (evt:MouseEvent):void { SfsMain.sfsclient.logout(); } );
			addGameEventListener(screenUI.closeB, MouseEvent.CLICK, function (evt:MouseEvent):void { removeScreen(); } );
			addGameEventListener(screenUI.jugar_B, MouseEvent.CLICK, function (evt:MouseEvent):void { trace("cash screen clicked++++"); _cashScreen(); } );
			
		}	
		
	}

}