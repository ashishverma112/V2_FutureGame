package bingoV1.gameScreen 
{
	import flash.events.TimerEvent;
	import flash.display.Loader;
	import flash.net.URLRequest; 
	import flash.display.Sprite;
	import flash.geom.Point;
	import it.gotoandplay.smartfoxserver.data.Room;	
	import it.gotoandplay.smartfoxserver.data.User;	
	import gameCommon.screens.BaseNetworkScreen;
	import it.gotoandplay.smartfoxserver.SFSEvent;
	import multiLanguage.ResizeableContainer;
	import multiLanguage.LanguageXMLLoader;
	import gameCommon.smartFoxAPI.SfsMain;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import bingoV1.gameScreen.SoundScreen;
	import gameCommon.lib.SoundPlayer;
	import bingoV1.gameScreen.PublicChatScreen;
	import bingoV1.lobbyScreen.MainLobbyScreen;
	import flash.events.Event;
	import bingoV1.gameScreen.WinnerList;
	import flash.net.navigateToURL;
     
	
	
	/**
	 * ...
	 * @author Siddhant
	 */
	public class BingoGameScreen extends BaseNetworkScreen
	{
		
		public var hsf:Number =1;
		public var vsf:Number = 1;
		public var _joinedUser:User;
		public var _joinedRoom:Room;
		public var _goldenTimeText:Number = 0; 
		public var _Background:String;
		public var  bg:int = 0;
		//public var intro:Boolean = false;
		public static  var chatStatus:int;
		public static var _RoomChatSt:int;
		public var _cashRequestScreen:CashRequest;
		public var _gameAmount:String;
	    public var _prize1Array:Array;
	    public var _prize2Array:Array;
		public var _prize3Array:Array;
		private const _cashResponse:int = 121;
		private const _cashBackResponse:int = 124;
		private const WinInOtherRoom:int = 123;
		private const BanFromChat:int = 101;
		private const AdminMsgToAll:int = 102;
		private const AdminPersonalMsg:int = 103;
		private const moveToLobby:int = 100;
		private const  setBackground:int = 26;
		private const JackpotTime:int = 24;
		private const WelcomeMsg:int = 23;
		private const BUserList:int = 22;
		private const Balance_info:int = 21;
		private const TIME_LEFT:int = 0;
		private const GAME_STATE:int = 6;
		private const CARD_NUMBERS:int = 2;
		private const NEW_NUMBER:int = 3;
		private const FIRSTLINE_WINNER:int = 13;
		private const SECONDLINE_WINNER:int = 14;
		private const BINGO_WINNER:int = 15;
		private const PLAYER_LIST:int = 8;
		private const PLAYER_JUST_ADDED:int = 9;
		private const TIMER_STATE:int = 0;
		private var  _automate:int = 1;
		private var _funPlayer:int = 0;
		private var _pattern:int = 20;
	    private var _winnerScreenWidth:Number = 381.1;
		private var _winnerScreenHeight:Number = 215.1;
		
		private var _announcement:RunningText=null;
		private var _timerScreen:GameTimerScreen;
		private var _numberScreen:NumberGenerationScreen;
		public var _cardContainer:CardContainer2;
		private var _currentState:int;
		private var _patternCard:PatternCard;
		private const DyanamicBonus:int = 104;
		private var _btnHandler:ButtonHandler;
		private const ballsPassed:int = 0;
		private const buyCards:int = 1;
		private const funPlay:int = 2;
		private const automate:int = 3;
		private const gotoJackPot:int = 4;
		public var onLineUserList:Array;
        private var _userTypeArray:Array;
		public var _totalUserArray:Array;
		private var ulist:UserList;
		public var total_Amount:Number = 0.0;
        private var PlayerInGameArray:Array;
		public var _numCards:int ;
		private var _cardBuyScreen:BuyCardsScreen=null;
		private var _maxCards:int;
		private var _ballScreen:BallScreen;
		private var _userScreen:UserScreen;
		
		private var _gameState:int;
		private var _cardString:String = "1";
		private var _patterString:String;
		private var _timeIntervalId:uint;
		private var myTimer:Timer ;//= new Timer(1000); // 1 second
  
		private var _soundScreen:SoundScreen;
		private var _newNumGenerator:*;
		private var _tempArray:Array;
		
		private var _gameAmountSymbol:*;
		private var _soundScreenEnabled:Boolean;
		
		//we will have a container where all those to be resized as per screen are kept together
		private var _fullResizableContainer:Sprite;
		private var _sizeRetentionContainer:Sprite;
		//private var _publicChatScreen:PublicChatScreen;
		public  var _publicChatScreen:PublicChatScreen;
		public var currentTargetedChat:*;
		public static const origWidth:Number = 1024;
		public static const origHeight:Number = 768;
		 
		
		
		private var allwiner:AllWinnerScreen;
		
		private var _selfUser:User;
		public static var amtArr:Array;
		private var noOfFirstWinner:int = 0;
		private var noOfSecondWinner:int = 0;
		private var noOfVolleWinner:int = 0;
		private var objArray:Array;
		private var balls:int = 0;
		public static var roundno:int = 1;
		private var ballGen:*;
		private var glass:*;
		private var chatP:Point;
		public var _maxRound:int;
		
		private var smileFlag:Boolean = false;//------------------------var for smilechat--------------------------------
		private var smile:SmileScreen;//------------------------var for smilechat--------------------------------
        
		private var winnerObj:WinnerScreen;
		  private var  numberCollection1:Array=new Array(15);
	      private var  numberCollection2:Array=new Array(15);
	      private  var  numberCollection3:Array=new Array(15);
	      private  var  numberCollection4:Array=new Array(15);
	      private  var  numberCollection5:Array=new Array(15);
	      private var  numberCollection:Array = new Array(24);

		public function BingoGameScreen(roomObj:Room) 
		{
			//trace (" user name ", SfsMain.sfsclient.myUserName);
			_fullResizableContainer = new Sprite();
			_fullResizableContainer.mouseEnabled = false;
			
			addChildAt(_fullResizableContainer, 0);
			_sizeRetentionContainer = new Sprite();
			addChildAt(_sizeRetentionContainer, 1);
			_sizeRetentionContainer.mouseEnabled = false;
			screenUI = GetDisplayObject.getSymbol("gameScreen");
			if (MainLobbyScreen._UserType!=1)
			{
			  screenUI.noOfCard.text = MainLobbyScreen.NoOfCard[int(roomObj.getVariable("rid"))];
			}
			screenUI.username.text=Main._userName;
			_fullResizableContainer.addChild(screenUI);
			_joinedRoom = roomObj;
			SfsMain.sfsclient.activeRoomId = _joinedRoom.getId();		
			_selfUser = _joinedRoom.getUser(Main._userName);
			SfsMain.sfsclient.myUserId = _selfUser.getId();
			chatStatus = int(_selfUser.getVariable("chatS"));
			_publicChatScreen = new PublicChatScreen();
			_sizeRetentionContainer.addChild(_publicChatScreen);
			_publicChatScreen.smileB(this);
			//_publicChatScreen.height -= 40;
			_publicChatScreen.x = screenUI.publicChatP.x;
			_publicChatScreen.y = screenUI.publicChatP.y;
			
			_userScreen = new UserScreen(roomObj,this);
			_userScreen.x = screenUI.userinfoP.x;
			_userScreen.y = screenUI.userinfoP.y-10;
			_sizeRetentionContainer.addChild(_userScreen);
		
			_cardBuyScreen = null;
			_newNumGenerator = null;
			_numberScreen = null;
			//_patternCard = null;
			winnerObj = null;
			roundno= MainLobbyScreen.roundNo;
			ballGen = new Resources.ballGenerate();
			glass = new Resources.glassB();			
			glass.x = screenUI.ballGeneratorPos.x;
			glass.y = screenUI.ballGeneratorPos.y+2;
			ballGen.x = screenUI.ballGeneratorPos.x;
			ballGen.y = screenUI.ballGeneratorPos.y+2;
			_sizeRetentionContainer.addChild(ballGen);
			_sizeRetentionContainer.addChildAt(glass,0);
			
			
			//MTscreen = screenUI;
			
		addGameEventListener(ballGen.closeB, MouseEvent.CLICK, function ():void {
				if (_numberScreen)
				_numberScreen.removeScreen();
			     SoundPlayer.stopSound("intro");
			    _numberScreen = null; SfsMain.sfsclient.logout(); } );
				
			
			
			

			_soundScreen = new SoundScreen(this);
         
			PrivateChatManager.intialize(this);
			//addChild(screenUI);
			screenUI.bgColor.gotoAndStop(MainLobbyScreen._bgcolor);
			objArray = new Array();
			amtArr = new Array();
			setRoomPropertiesFromVariables(_joinedRoom.getVariables());
			setBottomButtons();
			sendGetStateRequest();
			SoundPlayer.muteAll(false);
			
			
		}
		//------------------------function for smilechat--------------------------------
		public function smileScreen(e:MouseEvent):void
		{
			if (!smileFlag)
			{
			smileFlag = true;
			smile = new SmileScreen();
			
			addChild(smile);
			smile.addEvent(_publicChatScreen);
			}
			else
			{
			   removeSmile();
			}
			setForResize();
		}
		public function removeSmile():void
		{
			    removeChild(smile);
				smile.removeEvent(_publicChatScreen);
				smileFlag = !smileFlag;
		}
		//------------------------function for smilechat--------------------------------
		private function loadGame():void
		{
			
			  // screenUI.addChild(FileLoader.loader.content);
			   screenUI.addChildAt(FileLoader.loader.content, 3);
			    FileLoader.loader.content.width = screenUI.width;
				 FileLoader.loader.content.height = screenUI.height;
			   FileLoader.loader.content.x =screenUI.x;
		    	FileLoader.loader.content.y =screenUI.y;
			    /*var ldr:Loader = new Loader(); 
			      var urlReq:URLRequest = new URLRequest(_Background); 
                         ldr.load(urlReq); 
                           addChild(ldr);*/
		}
		public function addStagEvent():void
		{
			
			if (stage)
			{

				addGameEventListener(stage, MouseEvent.CLICK, removeWinnerCards);
			}
		}
		public function removeStagEvent():void
		{
			if (stage)
			{
		
				removeGameEventListener(stage, MouseEvent.CLICK, removeWinnerCards);
			}
		}
		
		override public function resizeScreen():void 
		{
			
			if (stage)
			{
			

				
				var stageWidth:Number = stage.stageWidth;
				var stageHeight:Number = stage.stageHeight;
				
				 hsf = stageWidth / origWidth;
				vsf = stageHeight / origHeight;
				_fullResizableContainer.height = stageHeight;
				_fullResizableContainer.width = stageWidth;
				
		
			
		       if (_userScreen)
				{
					_userScreen.y = (screenUI.userinfoP.y) * vsf;
					_userScreen.resizeScreen(hsf, vsf);
				}
				
				if (_numberScreen)
				{
					_numberScreen.x = screenUI.ballGeneratorPos.x * hsf;
					_numberScreen.y = screenUI.ballGeneratorPos.y * vsf;
					
					_numberScreen.resizeScreen(hsf,vsf);
				}
				if (smile)
				{
					
					smile.x =  screenUI.announceP.x-smile.width-25;
			        smile.y =  (screenUI.announceP.y)*vsf-35;
					
				}
				
				if (glass)
				{
					glass.x = screenUI.ballGeneratorPos.x*hsf;
		          	glass.y = screenUI.ballGeneratorPos.y*vsf+2;
				}
				
				if (_timerScreen)
				{
					
					_timerScreen.x = screenUI.timerPos.x*hsf;
					_timerScreen.y = screenUI.timerPos.y * vsf;
					_timerScreen.setResize(hsf, vsf);
					
		
				}
				if (winnerObj)
				{
					winnerObj.x = (screenUI.width - winnerObj.width)*hsf/ 2;
				    winnerObj.y = (screenUI.height - winnerObj.height)*vsf/2+4;
				}
				if (allwiner)
				{
						if (winnerObj)
				          {
							  winnerObj.x = (screenUI.width - winnerObj.width*2)*hsf/2;
				             // winnerObj.y = (screenUI.height - winnerObj.height)*vsf/2;
							  allwiner.x = winnerObj.x + winnerObj.width;// (screenUI.width - allwiner.width * 2) * hsf / 2 + winnerObj.width;
				              allwiner.y = (screenUI.height - allwiner.height) * vsf / 2;
							  winnerObj.y = allwiner.y;
						  }
						  else
						  {
					       allwiner.x = (screenUI.width - allwiner.width)*hsf/2;
				           allwiner.y = (screenUI.height - allwiner.height) * vsf / 2;
						  }
				}

				var hsf1:Number = (stageWidth-_userScreen.width1) / (origWidth-_userScreen.width1);
				    var vsf1:Number = stageHeight / origHeight;
				if (_cardContainer)
				{
				
					
					_cardContainer.resize1(hsf, vsf);
					_cardContainer.resizeScreen(hsf1, vsf1);
			    	_cardContainer.x =_userScreen.x+_userScreen.width1;
		            _cardContainer.y = screenUI.containerP.y*vsf+2;
					
				   
				}
				if (_announcement)
				{
			  	         _announcement.resizeScreen(hsf1, vsf1);
						_announcement.x =_userScreen.width1-5*hsf1;
					    _announcement.y = (screenUI.announceP.y+5)*vsf;
				}
				if (ballGen)
				{
					ballGen.x = screenUI.ballGeneratorPos.x * hsf ;
					ballGen.y = screenUI.ballGeneratorPos.y * vsf +2;
				}
				
			
				
				if (_publicChatScreen)
				{
					
					_publicChatScreen.y = screenUI.publicChatP.y*vsf+8;
					_publicChatScreen.resizeScreen(hsf, vsf);
					
				}
				if (_cashRequestScreen)
				{
					_cashRequestScreen.resizeScreen(hsf, vsf);
					 _cashRequestScreen.x = ((stage.stageWidth - _cashRequestScreen.width) / 2)-10 * hsf;
				   _cashRequestScreen.y = ((stage.stageHeight - _cashRequestScreen.height) / 2) * vsf;
				   
				    //_cashRequestScreen.height *= vsf;
				}
				
				if (_soundScreen)
				{
					setSoundScreen(hsf,vsf);
				}
			
			//	trace (this.height, this.width, stage.stageHeight, stage.stageWidth, this.x, this.y);			
			}
		}
		
		private function setSoundScreen(hsf:Number,vsf:Number):void
		{
			if (_soundScreen == null)
				return;
			var localPos:Point = new Point(screenUI.soundP.x * hsf, screenUI.soundP.y * vsf);
			//var localPos:Point = _sizeRetentionContainer.globalToLocal(screenUI.localToGlobal(screenPoint));
			_soundScreen.x = localPos.x;
			_soundScreen.y = localPos.y;
			
		}
		override public function onJoinRoom(evt:SFSEvent):void
		{
			//trace ( " Room Joined");
			var joinedRoom:Room = evt.params.room;
			if (joinedRoom.getName() != "Lobby1")
			{
				//now this screen is to be removed and BingoGame to be added
				var main:Main = this.parent as Main;
				Main.showAlterScreen(joinedRoom);				
			}			
		}
		
		
	
	
	//int [] numberCollection={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75};
	
	private function suffle():void
	{
		for(var i:int=0;i<15;i++)
		{	
		    var temp:int=0;
		   var first:int=(int)(Math.random()*15);
		   // int second=(int)Math.random()*74;
		    temp=numberCollection1[first];
		    numberCollection1[first]=numberCollection1[i];
		    numberCollection1[i]=temp;
		    temp=numberCollection2[first];
		    numberCollection2[first]=numberCollection2[i];
		    numberCollection2[i]=temp;
		    temp=numberCollection3[first];
		    numberCollection3[first]=numberCollection3[i];
		   numberCollection3[i]=temp;
		    temp=numberCollection4[first];
		    numberCollection4[first]=numberCollection4[i];
		    numberCollection4[i]=temp;
		    temp=numberCollection5[first];
		    numberCollection5[first]=numberCollection5[i];
		    numberCollection5[i]=temp;
		    
		}
		fillNumberCollection();
		
	}
	public function fillNumberCollection():void
	{
		numberCollection=new Array(24);
		 var j:int=0;
		for(var i:int=0;i<5;i++)
		{
			numberCollection[j++]= numberCollection1[i];
			numberCollection[j++]= numberCollection2[i];	
			if(i!=2)
			numberCollection[j++]= numberCollection3[i];	
			numberCollection[j++]= numberCollection4[i];	
			numberCollection[j++]= numberCollection5[i];	
			
		}
		
	}
	
	public function removeCashScreen():void
	{
		if (_cashRequestScreen)
			{
				removeChild(_cashRequestScreen);
				 _cashRequestScreen = null;
			}
		
	}
	

		

		
	private function populateFunArray():void
	{		      
		if (_funPlayer == 0)
		{
		    for(var i:int=0;i<15;i++)
			{
				numberCollection1[i]=i+1;
				numberCollection2[i]=15+(i+1);
				numberCollection3[i]=30+(i+1);
				numberCollection4[i]=45+(i+1);
				numberCollection5[i]=60+(i+1);
   		  
			}
				_funPlayer++;
		}			
	}
		
	private function setBottomButtons():void
	{
		
		
		addGameEventListener(screenUI.helpB, MouseEvent.CLICK, gotoHelpAddress);
		addGameEventListener(ballGen.lobbyB, MouseEvent.CLICK, lobbyButtonClicked);
		addGameEventListener(ballGen.soundB, MouseEvent.CLICK, soundButtonClicked);
		addGameEventListener(screenUI.infoB, MouseEvent.CLICK, infoButtonClicked);
		
		
	}
	private function removeWinnerCards(me:MouseEvent):void
	{
		
		//trace("hi listener");
		if (_userScreen)
		_userScreen.removeWinnerCards();
	}
	
	private function gotoHelpAddress(evt:MouseEvent):void
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
		
	private function infoButtonClicked(evt:MouseEvent):void
	{
		
	    SoundPlayer.playSound("buttonClick");
		if (_cashRequestScreen==null)
			{
		         _cashRequestScreen = new CashRequest(this);
		         addChild( _cashRequestScreen);
				  //_cashRequestScreen .x=(screenUI.width- _cashRequestScreen.width)/2
				  // _cashRequestScreen .y=(screenUI.height- _cashRequestScreen.height)/2
				  
			}
			else 
			  removeCashScreen();
			  setForResize();
	}
		
		private function soundButtonClicked(evt:MouseEvent):void
		{
			/*if (_soundScreen)
			{
				removeChild(_soundScreen);
				return;
			}*/
			//else
			//{
			SoundPlayer.playSound("buttonClick");
			   if (_soundScreenEnabled == false)
			   {
					var btn:* = evt.currentTarget;
					_sizeRetentionContainer.addChild(_soundScreen);	
					var stageWidth:Number = stage.stageWidth;
					var stageHeight:Number = stage.stageHeight;
				
					var hsf:Number = stageWidth / origWidth;
					var vsf:Number = stageHeight / origHeight
					setSoundScreen(hsf, vsf);
				
					_soundScreenEnabled = true;
			   }
			   else
			   {
				   _soundScreen.parent.removeChild(_soundScreen);
				   _soundScreenEnabled = false;
			   }
			//}
		}
		public function setFocus(e:MouseEvent):void
	{
	    //trace("focus", e.currentTarget.name);
	      if (e.target.name=="chatInput")
	         {
				 //e.target.parent.parent._screen[e.target.name];
				// trace("name of target",e.target.parent.parent.name,e.target.name);
				currentTargetedChat =e.target.parent.parent._screen[e.target.name];
				if (stage)
					stage.focus =currentTargetedChat;
	         }
	
	}
		public function removeSoundScreen():void
		{
			_soundScreen.parent.removeChild(_soundScreen);
			//_fullResizableContainer.removeChild(_soundScreen);
			_soundScreenEnabled = false;
		}
		//public function gotoGoldenRoom()
		//{
			
	//	}
		
		private function lobbyButtonClicked(evt:MouseEvent):void
		{
			SoundPlayer.playSound("buttonClick");
			 SoundPlayer.stopSound("intro");
			SoundPlayer.muteAll(true);
			Main.setMainLobbyScreen(this);
			
			
		}
		
		override public function initialize():void
		{
			super.initialize();	
			SoundInitializer.playWelcomeSound();
			
			var ci:* = _publicChatScreen._chatInput;
			stage.focus = ci;
			//ci.setSelection(ci.length,ci.length);
		
			setForResize();
			 addGameEventListener(stage, MouseEvent.CLICK, setFocus);

		
		}		

		override public function onExtensionResponse(event:SFSEvent):void
		{
			//_roomInfoArray = new Array();
			var result:*= event.params.dataObj;
			
			var resNum:int = int (result[0]);
			switch (resNum)
			{
				case TIME_LEFT:
					if (_timerScreen)
						_timerScreen.showTimer(result[2]);
						 //showTimerScreen();
				break;
				
				case WinInOtherRoom:
				    var info:Array = result[2].split("@");
				     _publicChatScreen.addChatMessage("myglobalgames"+" "+"-"+" "+GetDisplayObject.getORoomWin1()+" "+info[0]+GetDisplayObject.getORoomWin2()+" "+info[1],true);
				   
				  // PrivateChatManager._pcManager.addChatMessage("myglobalgames", "you win amount" + " " + info[0] + "in" + " " + info[1]);
				    break;
				case GAME_STATE:
				
					var res:Array = result[2].split("$");
				   //  trace ("game id is ++++++++++++++++++++++++++++ ", res[1]);
					 setgameId(res[1]);
					//_funCounter = 0;
					parseGameStateString(res[0]);
				break;
				
				case CARD_NUMBERS:
				if (result[2]!="")
				{
				     if (_cardString.length == 1)
					 {
					       _cardString = result[2];
					 }
					else
					{
					     _cardString += ";" + result[2];
					}
					
				
			
					if (_cardBuyScreen)
						_cardBuyScreen.enableScreen(_numCards);
				}
				break;
				
				case PLAYER_LIST:
				// trace("player update",result[2])
				 // updatePlayerList(result[2]);
				  _userScreen.updatePlayerList(result[2]);
				  
				  break;
				
				case PLAYER_JUST_ADDED:
				 //    ulist.setuserInGame(result[2], 1);
					 _userScreen.setUserInGame(result[2], 1);
				  // PlayerInGameArray.push(result[2]);
				   //trace("setUser in GAME_STATE called...................................................",result[2]);
				break;
				
				case NEW_NUMBER:
			//	trace ("hjsdd new number",result[2]);
			
			      if(_numberScreen)
					_numberScreen.showNumberBall(result[2]);
				  balls++;

				

					if (_cardContainer)
					{
				    	_cardContainer.setListener(result[2]);
					}
					
				//	showGoldenTime();


				break;
				
				case FIRSTLINE_WINNER:
				  
					var splitArray:Array = result[2].split(":");
				    //trace("patWinnert--------------------------->", result[2]);
				    //screenUI.famount.text = "GEVALLEN";
				   _userScreen.setFamt("GEVALLEN");
					setBingoWinner(splitArray, "1");
					
					//winnerScr(splitArray,"1");
					
					var nameArray:Array = splitArray[0].split(",");
					
					for (var i:int = 0; i < nameArray.length; i++ )
					{
						var obj:Object = new Object();
						obj.name = nameArray[i];
						obj.id = "1";
						objArray.push(obj);
					}
						 if (currentTargetedChat)
			         {
			             stage.focus = currentTargetedChat;	
			          }
					//trace(objArray);
				break;
				case SECONDLINE_WINNER:
				  // trace("patWinnert--------------------------->")
					var splitArray1:Array = result[2].split(":");
				//	screenUI.samount.text = "GEVALLEN";
				_userScreen.setSamt("GEVALLEN");
				//	winnerScr(splitArray1,"2");
					setBingoWinner(splitArray1, "2");
					var nameArray1:Array = splitArray1[0].split(",");
					for (var ii:int = 0; ii < nameArray1.length; ii++ )
					{
						var obj1:Object = new Object();
						  obj1.name = nameArray1[ii];
						  obj1.id = "2";
						objArray.push(obj1);
					}
					 if (currentTargetedChat)
			          {
			    stage.focus = currentTargetedChat;	
			              }
			
				break;
				
				case BINGO_WINNER:
				    balls = 0;
				// trace("bingoWinnert--------------------------->")
				_userScreen.setVamt("GEVALLEN");
					var splitArray11:Array = result[2].split(":");
				//	winnerScr(splitArray11, "V");
					setBingoWinner(splitArray11, "V");
					var nameArray11:Array = splitArray11[0].split(",");
					//trace("name array is traced((((((((((((((((((((",nameArray11);
					for (var iii:int = 0; iii < nameArray11.length; iii++ )
					{
						var obj11:Object = new Object();
						obj11.name = nameArray11[iii];
						obj11.id = "V";
						objArray.push(obj11);
					}
					//trace("object array",objArray);
					setAllWinner(objArray);
				    	 if (currentTargetedChat)
		            	{
			            stage.focus = currentTargetedChat;	
			           }
				    break;	
				case Balance_info:
				   var splitArray2:Array = result[2].split(",");
				     setBalance(splitArray2);
				   break;
				case BUserList:
					IgnoreUserManager.parseIgnoreString(result[2]);
					
				 break;
				 case WelcomeMsg:
				// trace("msg from server", result[2], "yes");
				 _publicChatScreen.addChatMessage(""+"-"+result[2],false);
				break;
				case JackpotTime:
				      //trace("msg from server about date", int(_joinedRoom.getVariable("rid")), "yes");
					 if (int(_joinedRoom.getVariable("rid"))!=25)
					  {
						 // trace();
					   //  _goldenTimeText = Number(result[2]);
						// trace("golden timer", result[2] );
					     // showGoldenTime();
					  }
									   
				break;
				case moveToLobby:
				goToLobby();
				  break;
				case DyanamicBonus:
				 //_publicChatScreen.addChatMessage("-1"+": "+result[2],false);
				break;
				case AdminMsgToAll:
				   _publicChatScreen.addChatMessage(""+"-"+result[2],false);
				break;
				case BanFromChat:
				chatStatus = int(result[2]);
				break;
				case AdminPersonalMsg:
				  // PrivateChatManager._pcManager.addChatMessage("", result[2]);
				_publicChatScreen.addChatMessage(""+"-"+result[2],false);
				break;
				case  setBackground:
				//trace("Loader is called" );
				 // FileLoader.loadFile(result[2], loadGame);
				break;
				
				case 511:
				    setgameId(result[2]);
				break;
				case _cashResponse:
				//trace("hihhihiiiiiiiiiiiiiiiiiiiiiiiiiiBGS");
				  if (_cashRequestScreen)
				  {
				    _cashRequestScreen.addCash(result[2]);
				  }
				  break;
				  
			     case _cashBackResponse:
								//trace("hihhihiiiiiiiiiiiiiiiiiiiiiiiiiiBGS");
				  if (_cashRequestScreen)
				  {
				    _cashRequestScreen.updateCash(result[2]);
			      }
				  break; 
								
			}
			//trace ("Response from server ", result[0]);
		}
		public function goToLobby():void 
		{
			Main.setMainLobbyScreen(this);
			
		}
		public function setgameId(str:String):void
		{
			screenUI.gameID.text = "#" +str;
		}
		public function showGoldenTime():void
		{
			//return;
			 //_publicChatScreen.addChatMessage("-1"+":"+GetDisplayObject.getBalanceRequestURL(),false);
			//trace(_goldenTimeText, "dwijendra");
			
			 myTimer = new Timer(1000); // 1 second
             myTimer.addEventListener(TimerEvent.TIMER, showTimer);
			
               myTimer.start();

		}
		private function setAllWinner(objArr:Array):void
		{
			var nameA:Array = new Array();
			var idA:Array = new Array();
			for (var i:int = 0; i < objArr.length; i++)
			{
				nameA[i] = objArr[i].name;
				idA[i] = objArr[i].id;
			}
			objArray = new Array();
			removeAllwinnerScreen();
			 allwiner = new AllWinnerScreen(nameA, idA,_maxRound-roundno,removeAllwinnerScreen);
						 
  			  if (objArray.length > 3)
			  allwiner.height +=  ((objArray.length - 2) * 35);
			  if (winnerObj)
			  {
			   allwiner.x = winnerObj.x+winnerObj.width;
			   allwiner.y = (screenUI.height - allwiner.height) / 2;
			  }
			  else {
				    allwiner.x = (screenUI.width - allwiner.width)/2+100;
			        allwiner.y = (screenUI.height - allwiner.height) / 2;
			  }
			 addChild(allwiner);
			// _currentRound++;
			 setForResize();
		}
	
		
		public function showTimer(event:TimerEvent):void
		{
			//trace("show timer value..........", _goldenTimeText);
			if (_goldenTimeText > 0)
			{
			//	screenUI.gotoJackpot_btn.goldenTime.visible = true;
			 var hour:uint = uint(_goldenTimeText / 3600);
			 var rest:uint = uint(_goldenTimeText) % 3600;
			 var minute:uint = rest / 60;
			   var second:uint = rest % 60;
		
			   if (second < 10)
			   {
				   var str1:String = "male" + second;
				   var str2:String = "female" + second;
					if(SoundScreen._femaleSounDClicked)
						SoundPlayer.playSound(str2);
					else
						SoundPlayer.playSound(str1);
				  screenUI.gotoJackpot_btn.goldenTime.text =  hour.toString()+":"+minute.toString() + ":0" + second.toString();
			   }
			   else
			   {
				   screenUI.gotoJackpot_btn.goldenTime.text = hour.toString()+":"+ minute.toString() + ":" + second.toString();
			   }
			
			   _goldenTimeText--;
			
		    }
			else 
			{
				  myTimer.stop();
				  screenUI.gotoJackpot_btn.goldenTime.visible = false;
			}
		}

		
		//Function called from number screen after ball is stopped
		public function markNumberAfterBallStops(num:int):void
		{
			if (_cardContainer)
			{
				_cardContainer.markNumberInCards(num.toString());
				
			}
			if (_ballScreen)
			{				 
				_ballScreen.showball(num.toString());
				
				  
				  ballGen.ballsPassed.text = balls;	
			}
		}
		private function removeWinnerObj():void
		{
			if (winnerObj)
			{
			removeChild(winnerObj);
			winnerObj = null;
			}
			
		}
		private function removeAllwinnerScreen():void
		{
			//trace("kya aaya jhhhhhhhhhhhhhhhhh")
			if (allwiner && this.contains(allwiner))
			{
				removeChild(allwiner)
				allwiner = null;
			}
		}
	    private function addInChat(winId:String,count:int,amt:Number,Name:String):void
		{
			 //_publicChatScreen.addChatMessage("" + "-" + "hi how are u", false);
			 //trace("hi chat ingfo ", count, amt)
			 var arr:Array = (amt * count).toFixed(2).split(".");
			 var str:String;
			 if (int(arr[1]) == 0)
			 arr[1] = "-";
			str = arr[0] + "," + arr[1];
			 
			if (winId=="1")
			{
				 _publicChatScreen.addChatMessage("" + "-" + GetDisplayObject.winAnnounceP1() + Name + GetDisplayObject.fwinAnnounceP2() +str, false);
			}
		    if (winId=="2")
			{
			_publicChatScreen.addChatMessage("" + "-" + GetDisplayObject.winAnnounceP1() + Name + GetDisplayObject.swinAnnounceP2() +str, false);	
			}
			if (winId=="V")
			{
				_publicChatScreen.addChatMessage("" + "-" + GetDisplayObject.winAnnounceP1() + Name+ GetDisplayObject.bwinAnnounceP2() +str, false);
			}
		}
	
		private function setBingoWinner(splitArray:Array,winId:String):void
		{    var currentX:Number =(screenUI.width-570)/2;
			var currentY:Number = (screenUI.height-420)/2;
			var position:Number = 0.0;
			var NoOfWinningCards:Array=splitArray[5].split(",");
			var totalNoOfCardArray:Array = splitArray[2].split(",");
			var nameArray:Array = splitArray[0].split(",");
			var bingoCardArray:Array = splitArray[1].split(";");
			var count:int = 0;
			var name:String = nameArray[0];
			 var obj:Object=new Object();
			obj["1"] = 3;
			obj["2"] = 4;
			obj["V"] = 5;
			
		    if(winnerObj)
		       removeWinnerObj();
			
	     	    winnerObj = new WinnerScreen(splitArray, winId,removeWinnerObj);
				addChild(winnerObj);
				winnerObj.x = (screenUI.width - winnerObj.width) / 2;
				winnerObj.y = (screenUI.height - winnerObj.height)/2;
		        setstate(splitArray, (int)(obj[winId]));
			for (var i:int = 0; i < nameArray.length;++i )
			{
			
			
			if (name == nameArray[i])
				{
					count++;
				}
				else
				{
			     addInChat(winId,count,Number(splitArray[4]),name);
				 count = 1;
				 name = nameArray[i];
				}
		     
			}
			  addInChat(winId,count,Number(splitArray[4]),name);
			//_cardString = "1";
			if (SoundScreen._femaleSounDClicked)
			{
			    SoundPlayer.playSound("femaleBingoMusic");
			}
			else
			{
			   SoundPlayer.playSound("maleBingoMusic");
			}
		//	_btnHandler.enableAllButtons(true);
			//_btnHandler.enableButton(automate, false);
			
			if(winId=="V")
			_timeIntervalId = setTimeout(removeAllBall, 3000);
			setForResize();
			
		}
		/*private function setBingoWinner(splitArray:Array,winId:String):void
		{   var currentX:Number =(screenUI.width-570)/2;
			var currentY:Number = (screenUI.height-420)/2;
			var position:Number = 0.0;
			var count:int = 0;
			
			//var currentX:Number =screenUI.userList.x;
			//var currentY:Number = screenUI.userList.y-50;
			//var position:Number = 0.0;
		//	var NoOfWinningCards:Array=splitArray[5].split(",");
		//	var totalNoOfCardArray:Array = splitArray[2].split(",");
			var nameArray:Array = splitArray[0].split(",");
		//	var bingoCardArray:Array = splitArray[1].split(";");
			 var arr:Array=new Array();
			arr["1"] = 3;
			arr["2"] = 4;
			arr["V"] = 5;
			 if(winnerObj)
		       removeWinnerObj();
			
			   var winnerObj:WinnerScreen = new WinnerScreen(splitArray,winId,removeWinnerObj);
				
				addChild(winnerObj);
				
			 setstate(splitArray, (int)(arr[winId]));
			for (var i:int = 0; i < nameArray.length;++i )
			{
				//trace ("Total recieved balls is ", totalRecievedBalls);
			
			
				if (i%2==0 && i!=0)
					{
						currentY += _winnerScreenHeight;
					}	
				if (i%2==0)
				{
				      winnerObj.x = currentX;
				      winnerObj.y = currentY;
				     position =_winnerScreenWidth;
				}
				else
				{
					winnerObj.x = currentX-position;
				    winnerObj.y = currentY;
				}
				
				if (name == nameArray[i])
				{
					count++;
				}
				else
				{
			     addInChat(winId,count,Number(splitArray[4]),name);
				 count = 1;
				 name = nameArray[i];
				}
			
			}
			 addInChat(winId, count, Number(splitArray[4]), name);
			 
			//_cardString = "1";
			if (SoundScreen._femaleSounDClicked)
			{
			    //SoundPlayer.playSound("femaleBingoMusic");
			}
			else
			{
			  // SoundPlayer.playSound("maleBingoMusic");
			}
		//	_btnHandler.enableAllButtons(true);
			//_btnHandler.enableButton(automate, false);
			if(winId=="V")
			_timeIntervalId = setTimeout(removeAllBall, 3000);
		}*/
		private function removeAllBall():void
		{
			if(_numberScreen)
			_numberScreen.removeAllBall();
			
			setForResize();
			
			//_cardContainer = new CardContainer();
			clearTimeout(_timeIntervalId);
			
		}
		
		private function setstate(sa:Array,type:int):void
		{
			//trace("set state is called;;;;;;;;;;;;;;;;...............>>>>>>>>>>",sa);
			/*var nameArray:Array = sa[0].split(",");
			var winnigCardArray:Array = sa[1].split(",");
			var totalCardArray:Array = sa[2].split(",");
			var winAmount:String= sa[3];
			if (nameArray[0] != "")
			{
				for (var i:int = 0; i < nameArray.length; i++ )
				{
				//	ulist.setWinner(nameArray[i], int(winnigCardArray[i]), totalCardArray[i], winAmount, type);
					
				}				
			}	*/		
			
			_userScreen.setWinnerFun(sa, type);
		}
		
	
		
		private function parseGameStateString(sstring:String):void
		{
			
						
			 var sentBalls:Array=new Array();
			var sa:Array = sstring.split("@");
		
			var fwinnerArray:Array = sa[0].split(":");
			fwinnerArray[fwinnerArray.length]=sa[4];
			//trace("pattern fwinner info", fwinnerArray);
		//	
			var swinnerArray:Array = sa[1].split(":");
			swinnerArray[swinnerArray.length]=sa[4];
			//trace("bingo swinner info", swinnerArray);
			var vwinnerArray:Array = sa[2].split(":");
			vwinnerArray[vwinnerArray.length]=sa[4];
			//trace("bingo vwinner info", vwinnerArray);
			
			
					
			if ( sa.length>5)
			{
		
				
				
		        _cardString = sa[5];
				addNewCardContainer();
				//cardHandler();
				var generatednumbers:Array = sa[4].split(",");
				if (generatednumbers)
				{
				      for (var s:int = 0; s < generatednumbers.length;s++ )
				      {
					     _cardContainer.markNumberInCards(generatednumbers[s]);
				       }
				}
				
				
				//trace("before adding",sa[5]);
			 // _numCards=_cardContainer.addCards(sa[5]);
			//	_cardContainer.showPatternsInCards(sa[2]);
			//	_btnHandler.enableButton(automate, true);
			//	_btnHandler.enableButton(funPlay,false);
				
				if (_cardContainer)
				
				{
				//	_btnHandler.enableButton(automate,true);
					if (sentBalls.length > 0)
					{
						for (var i:int = 0; i < sentBalls.length;++i )
						{
						//	_cardContainer.markNumberInCards(sentBalls[i]);
						//	_ballScreen.showball(sentBalls[i]);
						}
					}
				
				}	 
				//	screenUI.autoState.gotoAndStop(int(sa[6]));
		
			}
			balls = int(sa[3]);
			ballGen.ballsPassed.text = balls;
			//trace(sa[3], "no of balls sends")
			//trace(sa[5],"no of balls sends")
		objArray = new Array();
		
			if (fwinnerArray[0] != "")
			{
			//	trace("farray", fwinnerArray[0]);
			  setstate(fwinnerArray , 3);
			  _userScreen.setFamt("GEVALLEN");
	
			  var nameArray:Array = fwinnerArray[0].split(",");
		
			  for (var i0:int = 0; i0 < nameArray.length; i0++ )
					{
						
						var obj:Object = new Object();
						obj.name =  nameArray[i0];
						obj.id = "1";
						objArray.push(obj);
					}
			
			}
			else {
			var st:String = setAmount(amtArr["1"]);
			_userScreen.setFamt(st);
			}
			if (swinnerArray[0] != "")
			{
		
			   setstate(swinnerArray, 4);
			 //  screenUI.samount.text = "GEVALLEN";
			 _userScreen.setSamt("GEVALLEN");
			    var nameArray1:Array = swinnerArray[0].split(",");
			   for (var i1:int = 0; i1 < nameArray1.length; i1++ )
					{
						var obj1:Object = new Object();
						obj1.name =  nameArray1[i1];
						obj1.id = "2";
						objArray.push(obj1);
					}
			  
			}
			else {
				var st1:String = setAmount(amtArr["2"]);
			      _userScreen.setSamt(st1);
				
			}
			if (vwinnerArray[0] != "")
			{
				//trace("varray", vwinnerArray[0]);
				_userScreen.setVamt("GEVALLEN");
			   setstate(vwinnerArray, 5);
			   var nameArray2:Array = vwinnerArray[0].split(",");
			    for (var i2:int = 0; i2 < nameArray2.length; i2++ )
					{
						var obj2:Object = new Object();
						obj2.name =  nameArray2[i2];
						obj2.id = "V";
						objArray.push(obj2);
					}
					setAllWinner(objArray);
					
			}
			else {
				//screenUI.vamount.text = amtArr["V"];
			}
		//	}
			
		
		
			
		}
		private function updatePlayerList(str:String):void
		{
			PlayerInGameArray = new Array();
			PlayerInGameArray = str.split(",");
			//trace("player in game array.........................",PlayerInGameArray);
			 makeList();
			
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
			}
			if (PlayerInGameArray.length>=1)
			{
				//trace("hit 0000000Area im in else part of the code++++++++++++");
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
					//trace(typ,"((((((((((((((((((((((((((((((((((((((((((((type");
				
				}
				
			}
			else
			{
				trace("hit 0000000Area im in else part of the code++++++++++++");
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
					  var obj3:Object = { name:PlayerInGame[j], type:"2" };
						_totalUserArray.push(obj3);
				
				}
			}
		
			if (_totalUserArray[_totalUserArray.length - 1] == "")
			{
				_totalUserArray.splice([_totalUserArray.length - 1], 1)
				
			}
									
		}
				
		private function setRoomPropertiesFromVariables(roomVars:Array):void
		{
			var rndChange:Boolean = false;
			//var roomVars:Array = _joinedRoom.getVariables();
			for (var varName:String in roomVars)
			{
				//trace(varName,roomVars[varName],"#################################################");
				if ( varName == "Crnd")
				{
					//trace ( "round is ", roomVars[varName], _joinedRoom.getVariable(varName));
					rndChange = true;
					roundno = int(_joinedRoom.getVariable(varName));
					ballGen.roundNo.text =roundno;
				}
				 else if ( varName == "mrnd")
				{
					//trace ( "round is ", roomVars[varName], _joinedRoom.getVariable(varName));
					rndChange = true;
				    _maxRound = int(_joinedRoom.getVariable(varName));
					ballGen.roundNo.text =roundno;
				}
				else if ( varName == "bpass")
				{
					//trace ( "Balls Passed are ", roomVars[varName]);
					balls = int(_joinedRoom.getVariable(varName));
					ballGen.ballsPassed.text =balls;
				//	if (screenUI.showBallsPassed_btn["ballsPassed"].text == "1")
					{
				//		SoundPlayer.playSound("gameMusic", 0, false);
					}
				}
				else if ( varName == "rs")
				{
					
					var intStatus:int = int (_joinedRoom.getVariable(varName));
					//trace ( "Room State is ", intStatus);
					_gameState = intStatus;
					//trace(_gameState,"state")
					if (intStatus == 1)
					{
				
						showTimerStateScreens();
						ballGen.ballsPassed.text = 0;
						if (_userScreen)
						{
						   _userScreen.refreshWinnerList();
						}
					}
					else
					{
					     SoundPlayer.playSound("intro");
						showGameStateScreens();						
					}
				}
				else if ( varName == "mcp")
				{
					
					_maxCards = int(_joinedRoom.getVariable(varName));
					
				}		
				else if ( varName == "bwa")
				{
					
				//	_gameAmountSymbol["bingoAmount"].text = Number(_joinedRoom.getVariable(varName)).toFixed(2);
				}
				else if ( varName == "pwa")
				{
					//trace ( "Pattern win amount is  ", roomVars[varName]);
					//_gameAmountSymbol["patternAmount"].text = Number(_joinedRoom.getVariable(varName)).toFixed(2);
				}
				else if ( varName == "p1")
				{
					
					//amtArr["1"] = getCurrenRoundPrize(String(_joinedRoom.getVariable(varName)));
					//var st:String = "€ "+amtArr["1"]+",-";
			          // _userScreen.setFamt(st);
					  _prize1Array = String(_joinedRoom.getVariable(varName)).split(";");
				
					
				}
				else if ( varName == "p2")
				{
					
					//amtArr["2"] =  getCurrenRoundPrize(String(_joinedRoom.getVariable(varName)));
					//st = "€ "+amtArr["2"]+",-";
			            // _userScreen.setSamt(st);
						 _prize2Array = String(_joinedRoom.getVariable(varName)).split(";");
				
				}
				else if ( varName == "p3")
				{
					//amtArr["V"] = getCurrenRoundPrize(String(_joinedRoom.getVariable(varName)));
					//st = "€ "+amtArr["V"]+",-";
			            // _userScreen.setVamt(st);
						 _prize3Array = String(_joinedRoom.getVariable(varName)).split(";");
				
					
				}
				else if ( varName == "chatst")
				{
					//amtArr["V"] = getCurrenRoundPrize(String(_joinedRoom.getVariable(varName)));
					//st = "€ "+amtArr["V"]+",-";
			            // _userScreen.setVamt(st);
						 _RoomChatSt = int(_joinedRoom.getVariable(varName));
				
					
				}
				else if (varName == "announcement")
				{
					if (_announcement)
					{
					  removeChild(_announcement);
					  _announcement = null;
					}
					else
					{
						
						_announcement = new RunningText( _joinedRoom.getVariable(varName));
					 
						_sizeRetentionContainer.addChild(_announcement);
						//_fullResizableContainer.addChild(_announcement);
						_announcement.x =_userScreen.width1-20;
						//_announcement.y = _userScreen.y+BingoBook._cardHeight;
					
						setForResize();
						
					}
				
				}
				else if ( varName == "jAmt")
				{
					
					//_gameAmountSymbol["jAmount"].text = _joinedRoom.getVariable(varName);
				}
				else if ( varName == "jBall")
				{
				
					//_gameAmountSymbol["jBalls"].text = _joinedRoom.getVariable(varName);
				}
			}
			if (rndChange)
			{
				if (roundno==0)
				{
					getCurrenRoundPrize(1);
				}
				else
				{
					getCurrenRoundPrize(roundno);
				}
			}
		}
		private function getCurrenRoundPrize(crn:int):void
		{
			trace(_prize1Array[crn - 1], _prize2Array[crn - 1], _prize3Array[crn - 1], "amount array");
			
			amtArr["1"] = Number(_prize1Array[crn-1]);
			var st:String = setAmount(amtArr["1"]);
			_userScreen.setFamt(st);
			amtArr["2"] = Number(_prize2Array[crn-1]);
			st =setAmount(amtArr["2"]);
			 _userScreen.setSamt(st);
			 amtArr["V"] =Number(_prize3Array[crn-1]);
			 st = setAmount(amtArr["V"]);
			  _userScreen.setVamt(st);
			
		}
		private function setAmount(amt:Number):String
		{
			var str:String = "";
			str = amt.toFixed(2);
			var arr:Array = str.split(".");
			if (int(arr[1]) == 0)
			 arr[1] = "-";
			str = "€ "+arr[0] + "," + arr[1];
			return str;
		}
		
		
		public function addFunPlayer():void
		{
			       populateFunArray();
			
					var temp:int = 0;
					var num:String = "";
					suffle();
					fillNumberCollection();
			
			for (var k:int = 0; k < 24; k++)
			{
				
				if (k == 0)
				{
				   num = numberCollection[k];
				}
			    else
				{
				  num = num + "," + numberCollection[k];
				}
			
			}
		//	_cardContainer.addCards(num);
		//	_cardContainer.showPatternsInCards(_patterString);
		
		}
		
		override public function onRoomVariableUpdate(evt:SFSEvent):void
		{
			//_joinedRoom = evt.params.room;
			//rid --- Room Number
			//mp ----- Max Players
			//cp ----- Card Price
			//rd ----- Room Description
			//bpass ----- Balls Passed
			//cpl   ----- Current Players
			//rs    -----  Room State
			//mcp   ----- Max Cards Per Player
			var changedVars:Array = evt.params.changedVars;
	
			setRoomPropertiesFromVariables(changedVars);
		}
		/*override public	function onUserVariablesUpdateHandler(evt:SFSEvent):void
		{
			_joinedUser = evt.params.user;
			
			if (_joinedUser.getVariable("name") == Main._userName)
			{
				var changedVars:Array = evt.params.changedVars;
				setuserPropertyFromVariable(changedVars);
			}
			
		}*/
		public function setBalance(balanceA:Array):void
		{						 
	      
			screenUI.cashAmount.text ="€ "+  Number(balanceA[0]).toFixed(2);
			screenUI.gameAmount.text ="€ "+ Number(balanceA[1]).toFixed(2);
			_gameAmount = (Number(balanceA[0]) + Number(balanceA[1])).toString();
			total_Amount = Number(balanceA[0]) + Number( balanceA[1]);
		}

	    override public function onUserEnterRoom(evt:SFSEvent):void
		{
			
			var i:int = 0;
			if(int(evt.params.user.getVariable("Utype"))==1)
			{
				i = 10;
			}
	          
			
			_userScreen.setUserInGame(evt.params.user.getName(), i);
				 if (currentTargetedChat)
			{
			    stage.focus = currentTargetedChat;	
			}
									
		}
		override public function onUserLeaveRoomHandler(evt:SFSEvent):void
		{
		
			_userScreen.setUserInGame(evt.params.userName, 3);
				 if (currentTargetedChat)
			{
			    stage.focus = currentTargetedChat;	
			}
		}
		private  function makeList():void
		{
			onLineUserList = new Array();
			
		     var users:Array = _joinedRoom.getUserList();
			// _nameIdMap = new Object();
			 
			for (var u:String in users)
			{				
				onLineUserList.push(users[u].getName());
			}
		
		//	trace("list",onLineUserList);
			DisplayPlayerList();
			
		}
		
		public function getUserType(name:String):int
		{
			var user:User = _joinedRoom.getUser(name);
			if (user)
			{
				var i:int = int(user.getVariable("Utype"));
				return i;
			}
			else
			{
			    return 0;	
			}
		}
		
		public function getIdFromUserName(name:String):int
		{
			var user:User = _joinedRoom.getUser(name);
			if (user)
				return user.getId();
			return -1;	
			
		}
		
		
		private function removeEarlierScreens():void
		{
			if (_numberScreen)
				_numberScreen.removeScreen();
			_numberScreen = null;
			

			
			
			_numberScreen = new NumberGenerationScreen(this);
			_numberScreen.x = screenUI.ballGeneratorPos.x ;
			_numberScreen.y = screenUI.ballGeneratorPos.y;
			_sizeRetentionContainer.addChildAt(_numberScreen,1);
			//_numberScreen.x = 1024;
			//_numberScreen.addChild(_gameAmountSymbol);
		//	_sizeRetentionContainer.addChild(_gameAmountSymbol);
			
			
			
			if (stage)
			{
				//_numberScreen.x = stage.stageWidth;
				//_numberScreen.addChild(_gameAmountSymbol);
			//	addChild(_gameAmountSymbol);
			//	_gameAmountSymbol.x = stage.stageWidth;
			}
			
			//if (_newNumGenerator)
			//	screenUI.removeChild(_newNumGenerator);
			
			//_newNumGenerator = null;
			
			if (_timerScreen)
				_timerScreen.removeScreen();				
			_timerScreen = null;
		
			setForResize();
		}
		

		
		private function showNumberGenerationScreen():void
		{
			removeEarlierScreens();
			//_numberScreen = new NumberGenerationScreen(screenUI.numGenerator);
			//screenUI.numGenerator.visible = false;
			//_newNumGenerator = new Resources.ballGenerator();
			//screenUI.addChild(_newNumGenerator);
			//_newNumGenerator.x = screenUI.numGenerator.x;
			//_newNumGenerator.y = screenUI.numGenerator.y;			
			//_numberScreen = new NumberGenerationScreen(_newNumGenerator.numGenerator);
			//_numberScreen = new NumberGenerationScreen();
			//_numberScreen.x = screenUI.numGenerator.x;
			//_numberScreen.y = screenUI.numGenerator.y;
			//addChild(_numberScreen);
			//addChild(_numberScreen);			
		}
		
		private function enableTimerStateButtons():void
		{	
			//_btnHandler.enableButton(0, false);
		}
		
		private function enableGameStateButtons():void
		{			
		}
		
		private function addNewCardContainer():void
		{
			if (_cardContainer)
			{
				_cardContainer.closeWCscreen();
				_cardContainer.removeScreen();
			}
				_cardContainer = null;
			_cardContainer = new CardContainer2(_cardString);
		//trace("Card string");
			_sizeRetentionContainer.addChild(_cardContainer);
	      //  _fullResizableContainer.addChild(_cardContainer);
		     // screenUI.addChild(_cardContainer);	
			_cardContainer.x =_userScreen.x+_userScreen.width1;
		    _cardContainer.y = screenUI.containerP.y;
			setForResize();
			_announcement.cardHandler(_cardContainer);
			
		}
		
		private function changeState(state:int):void
		{
			//trace("",state ,"is")
			_currentState = state;
			switch (state)
			{
				case TIMER_STATE:
					showTimerStateScreens();
					break;
					
				case GAME_STATE:
					showGameStateScreens();
					break;
			}
			//setForResize();
		}
		//override public function onJoinRoom(evt:SFSEvent):void
		 //{
			// trace("onjoined room is called$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
			// makeList();
			 
		// }
		
		private function showGameStateScreens():void
		{
			  
			//SoundPlayer.playSound("intro");
			_ballScreen = new BallScreen(this);
			showNumberGenerationScreen(); 
		}
		
		private function showTimerStateScreens():void
		{
			//_ballScreen = null;
			
			showTimerScreen();
			if (_ballScreen && _ballScreen.parent)
			{
				removeChild(_ballScreen);
			}
			_ballScreen = null;
			//addNewCardContainer();
		
			//enableTimerStateButtons();
		}
		
		private function showTimerScreen():void
		{
			
			removeEarlierScreens();
			//screenUI.numGenerator.visible = true;
			//screenUI.numGenerator.numGenerator.gotoAndStop(1);
			_timerScreen = new GameTimerScreen();
			_sizeRetentionContainer.addChild(_timerScreen);
			
			//_timerScreen.x = ;400;
			_timerScreen.x = screenUI.timerPos.x;
			_timerScreen.y = screenUI.timerPos.y;
		}
		
		public function sendGetStateRequest():void
		{
			var sendParam:Array=["2"];
			//sendParam.values = [numBet.toString(), payLine.toString()];
			//trace (sfs.isConnected , " Is connected");
			SfsMain.sfsclient.sendXtMessage("gameExt", "2",sendParam,"str");
		}
		
		public function showCardBuyScreen():void
		{	
			if (_cardBuyScreen==null)
			{
			_cardBuyScreen = new BuyCardsScreen(_numCards,_maxCards,this);
			addChild(_cardBuyScreen);
			_cardBuyScreen.x = (screenUI.width - _cardBuyScreen.width)/2;
			_cardBuyScreen.y = (screenUI.height - _cardBuyScreen.height) / 2;
			}
			//_cardBuyScreen.y = screenUI.winnerP.y;
			
		}
		public function showBallScreen():void
		{
			//_ballScreen = new BallScreen(this);
			addChild(_ballScreen);
			_ballScreen.x = screenUI.ballSP.x;
			_ballScreen.y = screenUI.ballSP.y;
		}
		public function setAutomate():void
		{
			var sendParam:Array=[ServerConstants.SET_AUTOMATE];
			SfsMain.sfsclient.sendXtMessage("gameExt", ServerConstants.SET_AUTOMATE, sendParam, "str");
			if(_automate==1)
			     _automate = 2
			 else
			    _automate = 1;
				screenUI.autoState.gotoAndStop(_automate);
			
		}
		
		public function removeCardsBuyScreen():void
		{
			if (_cardBuyScreen)
			{
			_cardBuyScreen.removeScreen();
			_cardBuyScreen = null;
			}
		}
		public function removeBallScreen():void
		{
			//_ballScreen.removeScreen();
			removeChild(_ballScreen);
			//_ballScreen = null;
		}
		
		override public function onPublicMessageHandler(evt:SFSEvent):void
		{
		//	trace("User " + evt.params.sender.getName() + " said: " + evt.params.message);
			var userVar:User = evt.params.sender;
			var uType:int = int(userVar.getVariable("Utype"));
			var isUserAdmin:Boolean = false;
			if (uType == 1)
				isUserAdmin = true;
				if (IgnoreUserManager.isUserBlocked(userVar.getName()))
				return;
			//trace (" Is user admin ", isUserAdmin,MainLobbyScreen._UserType);	
			_publicChatScreen.addChatMessage(evt.params.sender.getName() + "-" + evt.params.message,isUserAdmin);
		}
		
		override public function onPrivateMessageHandler(evt:SFSEvent):void
		{
			//trace("User " + evt.params.sender.getName() + " sent the following private message: " + evt.params.message);
			if (evt.params.sender.getName() == Main._userName)
		    return;
			PrivateChatManager._pcManager.addChatMessage(evt.params.sender.getName(), evt.params.message);
		
		}
		
		public function getPrivateChatPos():Point
		{
			var rPoint:Point = new Point(screenUI.publicChatP.x, screenUI.publicChatP.y);
			if (stage)
			{				
				var stageWidth:Number = stage.stageWidth;
				var stageHeight:Number = stage.stageHeight;
			
				
				var hsf:Number = stageWidth / origWidth;
				var vsf:Number = stageHeight / origHeight;
				rPoint.x *= hsf;
				rPoint.y *= vsf;
			}
			return rPoint;
		}
				
				
				
			
		
	}

}