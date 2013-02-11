package bingoV1.gameScreen 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import gameCommon.screens.BaseScreen;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import bingoV1.lobbyScreen.MainLobbyScreen;
	import flash.display.Sprite;
	import gameCommon.customUI.ScrollPane;
	import gameCommon.lib.SoundPlayer;
	/**
	 * ...
	 * @author ashish
	 */
	public class AllWinnerScreen extends BaseScreen
	{
		private var _winnerName:Array;
		private var _winHolder:Sprite;
		private var currentY:Number;
		private var _id:Array;
		private var pt:Point;
		private var lineArray:Array;
		private var noOfFlineWinner:int = 0;
		private var noOfSlineWinner:int = 0;
		private var noOfVlineWinner:int = 0;
		private var no:Array;
		private var  _timeIntervalID:uint;
		private var _round:int;
		private var _funClose:Function;
		private var wholeWinnerArray:Array;
		private var sp:ScrollPane;
		public function AllWinnerScreen(winner:Array,id:Array,round:int,fun:Function) 
		{
			_winnerName = winner;
			_round = round;
			_id = id;
			_funClose = fun;
		     no = new Array();
			for (var i:int=0; i < _id.length; i++ )
			{
				if (id[i] == "1")
				{
				noOfFlineWinner++;
				}
				if (id[i] == "2")
				{
				 noOfSlineWinner++;
				}
				if (id[i] == "V")
				{
				noOfVlineWinner++;
				}
				
			}
			no["1"] = noOfFlineWinner;
			no["2"] = noOfSlineWinner;
			no["V"] = noOfVlineWinner;
		
			lineArray = new Array();
			lineArray["1"] = "Eerst lijn";
			lineArray["2"] = "Tweede lijn";
			lineArray["V"] = "Volle kaart";
			screenUI = GetDisplayObject.getSymbol("WinnerMsg");
			//screenUI = new Resources.WinnerMsg_Duch();
			//screenUI.x = stage.stageHeight - screenUI.height;
			//screenUI.y = stage.stageWidth - screenUI.width;
			addChild(screenUI);
		    screenUI.popupcolor.gotoAndStop(MainLobbyScreen._bgcolor);
			screenUI.roundno.text = _round;
			pt = new Point(screenUI.startP.x, screenUI.startP.y);
			addGameEventListener(screenUI.closeB, MouseEvent.CLICK, closeScreen);
			_timeIntervalID = setTimeout(closeScreen, 7000, null);
			
			setAllWinner();
		}
		private function setAllWinner():void
		{
			wholeWinnerArray = new Array();
			for (var i:int=0; i < _winnerName.length; i++ )
			{
				
				var winner:*= new Resources.winnerInfo();
				winner.winAmt.text = "€ " +setAmount(Number( BingoGameScreen.amtArr[_id[i]] / no[_id[i]]).toFixed(2));
			//	trace(BingoGameScreen.amtArr[_id[i]] , no[_id[i]]);
				winner.id.text = _id[i];
				winner.winnername.text = _winnerName[i];
				winner.lineName.text = lineArray[_id[i]];
				wholeWinnerArray.push(winner);
				//winner.x = pt.x;
			//winner.y = pt.y;
				//screenUI.addChild(winner)
			//	pt.y += winner.height;
			//	trace(winner.height);
				
			}
			makeWinnerList();
		}
		private function setAmount(_amt:String):String
		{
			var str:String = "";
			str = _amt;
			var arr:Array = str.split(".");
			if (int(arr[1]) == 0)
			 arr[1] = "-";
			str = arr[0] + "," + arr[1];
			return str;
		}
		private function closeScreen(e:MouseEvent):void
		{
			//trace("kya aaya al winn"+e)
			if (e != null)
			 SoundPlayer.playSound("buttonClick");
			_funClose();
			if (screenUI)
			{
			removeGameEventListener(screenUI.sluitB, MouseEvent.CLICK, closeScreen);	
		    removeChild(screenUI);
			screenUI = null;
			}
			
			clearTimeout(_timeIntervalID);
		}
		private function makeWinnerList():void
		{
			
			_winHolder = new Sprite();
			_winHolder.x = screenUI.winP.x;
			_winHolder.y = screenUI.winP.y;
			 currentY = 0;
			 var _userHeight:Number = 22;
			 for (var us:int = 0; us< wholeWinnerArray.length; us++ )
			 {
			   
				  _winHolder.addChild(wholeWinnerArray[us]);
				  wholeWinnerArray[us].y = currentY;
				 
				   currentY += _userHeight;
		
			 }
			  //var crd:BitmapData= new BitmapData(_winHolder.width,_winHolder.height, true, 0x0);
                    //  crd.draw(_winHolder);
                   // var crd1:Bitmap = new Bitmap(crd);  
			// _winHolder.cacheAsBitmap = true;
			 sp= new ScrollPane(342, 120, _winHolder, screenUI.slider);
			 // sp= new ScrollPane(342, 120,crd1, screenUI.slider);
			 screenUI.addChild(sp);
			 //sp.changeUI(_winHolder);
			 //sp.setFullScrollUserList();
			 sp.setFullScroll();
			//stage.invalidate();
			
		}
		
	}

}