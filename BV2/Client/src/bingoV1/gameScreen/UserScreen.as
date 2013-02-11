package bingoV1.gameScreen 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import gameCommon.screens.BaseScreen;
	import bingoV1.gameScreen.UserList;
	import it.gotoandplay.smartfoxserver.data.User;
	import it.gotoandplay.smartfoxserver.data.Room;
	import gameCommon.smartFoxAPI.SfsMain;
	import it.gotoandplay.smartfoxserver.SFSEvent;
	import bingoV1.lobbyScreen.MainLobbyScreen;
	 /* ...
	 * @author ashish
	 */
	public class UserScreen extends BaseScreen
	{
		
		  private var ulist:UserList;
		  private var _selfUser:User;
	   	  public static  var chatStatus:int;
   		  public var _joinedRoom:Room;
		 // public var chatnput:*;
		  private var PlayerInGameArray:Array;
		  public var onLineUserList:Array;
		  public var _totalUserArray:Array;
		  private var _userTypeArray:Array;
		  public var width1:Number;
		  public var _height:Number;
		  public var publicChatp:Point;
		  private var _winnerList:WinnerList;
		  private var textSymbol:*;
		  private var _bgs:BingoGameScreen;
		  
		public function UserScreen(room:Room,bgs:BingoGameScreen) 
		{
			_bgs = bgs;
			screenUI = new Resources["userScreen" + MainLobbyScreen._bgcolor]();
		    textSymbol = GetDisplayObject.getSymbol("userScreenText");
			textSymbol.name = "textSymbol";
			screenUI.addChild(textSymbol);
			textSymbol.x= screenUI.txtP.x;
			textSymbol.y = screenUI.txtP.y;
			var textSymbol1:Sprite = GetDisplayObject.getSymbol("publicChatScreenText");
			textSymbol1.name = "textSymbol1";
			screenUI.addChild(textSymbol1);
			textSymbol1.x= screenUI.txtQ.x;
			textSymbol1.y=screenUI.txtQ.y;
			width1 = screenUI.width;
		    _height = screenUI.height;
			addChild(screenUI);
			publicChatp = new Point(screenUI.publicChatP.x, screenUI.publicChatP.y);
			_joinedRoom = room;
			SfsMain.sfsclient.activeRoomId = _joinedRoom.getId();		
			_selfUser = _joinedRoom.getUser(Main._userName);
			SfsMain.sfsclient.myUserId = _selfUser.getId();
			chatStatus = int(_selfUser.getVariable("chatS"));
				
			
			//chatnput=screenUI.
		    setUserInfo();
		}
		
		public function resizeScreen(hsf:Number,vsf:Number):void
		{
			//screenUI.scaleX = hsf;
			screenUI.height = _height * vsf;
			//ulist.x =screenUI.userList.x*hsf;
			ulist.y = screenUI.userList.y * (vsf);
			ulist.resizeScreen(hsf, vsf);
			textSymbol.x= screenUI.txtP.x*hsf;
			textSymbol.y = screenUI.txtP.y* vsf;
			//_winnerList.x = screenUI.winnerList.x*hsf;;
			_winnerList.y = screenUI.winnerList.y* (vsf)-1;
			
			_winnerList.resizeScreen(hsf, vsf);
			
		}
		public function setUserInfo():void 
		{
			ulist = new UserList(screenUI);
			//ulist.setVisibleHW(screenUI.chatendp.x - screenUI.chatstartp.x,screenUI.chatendp.y - screenUI.chatstartp.y);
			IgnoreUserManager.initialize(ulist);
			var ist:String = _selfUser.getVariable("IU");
			IgnoreUserManager.parseIgnoreString(ist);
			ulist.x =screenUI.userList.x;
			ulist.y = screenUI.userList.y;
			_winnerList = new WinnerList(screenUI,_bgs);
			_winnerList.x = screenUI.winnerList.x;
			_winnerList.y = screenUI.winnerList.y;
			addChild(_winnerList);
			// screenUI.addChild(ulist);
			// ulist.addUsers(_totalUserArray);
		}
		public function removeWinnerCards():void
		{
		//	trace("hi listener1");
			if (_winnerList)
			{  
				//trace("hi listener2");
				_winnerList.removeCard();
			}
		}
		public function refreshWinnerList():void
		{
			if (_winnerList)
			{   _winnerList.removeCard();
				removeChild(_winnerList);
				_winnerList = null;
			}
			_winnerList = new WinnerList(screenUI,_bgs);
			_winnerList.x = screenUI.winnerList.x;
			_winnerList.y = screenUI.winnerList.y;
			addChild(_winnerList);
		}
		public function setBal(bal:Array):void
		{
			screenUI.cashAmount.text ="€ "+  Number(bal[0]).toFixed(2);
			screenUI.gameAmount.text ="€ "+ Number(bal[1]).toFixed(2);
		}
		public function setFamt(txt:String):void
		{
			//textSymbol.famount.text = txt;
			screenUI.famount.text = txt;
		}
		public function setSamt(txt:String):void
		{
			//textSymbol.samount.text = txt;
			screenUI.samount.text = txt;
		}
		public function setVamt(txt:String):void
		{
		    // textSymbol.bamount.text = txt;
				screenUI.bamount.text = txt;
		}
		public function cardPos():Number
		{
			return screenUI.cardp.x;
		}
		public function chatPos():Number
		{
			return screenUI.publicChatP.y;
		}
		public function updatePlayerList(str:String):void
		{
			PlayerInGameArray = new Array();
			//
			if (str!="")
			{
				//trace("PlayerInGameArray in gameCommon string",str);
			PlayerInGameArray = str.split(",");
			}
			//trace("player in game array.........................",PlayerInGameArray);
			 makeList();
			
		}
		private  function makeList():void
		{
			onLineUserList = new Array();
			
		     var users:Array = _joinedRoom.getUserList();
			// _nameIdMap = new Object();
			 
			for (var u:String in users)
			{				
				onLineUserList.push(users[u].getName());
				//_nameIdMap[users[u].getName()] = users[u].getId();
			}
		
		//	trace("list",onLineUserList);
			DisplayPlayerList();
			
		}
		private function DisplayPlayerList():void
		{
			_totalUserArray = new Array();
			_userTypeArray = new Array();
			var PlayerInGame:Array = new Array();
	     	//	trace("player in game array......................",PlayerInGameArray);
			for (var s:int = 0; s < PlayerInGameArray.length;s++ )
			{
				PlayerInGame[s] = PlayerInGameArray[s];
				//trace(" assignment work +++++++++++++++++++++++++++",s);
				//setstate(PlayerInGame[s].toString(), 1);
			}
		    //	var PlayerInGame:Array = PlayerInGameArray;
			
			if (PlayerInGameArray.length>0)
			{
				//trace("play in game array......................",PlayerInGameArray[0],onLineUserList.length);
				for (var i:int = 0; i < onLineUserList.length; i++)
				{
					var typ:int = getUserType(onLineUserList[i]);
					if (typ == 1)
					{
						typ = 10;
					}

					var k:int = PlayerInGame.indexOf(onLineUserList[i]); 
					if (k < 0)
					{
						typ += 2;
					    var obj:Object = { name:onLineUserList[i], type:typ.toString()};
						_totalUserArray.push(obj);
									
					}
					else
					{
						typ += 1;
						  var obj1:Object = { name:onLineUserList[i], type:typ.toString() };
						_totalUserArray.push(obj1);
						
						PlayerInGame.splice(k, 1);
					//	trace("taotal arr",PlayerInGame)
					}
				
				}
				
			}
			else
			{
				//trace("in side else part of the screen+++++++++++++++++++++++++++");
				for (var l:int = 0; l < onLineUserList.length; l++)
				{
					var typ1:int = getUserType(onLineUserList[l]);
					if (typ1 == 1)
					{
						typ1 = 10;
					}
					if (onLineUserList[l] != "")
					{
						typ1 += 1;
					  var obj2:Object = { name:onLineUserList[l], type:typ1.toString() };
						_totalUserArray.push(obj2);
					}
					
				}
				
			}
			
		   for (var j:int = 0; j < PlayerInGame.length; j++ )
			{
				
				if (PlayerInGame[j] != "")
				{
					var ty:int = getUserType(PlayerInGame[j]);
					if (ty== 1)
					{
						ty = 10;
					}
				////	trace("this is the list of players online :::::::::::::::::::::::::::::::::::::",ty,PlayerInGame[j]);	
					  var obj3:Object = { name:PlayerInGame[j], type:(ty+2).toString() };
						_totalUserArray.push(obj3);
			
				}
			}
			//trace("this is the list of players online :::::::::::::::::::::::::::::::::::::",_totalUserArray);	
	        addChild(ulist);
			if (_totalUserArray[_totalUserArray.length - 1] == "")
			{
				_totalUserArray.splice([_totalUserArray.length - 1], 1)
				
			}
			//trace("hi what is this",_totalUserArray[0].name);
			ulist.addUsers(_totalUserArray);
			
		 
							
		}
		
		public function getUserType(name:String):int
		{
			var user:User = _joinedRoom.getUser(name);
			//trace("user name",name);
			if (user)
			{
				//trace("tracedin ", int(user.getVariable("Utype")), user.getName(), "tracedin ");
				var i:int = int(user.getVariable("Utype"));
				//trace("user in game room ",i, user.getName(), "tracedin ");
				return i;
			}
			else
			{
				//trace("user no in game room");
			    return 0;	
			}
		}
		public function setWinnerFun(sa:Array,state:int):void
		{
			//ulist.setWinner(name, noOfWinningCard, noOfTotalCard, WinningAmount, state);
			_winnerList.addWinner(sa, state);
		}
		public function setUserInGame(Name1:String,i1:int):void
		{
			ulist.setuserInGame(Name1, i1,getUserType);
		}
	}

}