package bingoV1.gameScreen 
{
	import flash.text.TextField;
	import gameCommon.screens.BaseScreen;
	import bingoV1.lobbyScreen.MainLobbyScreen;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author vipul
	 */
	public class BingoCard extends BaseScreen
	{
		public var _noArray:Array;
		public var _noObj:Array;
		private var _onCheckNumber:Function;
		private var _pattarnArray:Array;
		public var _cardWidth:Number=138.0;
     	public var _cardHeight:Number =138.0;
		public var remainingNumber:int = 0;
		public var _isMainCard:Boolean;
		
		private var _markFun:Function;
		
		public function BingoCard(noArray:Array,markFun:Function,isMain:Boolean=true) 
		{
			//trace ("asdfasdfasdf adfasdfasdf asdfasdf");
			 var str:String;
			  var i:int = 0;
		     _noArray = noArray;
			 _noObj = new Array(100);
			 _isMainCard = isMain;
			 _markFun = markFun;
			 
			 remainingNumber = 15;
			// trace("no arraay", _noArray);
			
			
			if (_isMainCard)
			{
			 screenUI = new Resources.card();
			}
			else
			{
				screenUI = new Resources.NewCard();
			}
			 _cardWidth=screenUI.width;
             _cardHeight = screenUI.height;
			 if (_isMainCard)
			 {
			    screenUI.bingoballs.gotoAndStop(1);
			 }
			 addChild(screenUI);
			 for (i = 0; i < _noObj.length; i++)
			 {

				 _noObj[i] = -1;
			 }
			 
			for (i= 0; i < noArray.length; i++)
			 {
				  str = "text" + i;
								
				 if (_noArray[i]!="0")
				 {
					_noObj[int(_noArray[i])] = i;
					screenUI[str]["txt"].text = _noArray[i];
				   
				 }
				 else
				 {
					screenUI[str]["txt"].text = ""; 
				 }
					 
				  screenUI[str]["mark"].visible = false;
				  screenUI[str]["mark"].gotoAndStop(MainLobbyScreen._markcolor);
				
			 }
			
		}
		override public function initialize():void
		{
			super.initialize();
		}
		public function setCardBackGround(roundno:int):void
		{
			 screenUI.bg.gotoAndStop(roundno);
			
		}
		public function setNumberOncards():void
		{
			 var str:String;
		
			for (var i:int = 0; i <27;i++ )
			{
				
			
				     str = "text" + i;
				//trace("why this errror !!!!!!!!!!!!!!!!!!",str,_noArray);
				screenUI[str]["txt"].text =( _noArray[i]==0? "" : _noArray[i]);
				screenUI[str]["mark"].visible = false;
				screenUI[str]["mark"].gotoAndStop(MainLobbyScreen._markcolor);
			
			}
			//trace("why this errror !!!!!!!!!!!!!!!!!!loop finished now");
		}
		public function setListener(num:String):void
		{	
			//trace("mark no ",num)
			
			
				if (_noObj[int(num)]!= -1)
				{
					var str:String = "text" + _noObj[int(num)];
					if (screenUI[str]["mark"].visible == false)
					{
					  addGameEventListener(screenUI[str], MouseEvent.CLICK, marknum);
					 // trace("string no", str,num);
					}
				}
			
		}
		public function  marknum(evt:MouseEvent):void
		{
			//evt.currentTarget["mark"].visible = true;
			trace("kya no aya ",evt.target,evt.currentTarget.name,evt.target.text);
		    removeGameEventListener(screenUI[evt.currentTarget.name], MouseEvent.CLICK, marknum);
			var str:String = ""; 
			  str = String(evt.target.text);
			  if(str !="")
			    _markFun(str);
		     str="";
			//remainingNumber--
			 //if (remainingNumber == 3 && _isMainCard)
			 //{
			  // screenUI.bingoballs.play();
			  //}
		}
		
		//private function getCardDump():String
		//{
			//for (var i:int = 0; i < _n
			
		//}
		
		public function checkNumber(number:String,check:Boolean=true):void
		{
			var k:int;	
			var intFromString:int = int(number);
			
			if (_noObj[int(number)]!= -1)
			{
				//trace ("inside mark ", number);
				var str:String = "text" + _noObj[int(number)];
				if (screenUI[str]["mark"].visible==false)
				{
						remainingNumber--
						removeGameEventListener(screenUI[str],MouseEvent.CLICK,marknum);
					   screenUI[str]["mark"].visible = true;
					   //if (screenUI[str]["mark"].visible == false)
					   //{
						//   trace ("Marked yet false asdfasdfasdfadf");
					   //}
					//screenUI[str]["mark"].gotoAndStop(1);
				}
					 if (remainingNumber == 3 &&check &&_isMainCard)
					 {
						
						  screenUI.bingoballs.play();
				     }				
			}
			
		}
		public function setPatternOnCard(patternArray:Array):void
		{
			//trace("####################################################################");
			for (var i:int = 0; i < patternArray.length;++i )
			{
				//trace("pattern array........", patternArray[i]);
				  var str:String;
				
			
				   str= "text" + patternArray[i];
				//screenUI[str].gotoAndStop(2);
				//screenUI[str]["pattern"].visible=true;
			}
		}
		
		
	}

}