package bingoV1.gameScreen 
{
	import adobe.utils.CustomActions;
	import flash.display.GraphicsPathCommand;
	import flash.display.Sprite;
	import gameCommon.screens.BaseScreen;
	import bingoV1.gameScreen.WinnerScreen;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import bingoV1.lobbyScreen.MainLobbyScreen;
	import gameCommon.customUI.ScrollPane;
	import gameCommon.lib.SoundPlayer;
	//import bingoV1.gameScreen.LineWinner;
	
	/**
	 * ...
	 * @author ashish
	 */
	
	/* public class WinnerScreen extends BaseScreen
	{
		private var _winnerName:String;
	
		private var card:BingoCard;
		private var _arr:Array;
		private var _id:String;
		private var  _timeIntervalID:uint;
		private var _cardno:Array;
		private var totatnoOfWinner:int;
		private var lineArray:Array;
		
		
		public function WinnerScreen(cardNumber:String,winnerName:String,arr:String,id:String,no:int) 
		{
			//trace(arr, id);
			_winnerName = winnerName;
			_id = id;
			totatnoOfWinner = no;
			_cardno = cardNumber.split(",");
		
			_arr = arr.split(",");// new Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 12, 13, 14, 16, 15, 17, 0, 19, 20, 21, 22, 23, 0, 25, 26, 27);
		}
	   override public function initialize():void
		{
			super.initialize();
			if (screenUI != null)
			{
			     removeChild(screenUI);
				 screenUI = null;
			}
			screenUI = GetDisplayObject.getSymbol("WinnerCard");
			addChild(screenUI);
			lineArray = new Array();
			lineArray["1"] = "Eerst lijn";
			lineArray["2"] = "Tweede lijn";
			lineArray["V"] = "Volle kaart";
			
			addGameEventListener(screenUI.closeB, MouseEvent.CLICK, closeScreen);
			_timeIntervalID = setTimeout(closeScreen, 5000, null);
			setWinCard(_winnerName);
		}
		public function setWinCard(winN:String):void 
		{
			screenUI.userName.text = winN;
			screenUI.winid.text = _id.toString();
			screenUI.winnerLine.text = lineArray[_id];
			screenUI.winBalane.text ="€ "+ (BingoGameScreen.amtArr[_id]/totatnoOfWinner).toFixed(2)+",-";
	    //  trace(" winer card");
			card = new BingoCard(_arr);
			
			card.x = screenUI.startP.x;
			card.y = screenUI.startP.y;
			
			for (var i:int = 0; i < _cardno.length;++i )
			{
			//	trace("pattern to be marked??????????????????????????", _cardno[i]);
				card.checkNumber(_cardno[i]);
			}
			
			screenUI.addChild(card);
			
		
		}
		private function closeScreen(e:MouseEvent):void
		{
			removeGameEventListener(screenUI.closeB, MouseEvent.CLICK, closeScreen);
			if (screenUI)
			removeChild(screenUI);
			clearTimeout(_timeIntervalID);
		}
		
	}*/
	 
	 
	public class WinnerScreen extends BaseScreen
	{
		private var _winnerName:Array;
	
		private var card:BingoCard;
		private var _arr:Array;
		private var _id:String;
		private var  _timeIntervalID:uint;
		private var _cardno:Array;
		private var totatnoOfWinner:int;
		public  var lineArray:Array;
		private var _winHolder:Sprite;
		//private var currentY:Number;
		private var sp:ScrollPane;
		private var allWinner:Array;
		private var slider:*; 
		private var _cardNumber:String;
		private var _amt:Number;
		private var _allCards:int;
		private var _totalNoWinningCards:int;
		
		private var _mainArray:Array;
		private var _cardStrForLineWinner:Array;
		private var _totalCardSelectedByUser:Array;
	//	private var _totalCardSelectedByUser:Array;
		private var _winAmt:Number;
		private var _noGenratedTillNow:Array;
		private var _noOfcardsWinByUser:Array;
		private var _closeScreen:Function;
		//private var
		public function WinnerScreen(mainArray:Array, id:String,fun:Function)// cardNumber:String, winnerName:Array, arr:Array, id:String, amt:Number, allCards:int, totalNoWinningCards:int) 
		{
			_mainArray = mainArray;
			_closeScreen = fun;
			_winnerName = _mainArray[0].split(",");
			_cardStrForLineWinner = _mainArray[1].split(";");
			_totalCardSelectedByUser = _mainArray[2].split(",");
			_winAmt = _mainArray[4];
			_noGenratedTillNow = _mainArray[5].split(",");
			_noOfcardsWinByUser = _mainArray[3].split(",");
			 _id=id;
		
	                                                               
	
		}
	   override public function initialize():void
		{
			super.initialize();
			screenUI = new Resources.WinnerCardContainer();
			//addChild(screenUI);
			allWinner = new Array();
			lineArray = new Array();
			lineArray["1"] = "Eerst lijn";
			lineArray["2"] = "Tweede lijn";
			lineArray["V"] = "Volle kaart";
			//slider= new  Resources.userSlider();
			//slider.x = screenUI.endP.x;
			//slider.y = screenUI.endP.y+10 ;
			//slider.height = 80;
			//screenUI.addChild(slider);
			
			
			_timeIntervalID = setTimeout(closeScreen, 7000, null);
		
			setwinerSym(_winnerName,_cardStrForLineWinner,_winAmt,_id,_totalCardSelectedByUser,_noOfcardsWinByUser,_noGenratedTillNow);
			
		}
		private function setwinerSym(winnerarr:Array,arrStr:Array,winAmt:Number,idc:String,totalcards:Array,noOfwinneingCards:Array,noColored:Array):void
		{
			for (var i:int = 0; i < winnerarr.length; i++ )
			{
				var winnerInfo:String = winnerarr[i] + "@" + arrStr[i] + "@" + winAmt + "@" + totalcards[i] + "@" + noOfwinneingCards[i]+"@"+noColored+"@"+idc;

				 var _lineWinner:LineWinner = new LineWinner(this,winnerInfo);
				    allWinner.push(_lineWinner);

			}
			//if(screenUI)
			makeWinnerList(allWinner);
		}
		public function addExtraWinner( mainArray1:Array, id1:String):void// crdNbr:String, winrName:Array, arr1:Array, id1:String, amt1:Number):void
		{
			_timeIntervalID = setTimeout(closeScreen, 7000, null);
			//_cardNumber = _cardNumber + "," + crdNbr;
			var _mainArray1:Array = mainArray1;
			_winnerName = _mainArray1[0].split(",");
			_cardStrForLineWinner = _mainArray1[1].split(";");
			_totalCardSelectedByUser = _mainArray1[2].split(",");
			_winAmt = _mainArray1[3];
			_noGenratedTillNow = _mainArray1[4].split(",");
			_noOfcardsWinByUser = _mainArray1[5].split(",");
			 _id=id1;
			
			setwinerSym(_winnerName,_cardStrForLineWinner,_winAmt,_id,_totalCardSelectedByUser,_noOfcardsWinByUser,_noGenratedTillNow);
			
			//setwinerSym(_winnerName,_arr,amt1,id1);
		}
		
		public function setHeadName(nm:String,crd:BingoCard,_totalCards:uint,winningCards:uint):void
		{
			if (screenUI)
			{
			screenUI.userName.text = nm;	
			screenUI.totalCards.text = _totalCards;
			screenUI.winningCards.text = winningCards;
			crd.x = screenUI.startP.x;
			crd.y = screenUI.startP.y;
			crd.width = screenUI.endP.x - screenUI.startP.x;
			crd.height=screenUI.endP.y-screenUI.startP.y;
			screenUI.addChild(crd);
			}
		}
	
		
		private function closeScreen(e:MouseEvent):void
		{
		//	trace("kya aaya "+e)
			//if (e != null)
			// SoundPlayer.playSound("buttonClick");
			_closeScreen();
			/*if (screenUI)
			{
			
			removeGameEventListener(screenUI.closeB, MouseEvent.CLICK, closeScreen);
			removeChild(screenUI);
			screenUI = null;
			
			}*/
			clearTimeout(_timeIntervalID);
		}
		public function makeWinnerList(userArray:Array):void
		{
			//w=304,h=189.2
			
			_winHolder = new Sprite();
			 var currentx:Number = 0.0;
			 var currentY:Number = 0.0;
			 currentY = 0;
			 var _userHeight:Number = 50;
			 var track:int = -1;
			 for (var us:int = 0; us<userArray.length; us++ )
			 {
			       if (track == -1)
				      track = 1;
				  _winHolder.addChild(userArray[us]);
				   userArray[us].y = currentY;
				   userArray[us].x = currentx;
				   //currentY += _userHeight;
				   if (track == 0)
				   {
					   currentx = 0;
					   currentY += 166;
					   track = 1;
				   }
				   else
				   {   currentx = 302;
					   track = 0;
				   }
		
			 }
			
			if (userArray.length > 4)
			{
				addChild(screenUI);
				sp= new ScrollPane(605, 332, _winHolder, screenUI.slider);
			    addChild(sp);
				sp.setFullScroll();
				
			}
			else
			{
				addChild(_winHolder);
			}
			 
			
			//sp.changeUI(_winHolder);
			//sp.setFullScrollUserList();
			//stage.invalidate();
			
		}
		
	}

}