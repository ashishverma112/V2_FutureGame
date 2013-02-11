package bingoV1.lobbyScreen 
{
	import bingoV1.gameScreen.SearchScreen;
	import gameCommon.screens.BaseNetworkScreen;
	import it.gotoandplay.smartfoxserver.data.Room;
	import multiLanguage.ResizeableContainer;
	import multiLanguage.LanguageXMLLoader;
	import flash.events.*;
	import it.gotoandplay.smartfoxserver.SFSEvent;
	import gameCommon.smartFoxAPI.SfsMain;
	import it.gotoandplay.smartfoxserver.data.Room;
	import it.gotoandplay.smartfoxserver.data.User;
	
	import gameCommon.customUI.ScrollPane;
	import bingoV1.loginScreen.LobbyButtonHandeler;
	import flash.display.StageDisplayState;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	import bingoV1.gameScreen.CashRequest;
	 import flash.net.navigateToURL;
	 import flash.net.URLRequest;
	 import bingoV1.gameScreen.BingoGameScreen;
	 import gameCommon.lib.SoundPlayer;
	/**
	 * ...
	 * @author Siddhant
	 */
	public class MainLobbyScreen extends BaseNetworkScreen
	{
		
		public var _gameAmount:String;
		private var _lastClicked:*;
		public var _joinedRoom:Room;
		private var _roomInfoArray:Array;
		private var _roomNameArray:Array;
		private var _roomList:Array;
		private var _futureGames:RoomListForFutureGame;
		private var _addRooms:Boolean;
		public static var GOLDEN_ROOM:String="";
		private var _lobbyMainWidth:Number;
		private var _lobbyMainHeight:Number;
		private var _array:Array =new Array();
		private var  _filterSymb:Array = new Array();
		private var _lobbyRoomJoined:Boolean;
		public  static var _UserType:int;
		public static var _bgcolor:int = 2;
		public static var _markcolor:int = 1;
		public var _lbHandler:LobbyButtonHandeler;
		private var _selfUser:User;
		public var roomStatusArray:Array = [3, 3, 3, 3, 3, 3];
		public var joinedRoom:Room ;
		private var searchArray:Array;
		private var searchName:String = null;
		private var _searchScr:SearchScreen;
		public static var roundNo:int = 1;
		public static var NoOfCard:Array = new Array(7);
		//private var _lobbyRoomJoined:Boolean;
		public var rect:Sprite;
		public var _cashRequestScreen:CashRequest;
		private var _kassaFlag:Boolean = false;
		private var maximunNoOfrounds:Array=new Array(7);
		
		
		//public static var NoOfCard:String;
		public function MainLobbyScreen(lobbyRoomJoined:Boolean) 
		{
			//screenUI = GetDisplayObject.getSymbol("roomBG");
			//addChild(screenUI);
			//_lobbyRoomJoined = lobbyRoomJoined;
			
		}	
		
		override public function initialize():void
		{
			//trace("++++++++++++++++++trcae oonly+++++++++++++++++++++++++++++++++");
			super.initialize();
			_lobbyRoomJoined = false;
		
			//screenUI = new Resources.roomBG();
			  screenUI = GetDisplayObject.getSymbol("roomBG");
			 addChild(screenUI);
			 screenUI.roomMask.visible = false;
			// addGameEventListener(screenUI.searchb, MouseEvent.CLICK, searchCall);
			//  addGameEventListener(screenUI.rechargeb, MouseEvent.CLICK,AddCashRequestScreen);
			 addGameEventListener(screenUI.closeB, MouseEvent.CLICK, function ():void {
			   SfsMain.sfsclient.logout(); } );
			//screenUI.room1.visible = false;
			
			_lbHandler = new LobbyButtonHandeler(this,screenUI);
			SfsMain.sfsclient.getRoomList();
			
			//setForResize();
			 addGameEventListener(screenUI.info, MouseEvent.CLICK, gotoAddress);
			  addGameEventListener(screenUI.opB, MouseEvent.CLICK, infoCall);
			  addGameEventListener(screenUI.kassaB, MouseEvent.CLICK, AddCashRequestScreen);
			  addGameEventListener(screenUI.helpB, MouseEvent.CLICK, helpCall);
			  addGameEventListener(screenUI.games, MouseEvent.CLICK, getFuturegames);
			 // SoundPlayer.muteAll(false);
		}
		private function helpCall(evt:MouseEvent):void
		{
			SoundPlayer.playSound("buttonClick");
			var str:String = "http://helpdesk.myglobalgames.com";
			var request:URLRequest = new URLRequest(str);
			
	     	        try {
				           navigateToURL(request, "_blank");
			             } 
		            catch (e:Error)
					     {
						    trace("Error occurred!");
					     }
					
			
		}
		private function gotoAddress(evt:MouseEvent):void
		{
			SoundPlayer.playSound("buttonClick");
			//var str:String = "http://www.myglobalgames.com/uitbetalen/"+Main._userName;
			var str:String = "http://www.myglobalgames.com/uitbetalen/";
			var request:URLRequest = new URLRequest(str);
			
	     	        try {
				           navigateToURL(request, "_blank");
			             } 
		            catch (e:Error)
					     {
						    trace("Error occurred!");
					     }
		}
		private function infoCall(evt:MouseEvent):void
		{
			SoundPlayer.playSound("buttonClick");
			//var str:String = GetDisplayObject.getPaymentArray()+Main._userName;// "http://helpdesk.myglobalgames.com";
			var str:String = GetDisplayObject.getPaymentArray();// "http://helpdesk.myglobalgames.com";
			
			var request:URLRequest = new URLRequest(str);
	     	        try {
				           navigateToURL(request, "_blank");
			             } 
		            catch (e:Error)
					     {
						    trace("Error occurred!");
					     }
					
			
		}
		public function AddCashRequestScreen(evt:Event=null):void
	    {        
		//	trace("event", evt, _kassaFlag);
			   if(evt==null)
			     addLayerTodisableAllButton();
				else
				{
				 _kassaFlag = true;
				 SoundPlayer.playSound("buttonClick");
				}
				
	      	   if (_cashRequestScreen==null)
		     	{
		            _cashRequestScreen = new CashRequest(this,true);
					addChild( _cashRequestScreen);
					_cashRequestScreen.x=(screenUI.width- _cashRequestScreen.width)/2
					_cashRequestScreen.y=(screenUI.height- _cashRequestScreen.height)/2
					
				}
				else
				 removeCashScreen();
				
				setForResize();
       	}
	public function addLayerTodisableAllButton():void
	    {
			 screenUI.roomMask.visible = true;
			
	    }
	public function removeLayerToEnableAllButton():void
	{
		// rect = new Rectangle(0,0,screenUI.width,screenUI.height);
	   // screenUI.addChild(rect);
	 //  trace("gaya")
	    screenUI.roomMask.visible = false;
	  //  screenUI.removeChild(rect);
	}
	public function removeCashScreen():void
	{
		if (_cashRequestScreen)
			{
				removeChild(_cashRequestScreen);
				//trace("evenbdasasflksdt", _kassaFlag);
				if (!_kassaFlag)
				{
				removeLayerToEnableAllButton();
				Main.isFirstLogin = false;
				}
				_kassaFlag = false;
				
				 _cashRequestScreen = null;
			}
		
	}
		
		
		override public function resizeScreen():void
		{
		
				var stageWidth:Number = stage.stageWidth;
				var stageHeight:Number = stage.stageHeight;
				
				var hsf:Number = stageWidth / BingoGameScreen.origWidth;
			    var vsf:Number = stageHeight / BingoGameScreen.origHeight;
		
						
			if (screenUI)
			{
				screenUI.width = stage.stageWidth;
				screenUI.height =stage.stageHeight;	
			}
			 if ( _cashRequestScreen)
			 {
				    _cashRequestScreen.resizeScreen(hsf, vsf);
				    _cashRequestScreen.x = ((stage.stageWidth - _cashRequestScreen.width) / 2 )-20* hsf;
					_cashRequestScreen.y = ((stage.stageHeight - _cashRequestScreen.height) / 2) * vsf;
					
			 }
			 if (_futureGames)
			 {
				  _futureGames.x = ((stage.stageWidth - _futureGames.width) / 2 )* hsf;
				_futureGames.y = ((stage.stageHeight - _futureGames.height) / 2) * vsf;
			 }
			
		}
					
		override public function onJoinRoom(evt:SFSEvent):void
		{
			
		     joinedRoom = evt.params.room;
		//	trace(joinedRoom,"rrrrrrrrrrrr");
			_UserType = int(joinedRoom.getUser(Main._userName).getVariable("Utype"));
			//trace ( " Room Joined++++++++++++++++++++++++",joinedRoom.getName());
			if (joinedRoom.getName() == "Lobby1")
			{
				//trace("++++++++++++++++++loby room is joined  is called++++++++++++++++++++++++++++++++++");
			    _selfUser = joinedRoom.getUser(Main._userName);
				setUserIfo(_selfUser);
			    var sendParam:Array=[2,"Lobby1"];
			    SfsMain.sfsclient.sendXtMessage("LobbyExt", "2",sendParam,"str");
			}
			if (joinedRoom.getName() != "Lobby1")
			{
				//now this screen is to be removed and BingoGame to be added
				var main:Main = this.parent as Main;
				Main.showGameScreen(joinedRoom);				
			}			
		}
		
		override public function onRoomListUpdate(evt:SFSEvent):void
		{
			//trace("+++++++++++++++++++++_lobbyroom joined called+++++++++++++++++++++++");
			
			//roomStatusArray = new Array(6);
			if (!_lobbyRoomJoined)
			{

			//
				var sendParam:Array=[1,"Lobby1"];
			    SfsMain.sfsclient.sendXtMessage("LobbyExt","1", sendParam, "str");
				//SfsMain.sfsclient.joinRoom("Lobby1");

				
				_lobbyRoomJoined = true;
			}
			for (var i:int = 1; i < roomStatusArray.length; i++)
			{
				
				 screenUI["room" + i].status.text = "Gesloten...";
				if ( roomStatusArray[i]==1)
				{
				  roomStatusArray[i] == 0;
				  
				}
			}
			
			_roomList =new Array(6);
		
			 for (var r:String in evt.params.roomList)
			 { 
				if ( evt.params.roomList[r].getName() != "Lobby1")
				{
					var k:int = int(evt.params.roomList[r].getVariable("rid"));
					var nm:String = evt.params.roomList[r].getName();
				    if ((k>0) && (k<6)&& nm.indexOf("Globalstars_temp_")==-1)
				    {
						setvaluesOnScreen(evt.params.roomList[r]);
					   _roomList[k] = evt.params.roomList[r].getName();
				    }
				}
				
				
			 }
			 for (var j:int = 1; j < roomStatusArray.length; j++)
			{
			
				if ( roomStatusArray[j]==1)
				{
					//trace("++++++++++++++++++++add event listener is called+ for button+++++++++++++++++++++++++++++",j);
				  _lbHandler.addListener(screenUI["room"+j]);
				}
				if( roomStatusArray[j]==0)
				{
				//	trace("++++++++++++++++++++remove event listener is called++++++++++++++++++++++++++++++",j);
				  _lbHandler.removeListener(screenUI["room" + j]);
				  
				}
			}
							             
		}
		public function setBalance(balanceA:Array):void
		{						 
	       // _userScreen.setBal(balanceA);
		   //trace("++++++++++++++++++++++cash balance and win balance is set now++++++++++++++++++++++++++");
		      screenUI.winamount.text ="€ "+  Number(balanceA[0]).toFixed(2);
			  screenUI.gameamount.text = "€ " + Number(balanceA[1]).toFixed(2);
			  _gameAmount = (Number(balanceA[0]) + Number(balanceA[1])).toString();
			//total_Amount = Number(balanceA[0]) + Number( balanceA[1]);
		}
		private function searchCall(e:MouseEvent):void
		{
			
			if (screenUI.searchname.text == "")
			  searchName= "";
			else
			 searchName = (screenUI.searchname.text).toString();
			if (_searchScr)
			 removeChild(_searchScr);
			 
			_searchScr = new SearchScreen();
			_searchScr.x = (screenUI.width - _searchScr.width)/2;
			_searchScr.y = (screenUI.height - _searchScr.height)/2+50;
			addChild(_searchScr);
		//	trace(searchArray, "search array", searchName,"ashish");
			_searchScr.showResult(searchArray, searchName, _roomList);
			
		}
		private function  displaySearch():void
		{
			
		}
		public function setbgcolor(evt:Event):void
		{
			 SoundPlayer.playSound("buttonClick");
			var name:String = evt.currentTarget.name;
			//trace(name,"color name")
			var i:int = int(name.substr(3))
			screenUI[evt.currentTarget.parent.name].currentcolor.gotoAndStop(i);
			_bgcolor = i;
			
		}
		public function setmarkcolor(evt:Event):void
		{ 
		//	trace("mark is pressed");
		   SoundPlayer.playSound("buttonClick");
			var name:String = evt.currentTarget.name;
			var i:int = int(name.substr(4))
			screenUI[evt.currentTarget.parent.name].currentmark.gotoAndStop(i);
			_markcolor = i;
		}
		public function buycard(evt:Event):void
		{
			SoundPlayer.playSound("buttonClick");
			if (_UserType!=1)
			{
		    var str:String = evt.currentTarget.parent.name;
			var rmname:String=evt.currentTarget.parent["roomname"].text
		   var numofcard:String= evt.currentTarget.name.substr(8);	
	      var sendParam:Array = ["1" + str.substr(4), numofcard,rmname];
		//trace(str,"trace valueKKKKKKKKKKKKKKKK",sendParam,"KKKKKKKKKKKKKK",rmname);
		 SfsMain.sfsclient.sendXtMessage("LobbyExt", "2", sendParam, "str");
			}
		
		}
		
		public function setvaluesOnScreen(rm:Room):void
		{
			
			if (rm)
			{
				//trace("current round ++++++++++++++++++++++   rooom name",rm.getVariable("rid"),rm.getName());
				var i:int = (int)(rm.getVariable("rid"));
				if (i >= 9)
					return;
				maximunNoOfrounds[i] = int(rm.getVariable("mrnd"));
			    screenUI["room" + i].maxround.text = maximunNoOfrounds[i];
				screenUI["room" + i].roomname.text = rm.getName();
				 var str:String="";
				if ((int(rm.getVariable("rs")) == 1)&&(int(rm.getVariable("Crnd"))<=1))
				{
				   str = "Verkoop... ";
				   screenUI["room" + i].status.text = str;
				}
				 else
				 {
				  str = "Bezig... ";
				  screenUI["room" + i].status.htmlText = "<font color='#009900'>" + str + "</font>";
				 }
				screenUI["room" + i].startdate.text= rm.getVariable("dt");
				screenUI["room" + i].currentround.text =int(rm.getVariable("mrnd"))-int(rm.getVariable("Crnd"))+1;
				roundNo = int(rm.getVariable("Crnd"));
				screenUI["room" + i].book1p.text =setAmount(Number(rm.getVariable("bp1")));
			    screenUI["room" + i].book2p.text = setAmount(Number(rm.getVariable("bp2")));
				screenUI["room"+ i].book3p.text = setAmount(Number(rm.getVariable("bp3")));
				screenUI["room" + i].book4p.text = setAmount(Number(rm.getVariable("bp4")));
				screenUI["room"+ i].book5p.text = setAmount(Number(rm.getVariable("bp5")));
				screenUI["room" + i].book6p.text = setAmount(Number(rm.getVariable("bp6")));
				
				screenUI["room" + i].p1r.text = setRoundPrize(String(rm.getVariable("p1")));
				screenUI["room" + i].p2r.text =setRoundPrize(String(rm.getVariable("p2")));
				screenUI["room"+ i].p3r.text = setRoundPrize(String(rm.getVariable("p3")));
				roomStatusArray[i] = 1;
			}
		  
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
		public function setnoOfCard(str:String):void
		{
			//trace("hi how",str.toString());
			var j:int = 1;
			 for (j = 1; j <= 5; j++ )
			       {
					    if (_UserType==1&&screenUI["room" + j].currentround.text!="0")
					   {
						    screenUI["room" + j].go.play();
						 addGameEventListener(screenUI["room" + j].go, MouseEvent.CLICK, joinGameRoom);  
					   }
				   }
				   
			    if (str != "null")
			    {
				 //  trace("this is testing if",str);
			       for (j = 1; j <= 5; j++ )
			       {
			           screenUI["room" + j].numtxt.text = str.substr(j, 1);
					   NoOfCard[j] = str.substr(j, 1);
					   if (_UserType==1)
					   {
						   // screenUI["room" + j].go.play();
						// addGameEventListener(screenUI["room" + j].go, MouseEvent.CLICK, joinGameRoom);  
					   }
					   else
					   {
						   
			                if (int(str.substr(j, 1)) > 0)
			                 {
				             // trace("event listener is added", j);
						        screenUI["room" + j].go.play();
			        	        addGameEventListener(screenUI["room" + j].go, MouseEvent.CLICK, joinGameRoom);
					
			                   }
					   }
			       }
			    }
			   else
			     {
				//trace("this is testing else");
			     }
			
			
		}
		public function setUserIfo(u:User):void
		{
			
			//trace("set user info ist calledgfdgffghgfhghjgjhgjhgjh");
			screenUI.username.text = u.getName();
			
			screenUI.winamount.text ="€ "+Number(u.getVariable("cashB")).toFixed(2);
			screenUI.gameamount.text = "€ " +Number( u.getVariable("winB")).toFixed(2);
			  _gameAmount = (Number(u.getVariable("cashB")) + Number(u.getVariable("winB"))).toString();
			  //trace("game amount in lobby ********************", _gameAmount,screenUI.winamount.text,screenUI.gameamount.text);
			var str:String = u.getVariable("NofB");
			if (Main.isFirstLogin)
			{
				Main.isFirstLogin = false;
			   AddCashRequestScreen();
			}
			//trace(str,"no of card++++++++++");
		    
		}
		private function getFuturegames(evt:MouseEvent):void
		{
			 var sendParam:Array = [3];
		 //  trace("trace valueKKKKKKKKKKKKKKKK",sendParam,"KKKKKKKKKKKKKK");
		   SfsMain.sfsclient.sendXtMessage("LobbyExt", "3", sendParam, "str");
		}
		public function joinGameRoom(evt:Event):void
		{
			SoundPlayer.playSound("buttonClick");
			var i:int = evt.currentTarget.parent.name.substr(4);
			//trace("go button is clicked",i,evt.currentTarget.parent.name,_roomList[i]);
			var sendParam:Array = [1, _roomList[i]];
			//trace(send);
			    SfsMain.sfsclient.sendXtMessage("LobbyExt","1", sendParam, "str");
			//SfsMain.sfsclient.joinRoom(_roomList[1]);
			
		}
					
		override public function onExtensionResponse(event:SFSEvent):void
		{
			
			var result:*= event.params.dataObj;
			
			var resNum:int = int (result[0]);
			if (resNum==4)
			{
				//trace("++++++++get room list command called+++++++++++++++++");
				SfsMain.sfsclient.getRoomList();
				return;
			}
		//	trace("hi asdjsdhasd asdad",resNum,result);
			var info:Array = result[2].split(":");
			if (resNum == 21)
			{
				//trace(info);
				 info= result[2].split(",");
				setBalance(info);
				
			}
			if (resNum == 5)
			{
			
				setnoOfCard(info[0]);
				screenUI.infotxt.text = info[2];
				//var RoundA:Array = info[1].split(";");
			
			}
			if (resNum==3)
			{
				screenUI.infotxt.text = info[1];
			}
			
			if (resNum==2)
			{
				//trace("hi ram",info,maximunNoOfrounds[info[0]]);
				      if (maximunNoOfrounds[int(info[0])] != null)
					  {
				     
						  screenUI["room" + info[0]].currentround.text =maximunNoOfrounds[int(info[0])]-int(info[1])+1;
				          var str:String = "";
						if ((int(info[2]) == 1)&& (int(info[1]) == 1))
						{
						    str = "Verkoop... ";
							screenUI["room" + info[0]].status.text = str;
						}
						else
						{
						str = "Bezig... ";
						screenUI["room" + info[0]].status.htmlText = "<font color='#009900'>" + str + "</font>";
						}
					  }
					  //else
					    /// screenUI["room" + info[0]].status.text = "Gesloten...";
					
			}
			if (resNum == 206)
			{
				if (result[2] != "0")
				{
				
					screenUI["room" + info[0]].numtxt.text = info[1];
					NoOfCard[int(info[0])] = info[1];
					screenUI["room" + info[0]].go.play();
				   addGameEventListener(screenUI["room" + info[0]].go,MouseEvent.CLICK,joinGameRoom);
				}
				
			}
			if(resNum == 10)
			{
				if ( int(screenUI["room" + info[0]].numtxt.text)>0)
				{
					var i:int = int(info[0]);
					_lbHandler.removeListener(screenUI["room" + info[0]]);
					 screenUI["room" + info[0]].numtxt.text = 0;
					 
					 screenUI["room" + info[0]].go.gotoAndStop(1);
				     removeGameEventListener(screenUI["room" + info[0]].go, MouseEvent.CLICK, joinGameRoom);
					 maximunNoOfrounds[i] = 0;
			    screenUI["room" + i].maxround.text =0;
				screenUI["room" + i].roomname.text ="Gesloten";
				screenUI["room" + i].startdate.text= "- - - - - -";
				screenUI["room" + i].currentround.text = 0;
			
				screenUI["room" + i].book1p.text ="000";
			    screenUI["room" + i].book2p.text = "000";
				screenUI["room"+ i].book3p.text = "000";
				screenUI["room" + i].book4p.text = "000";
				screenUI["room"+ i].book5p.text = "000";
				screenUI["room" + i].book6p.text = "000";
				
				screenUI["room" + i].p1r.text = "000";
				screenUI["room" + i].p2r.text ="000";
				screenUI["room"+ i].p3r.text = "000";
				roomStatusArray[i] = 3;
				}
				
			}
			if(resNum == 11)// future games reponse
			{
				createAllFutureRooms(result[2]);
			}
			if(resNum == 12)// future games reponse
			{
			     if (_futureGames)
				 _futureGames.updatePurchsedBooks(result[2]);
			}
			 if (result[0] =="121")
			{
				if (_cashRequestScreen)
				       {
				         _cashRequestScreen.addCash(result[2]);
				       }
			}
			
		}
		private function createAllFutureRooms(respose:String):void
		{
			//trace("string " + respose)
			removeGames();
			_futureGames = new RoomListForFutureGame(removeGames);
			 addChild(_futureGames)
			 resizeScreen();
			_futureGames.createRooms(respose);
		}
		private function removeGames(evt:MouseEvent=null):void
		{
			if (_futureGames && this.contains(_futureGames))
			{
				removeChild(_futureGames);
				_futureGames = null;
			}
		}
	
	}
}