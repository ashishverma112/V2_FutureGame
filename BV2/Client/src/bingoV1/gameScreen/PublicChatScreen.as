package bingoV1.gameScreen 
{
	import bingoV1.gameScreen.PrivateChatManager;
	import flash.display.Sprite;
	import gameCommon.screens.BaseScreen;
	import flash.events.MouseEvent;
	import multiLanguage.ResizeableContainer;
	import multiLanguage.LanguageXMLLoader;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.TextFieldAutoSize;
	//import CustomSlider;
	import gameCommon.customUI.ScrollPane;
	import gameCommon.smartFoxAPI.SfsMain;
	import flash.events.FocusEvent;
	import flash.text.TextFieldType;
	import gameCommon.lib.ChatRenderer;
	 import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	import bingoV1.lobbyScreen.MainLobbyScreen;
	/**
	 * ...
	 * @author Siddhant
	 */
	public class PublicChatScreen extends BaseScreen
	{
		//private var _userName:String;
		private var _bingoScreen:BingoGameScreen;
		private var _scrollPane:ScrollPane;
		private var _chatOnOffScreen:*;
		private var _chatEnabled:Boolean;
		public var _chatInput:*;
		private var _chatRenderer:ChatRenderer;
		private var format:TextFormat; 
		//public var chatin:Sprite;
		//private var 
		public var _screen:*;
	    private var _visibleHieght:Number=240;
		private var _visibleWidth:Number=180;
		public var emosStr:String = "";  
		private var hsf1:Number;
		private var vsf1:Number;
		public static var _height:Number;
		//------------------------var for smilechat--------------------------------
		public function PublicChatScreen() 
		//public function PrivateChatScreen(userName:String) 
		{
			//_bingoScreen = bs;
			screenUI = new Resources["publicChatScreen" + MainLobbyScreen._bgcolor]();
			 _screen = screenUI;
		/*	var textSymbol:Sprite = GetDisplayObject.getSymbol("publicChatScreenText");
			textSymbol.name = "textSymbol";
			screenUI.addChild(textSymbol);
			textSymbol.x= screenUI.txtP.x;
			textSymbol.y=screenUI.txtP.y;*/
			
			 // screenUI = GetDisplayObject.getSymbol("publicChatScreen");
			  // screenUI.height = screenUI.height;
			  _visibleHieght = screenUI.chatendp.y - screenUI.chatstartp.y;
			   _visibleWidth= screenUI.chatendp.x - screenUI.chatstartp.x;
			//  trace("+aaaaffffffffffffffffffffffffffffdddddddddddddd+",screenUI.chatstartp.x,screenUI.chatendp.y);
			  _height = screenUI.height;
			//_chatInput = screenUI.chatInput;
			_chatEnabled = true;
			//chatin=screenUI.chatInput;
		    screenUI.chatDisplay.mouseEnabled = false;
			//format = new TextFormat();
           //format.font = "Arial";
           //format.color = 0x9d3292;
           //format.size = 12;
           //format.underline = true;
		   //screenUI.chatDisplay.defaultTextFormat = format;
		   //addGameEventListener(screenUI.closeB, MouseEvent.CLICK, closeClicked);
			//addGameEventListener(screenUI.ignoreB, MouseEvent.CLICK, ignoreClicked);
			//screenUI.userName.text = userName;
			addChild(screenUI);
			var cr:ChatRenderer = new ChatRenderer(screenUI.chatDisplay, screenUI.chatInput, submitChat);
			addChild(cr);
			_chatRenderer = cr;
			
			//addGameEventListener(screenUI.chatOnOffB, MouseEvent.CLICK, showChatOnOffScreen);
			
			screenUI.chatDisplay.autoSize = TextFieldAutoSize.LEFT;
			screenUI.chatDisplay.wordWrap = true;
			screenUI.chatDisplay.text = "";
			screenUI.chatInput.text = "";
			//ResizeableContainer.setTextToUI(screenUI, LanguageXMLLoader._loadedXML.GameRoom.Room);	
			//new CustomSlider(0, 100, screenUI.chatDisplay, null, 0);
			var sp:ScrollPane = new ScrollPane(_visibleWidth,_visibleHieght, _chatRenderer, screenUI.chatSlider);
			//sp.x = screenUI.chatDisplay.x;
			//sp.y = screenUI.chatDisplay.y;
			addChild(sp);
			_scrollPane = sp;
		//	_chatOnOffScreen = null;
			//screenUI.cb.visible = false;
			//screenUI.chatDisplay.textFormat	
			
			/*var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            format.color = 0xFF0000;
            format.size = 10;
            format.underline = true;*/

           // label.defaultTextFormat = format;
		    

			addGameEventListener(screenUI.sendB, MouseEvent.CLICK, sendMsg);
			
			//ResizeableContainer.setTextToUI(screenUI, LanguageXMLLoader._loadedXML.PrivateChatScreen);
			//addGameEventListener(this,KeyboardEvent.KEY_UP, keyPressed);
		}
		
		
		//------------------------function for smilechat--------------------------------
		private function chatText(txt:String):void
		{
			
			
			  if(stage)
			 stage.focus = screenUI.chatInput;
			 
			 var str :String = screenUI.chatInput.text;
			 var str1:String = str.substr(0, int(screenUI.chatInput.caretIndex))+txt;
			 var str2:String = str.substr(int(screenUI.chatInput.caretIndex), str.length);
		      str = str1 + str2;
			  screenUI.chatInput.text = str;
			  screenUI.chatInput.setSelection(str1.length,str1.length);
			_bingoScreen.removeSmile();
			  
		}
		public function smileFun(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			emosStr = SmileScreen.emoticonString[SmileScreen.smileArr.lastIndexOf(name)];
		    chatText(emosStr);
		}
		public function smileB(bs:BingoGameScreen):void
		{
			_bingoScreen = bs;
			addGameEventListener(screenUI.smile, MouseEvent.CLICK, bs.smileScreen);
		}
		//------------------------function for smilechat--------------------------------
		
		
		
		private function sendMsg(evt:MouseEvent):void
		{
			//trace(_chatRenderer._textEntered, screenUI.chatInput.text, "gahsjahskjas");
			var str:String = screenUI.chatInput.text;
			if (str.length >0 && _chatRenderer._chatSubmitFunc !=null)
			{
				//submitChat(_chatRenderer._textEntered);
				//trace("PublicChatScreen chat",str);
				
				submitChat(str);
			}
			_chatRenderer._textEntered = "";
			screenUI.chatInput.text = "";
		}
		
		override public function initialize():void
		{
			stage.focus = screenUI.chatInput;
			//stage.focus = ci;
			var ci:* = screenUI.chatInput;
			ci.setSelection(ci.length, ci.length);
			ci.stage.focus = ci;
		}
		
		
		
		
		public function resizeScreen(hsf:Number,vsf:Number):void
		{
			
			hsf1 = hsf;
			vsf1 = vsf;
			//screenUI.scaleX = hsf;
			screenUI.scaleY = vsf-.025;
			
			 _height = screenUI.scaleY ;
		
			if(vsf !=0)
			_scrollPane._visibleHeight = _visibleHieght * vsf;
					_scrollPane.setMask();
		
			//_scrollPane.setFullScroll();
			if (_chatOnOffScreen)
			{
				removeChatOnOffScreen();
			      chatOnOff();
			}
			//screenUI.smile.scaleX = hsf;
			screenUI.smile.height = 20;
			
		}
		private function chatOnOff():void
		{
			_chatOnOffScreen = new Resources.chatOnOff();
				
				_chatOnOffScreen.x = screenUI.chatOnOffP.x*hsf1;
				_chatOnOffScreen.y = screenUI.chatOnOffP.y*vsf1;
				addChild(_chatOnOffScreen);
				
				if (_chatEnabled)
					setChatEnabled();
				else
					setChatDisabled();
					
				//addGameEventListener(_chatOnOffScreen.onB, MouseEvent.CLICK, setChatEnabled );
				//addGameEventListener(_chatOnOffScreen.offB, MouseEvent.CLICK, setChatDisabled);
				addGameEventListener(_chatOnOffScreen.closeB, MouseEvent.CLICK, removeChatOnOffScreen );
		}
		
		
		private function showChatOnOffScreen(evt:MouseEvent):void
		{
			if (_chatOnOffScreen)
			{
				removeChatOnOffScreen();
			}
			else
			{
				_chatOnOffScreen = new Resources.chatOnOff();
				addChild(_chatOnOffScreen);
				_chatOnOffScreen.x = screenUI.chatOnOffP.x;
				_chatOnOffScreen.y = screenUI.chatOnOffP.y;
				
				if (_chatEnabled)
					setChatEnabled();
				else
					setChatDisabled();
					
				//addGameEventListener(_chatOnOffScreen.onB, MouseEvent.CLICK, setChatEnabled );
				//addGameEventListener(_chatOnOffScreen.offB, MouseEvent.CLICK, setChatDisabled);
				addGameEventListener(_chatOnOffScreen.closeB, MouseEvent.CLICK, removeChatOnOffScreen );
			}
		}
		
		private function setChatEnabled(evt:MouseEvent = null):void
		{
			_chatEnabled = true;
		///	screenUI.cb.visible = false;
		///	screenUI.cb.alpha = .3;
			//screenUI.chatInput.editable = true;
			//screenUI.chatDisplay.enabled = true;
			if (_chatOnOffScreen)
			{
				removeGameEventListener(_chatOnOffScreen.onB, MouseEvent.CLICK, setChatEnabled );
				addGameEventListener(_chatOnOffScreen.offB, MouseEvent.CLICK, setChatDisabled);
				_chatOnOffScreen.onB.enabled = false;
				_chatOnOffScreen.offB.enabled = true;				
			}
		}
		
		private function setChatDisabled(evt:MouseEvent = null):void
		{
			_chatEnabled = false;
			//screenUI.cb.visible = true;
			//screenUI.chatInput.editable = false;
			//screenUI.chatDisplay.enabled = false;
			if (_chatOnOffScreen)
			{
				addGameEventListener(_chatOnOffScreen.onB, MouseEvent.CLICK, setChatEnabled );
				removeGameEventListener(_chatOnOffScreen.offB, MouseEvent.CLICK, setChatDisabled);
				_chatOnOffScreen.onB.enabled = true;
				_chatOnOffScreen.offB.enabled = false;				
			}
		}
		
		private function removeChatOnOffScreen(evt:MouseEvent = null):void
		{
			removeChild(_chatOnOffScreen);
			_chatOnOffScreen = null;
		}
		
		/*private function keyPressed(evt:KeyboardEvent):void
		{
			//if (_chatEnabled == false )
			//	screenUI.chatInput.text = "";
			
			 if (evt.keyCode == Keyboard.ENTER)
			{
				submitChat();
			}			
		}*/
		
		public function submitChat(msg:String):void
		{
			//if (screenUI.chatInput.text.length > 0)
			//{
				//send private message
				//addChatMessage(screenUI.chatInput.text);
				
				
				//var userId:int = _chatManager._bingoGameScreen.getIdFromUserName(_userName);
				//if (userId == -1)
				//	return;
				
				//trace ("Sending public message",msg);
				//addChatMessage(Main._userName + " : " + screenUI.chatInput.text);
				if (Main.isRealPlay && BingoGameScreen.chatStatus==1 && BingoGameScreen._RoomChatSt==1)
				{
					
					
					if (msg.indexOf(".com")>=0 || msg.indexOf(".nl")>=0 || msg.indexOf("@")>=0)
				        return;
						trace(msg.indexOf(".com"),msg.indexOf(".nl"),msg.indexOf("@"));
				SfsMain.sfsclient.sendPublicMessage(msg + "\n");
				}
				else
				{
					if(Main.isRealPlay)
					addChatMessage("myglobalgames" + " " + ":" + "Beste" + " " + Main._userName + " " + "om te kunnen chatten dient u minimaal 1 keer opgewaardeerd te hebben! Indien u wel heeft opgewaardeerd kan het zijn dat u een tijdelijke chat blokkade heeft." + "</font>", true );
				}
		
				
				
				//addChatMessage(screenUI.chatInput.text);
				//screenUI.chatInput.text = "";
			//}			
		}
		
		private function ignoreClicked(evt:MouseEvent):void
		{			
		}
		
		private function closeClicked(evt:MouseEvent):void
		{			
			removeScreen();
			//_chatManager.privateChatClosed(_userName);
		}
		
		public function addChatMessage(msg:String,isUserAdmin:Boolean = false):void
		{
			var temp:TextFormat;
			var temp1:TextFormat;
			var temp2:TextFormat;
			//trace ("Message Added is ", msg);
			var mydate:Date = new Date();
			
			var time:String = String(mydate.getHours()) + ":" + String(mydate.getMinutes() < 10 ? "0" + mydate.getMinutes():mydate.getMinutes());
			var xyz:Array = msg.split("-");
			if (BingoGameScreen.chatStatus!=1)
			{
			screenUI.chatDisplay.htmlText +=  "<font color='#b93fba' >" + time + " " +  "Beste"+" "+Main._userName+" "+"om te kunnen chatten dient u minimaal 1 keer opgewaardeerd te hebben! Indien u wel heeft opgewaardeerd kan het zijn dat u een tijdelijke chat blokkade heeft." + "</font>"; 	
			}
			if ((_chatEnabled && BingoGameScreen.chatStatus==1 && BingoGameScreen._RoomChatSt==1)||(xyz[0]==""))
			{
				//screenUI.chatDisplay.text += _userName + " : " + msg;
				
				//trace(msg.indexOf("-"),msg.substring(msg.indexOf("-")+1));
				
				if (xyz[0]=="" || xyz[0]=="-1" )
				{
					//trace (" herer setting initial",xyz);
					temp = new TextFormat();
					temp.size = 12;
					
					if(xyz[0]=="-1")
					{
					    screenUI.chatDisplay.htmlText +="<font color='#0000ff' 'bold'>" + time +" "+GetDisplayObject.getBonusP1() +"<h1>"+ msg.substring(msg.indexOf("-")+1)+"</h1>"+GetDisplayObject.getBonusP2()+" </font>"; 
					}
					else
					{
						screenUI.chatDisplay.htmlText +="<font color='#0000ff'  >" + time + " " + msg.substring(msg.indexOf("-")+1) + "</font>"; 
					}

						
					 //temp.color = 0xb93fba;
					
					screenUI.chatDisplay.embedFonts = true;
					//screenUI.chatDisplay.defaultTextFormat = temp;
					//screenUI.chatDisplay.setTextFormat(temp, 0, xyz[1].length - 1); 
					//screenUI.chatDisplay.text = msg; 
					
				}
				else
				{
					
					var info:String;
					if (isUserAdmin)
						info =  "<font color='#0000ff' >" + " "+time +"</font>"+"<font color='#0000ff' >"+" " +xyz[0] +": "+"</font>"+"<font color='#0000ff' >" + msg.substring(msg.indexOf("-")+1)+"</font>"; 
					else	
						info =  "<font color='#0000FF' >" + time + " " +"</font>"+"<font color='#ff00FF' >" +xyz[0] +": "+"</font>"+"<font color='#000000' >" +msg.substring(msg.indexOf("-")+1)+"</font>"; 
					 //var info:String="<font color='#000000'>"+time+msg+"</font>"; \
					// trace(info,"jsajsd")
					screenUI.chatDisplay.htmlText += info;
					//screenUI.chatDisplay.setTextFormat(temp1, screenUI.chatDisplay.text.length-xyz[0].length,screenUI.chatDisplay.text.length-1); 
					
					temp2 = new TextFormat();
					
				
				  
				}

				
				//_scrollPane.setFullScroll();
				//_chatRenderer.parseForEmoticons();
				stage.invalidate();
			}
		
			_scrollPane.setFullScroll();
		    _chatRenderer.parseForEmoticons();
		}		
	}
}