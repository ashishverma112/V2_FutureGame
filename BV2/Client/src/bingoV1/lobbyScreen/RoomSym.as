package bingoV1.lobbyScreen 
{
	import bingoV1.gameScreen.BingoWinnerScreen;
	import flash.events.MouseEvent;
	import gameCommon.screens.BaseScreen;
	import multiLanguage.LanguageXMLLoader;
	import multiLanguage.ResizeableContainer;
	import gameCommon.smartFoxAPI.SfsMain;
	
	/**
	 * ...
	 * @author vipul
	 */
	public class RoomSym extends BaseScreen
	{
		private var _roomID:int;
		public var _gameID:int;
		private var _noOfCards:int=0;
		public static const _symbolHeight:Number = 70;
		
		public function RoomSym(roomID:int) 
		{
			_roomID = roomID;
		    screenUI = new Resources.cardspurchaseRoom();
			addChild(screenUI);
			for (var i:int = 1; i <= 6;i++ )
			{
				screenUI["buycard_" + i].addEventListener(MouseEvent.CLICK, buyCards);
			
			}
		}
	
		private function buyCards(evt:MouseEvent):void
		{
			 var objNme:String = evt.currentTarget.name;
			 var count:int = int(objNme.substring(8));
			//trace("++++++++++++++++++join room is called(((((((((((((((((((((((((((((((((((((((((((((((((((",count);
		    
		     if (count - _noOfCards > 0)
			 {
			 var sendParam:Array=[4,_gameID,count];
			 SfsMain.sfsclient.sendXtMessage("LobbyExt", "4", sendParam, "str");
			 }
		}
		
		
		
		public function filltext(roomInfo:String):void
		{
			var arr:Array = roomInfo.split(",");
			//trace("roomInfo"+roomInfo)
			_gameID = arr[0];
			
			screenUI.roomname.text = arr[1];// "Gesloten";
			// "Gesloten";
			screenUI.maxround.text =arr[2];
			screenUI.startdate.text = arr[3];
			screenUI.currentround.text = 0;
			screenUI.book1p.text =setAmount(arr[4]);
			screenUI.book2p.text = setAmount(arr[5]);
			screenUI.book3p.text = setAmount(arr[6]);
			screenUI.book4p.text = setAmount(arr[7]);
			screenUI.book5p.text = setAmount(arr[8]);
			screenUI.book6p.text = setAmount(arr[9]);
			screenUI.p1r.text = setRoundPrize(arr[10]);
			screenUI.p2r.text =setRoundPrize(arr[11]);
			screenUI.p3r.text = setRoundPrize(arr[12]);
			_noOfCards =int(arr[13]);
			screenUI.numtxt.text = _noOfCards;
		}
		
	private function setRoundPrize(str:String):String
		{
			//trace(str);
			//str="5;5;5;5;6;6;6;8"

			var arr:Array = str.split(";");
			var count:int = 0;
			var amt:Number = arr[0];
			var culstr:String = "";
			arr[arr.length] = -1;
			for (var j:int = 0; j < arr.length; j++ )
			{
				if (amt == Number(arr[j]))
				 count++;
				 else
				 {
				  culstr += count.toString() + "x " + setAmount(amt) + "  " ;
				  amt = Number(arr[j])
				  count = 1;
				 }
				
			}
			//trace("hial ",culstr)
			return culstr;
		}
		private function setAmount(amt:Number):String
		{
			var str:String = "";
			str = amt.toFixed(2);
			var arr:Array = str.split(".");
			if (int(arr[1]) == 0)
			 arr[1] = "-";
			str ="€"+ arr[0] + "," + arr[1];
			return str;
		}
		public function updateRoom(cnt:int):void
		{
			_noOfCards =cnt;
			screenUI.numtxt.text = _noOfCards;
		}
	}

}