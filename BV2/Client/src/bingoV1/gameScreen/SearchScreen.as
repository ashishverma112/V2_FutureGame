package bingoV1.gameScreen 
{
	import gameCommon.screens.BaseScreen;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import gameCommon.customUI.ScrollPane;
	/**
	 * ...
	 * @author ashish
	 */
	public class SearchScreen extends BaseScreen
	{
		private var _searcharray:Array;
		private var _name:String;
		private var _userHolder:Sprite;
		
		private var _sp:ScrollPane;
		private var screenUi:*;
		private var resultArray:Array;
		private var roomArray:Array;
		private	var currentY:int;
		private var tempY:int;
		private var _userHeight:Number = 25;
		
		
		public function SearchScreen() 
		{
			
			screenUI = GetDisplayObject.getSymbol("searchScreen");
			
			addChild(screenUI);
			addGameEventListener(screenUI.sluitB, MouseEvent.CLICK, closedScreen );
		}
		override public function initialize():void
		{
			super.initialize();
			screenUi = new Resources.userSlider();
			screenUi.x = screenUI.sliderP.x;
			screenUi.y = screenUI.sliderP.y;
			
			//screenUi.y = _sliderPos.y;
			
			//drawMask();
			 screenUI.addChild(screenUi);
			_userHolder = new Sprite();
			_userHolder.x = screenUI.userListP.x;
			_userHolder.y = screenUI.userListP.y;
			screenUi.addChild(_userHolder);
			_sp = new ScrollPane(220, 140, _userHolder, screenUi.bidSlider);
			screenUI.addChild(_sp);
			//trace("userlist")
			
			//trace("ashish");
			//setuserSlider();
		}
		public function showResult(searchA:Array, searchName:String,room:Array):void
		{
		//	trace("hihii",room,"hjks",searchName,"serach arr",searchA[0],searchA.length);
			resultArray = new Array();
			
			//_searcharray = searchA;
			//_name = searchName;
			var b:Boolean = true;
			
			for (var i:int = 0; (i < searchA.length) && (searchA[i]!= "") ; i++ )
			{
				var roomUserArray:Array = searchA[i].split("*");
				
				if (room[i + 1] != null && roomUserArray[0] != "")
				{
					trace(roomUserArray,roomUserArray.length,"auser array")
					
				for (var j:int = 0; j < roomUserArray.length; j++ )
				{
					
					if (roomUserArray[j].search(searchName)!= -1)
					{
						 var txt:*= new Resources.textS();
						  var str:String = roomUserArray[j] + " | " + room[i+1];
						 
						txt.username.text = str;
						resultArray.push(txt);	
						b = false;
						//trace(str,"gsj",searchName);
					} 
					
					
					  
				}
				
				}
				
			}
			if (b)
			{
				         var txt1:*= new Resources.textS();
						  var str1:String;
						 if (searchA[0] == "")
						    str1 = "NO User In The Room";
						 else
						   str1 = searchName + " | Not In Room";
						  txt1.username.text = str1;
						   resultArray.push(txt1);	
				
			}
			
			makeUserList(resultArray);
		}
		private function makeUserList(userArray:Array):void
		{
			trace(userArray,"auser array")
			
			//if (_userHolder)
			//{
			//	_userHolder.parent.removeChild(_userHolder);
			//	_userHolder = null;
			//}
			_userHolder = new Sprite();
			
			//_sp.change
			 currentY = 0;// screenUI.userListP.y;
			 
			 for (var us:int = 0; us<userArray.length; us++ )
			 {
				// trace("user is ............",userArray[us])
				 _userHolder.addChild(userArray[us]);
				userArray[us].y = currentY;
				currentY += _userHeight;
			//	trace (currentY, " Current Y");
			 }
			  //addChild(_userHolder);
			//_userHolder.mask = _userListMask;
			resultArray = new Array();
			resultArray = userArray;
			_sp.changeUI(_userHolder);
			_sp.setFullScroll();
			stage.invalidate();
			
		}
		private function closedScreen(e:MouseEvent):void
		{
			removeChild(screenUI);
			screenUI = null;
		}
		
	}

}