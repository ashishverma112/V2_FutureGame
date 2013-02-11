package bingoV1.gameScreen 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import gameCommon.screens.BaseScreen;
	import gameCommon.customUI.ScrollPane;
	
	/**
	 * ...
	 * @author vipul
	 */
	public class UserList extends BaseScreen
	{
		private var _userListArray:Array;
		private var _userHolder:Sprite;
		private var _userListMask:Sprite;
		private var _userInfoArray:Array;
		private var _userTypeArray:Array;
		private	var currentY:int;
		private var tempY:int;
		//private var flag:int = 0;
		private var _sliderPos:Point;
		private var _sp:ScrollPane;
	    private var _visibleHieght:Number=240;
		private var _visibleWidth:Number = 180;
		public static const ulistH:Number = 225;
		public static const ulistW:Number = 190;
		private var _userHash:Object;
		 private var userscreen:*;
		private static const maxUsersForProcess:int = 50;
		
		
		public function UserList(scr:*) 
			{
				 userscreen = scr;
			//_sliderPos = new Point(sliderX, sliderY);
			_userInfoArray = new Array();
			//_userInfoArray = userInfoArray;
			//_userTypeArray = utype;
			//addUsers();
			screenUI = new Resources.userSlider();
			screenUI.x = userscreen.sliderPos.x-userscreen.userList.x;
		    screenUI.y = userscreen.sliderPos.y-userscreen.userList.y;
		    addChild(screenUI);
			_userHolder = new Sprite();
			//addChild(_userHolder);
		   _visibleHieght = userscreen.userlistendP.y - userscreen.userliststartP.y;
		   _visibleWidth= userscreen.userlistendP.x - userscreen.userliststartP.x;
		   _sp = new ScrollPane(_visibleWidth, _visibleHieght, _userHolder, screenUI.bidSlider);
			    addChild(_sp);
				
				_userListArray = new Array();
				_userHash = new Object();
			
		}
		override public function initialize():void
		{
			super.initialize();
					
		}
		
		public function resizeScreen(hsf:Number, vsf:Number):void
		{
			screenUI.scaleY = vsf;
			_sp._visibleHeight = _visibleHieght * vsf;
			//screenUI.bidSlider.scaleY = vsf;
			_sp.setMask();
			//_sp.setFullScrollUserList();
			//_sp.setFullScroll();
		}
		
		public function addUsers(userInfoArray:Array):void
		{
			//trace("add user is called++++++++++++",userInfoArray);
			var checkForBlock:Boolean = true;
			if (userInfoArray.length > 50)
			{
				checkForBlock = false;
			}
			_userHash = new Object();
			_userListArray = new Array();
			
			if (checkForBlock)
				userInfoArray.sortOn("name");
			for (var i:int = 0; i < userInfoArray.length;++i )
			{
				var user:BingoUser = new BingoUser(userInfoArray[i]);
				//trace("in user list the name is printed+++++++++++++",user._userName);
				if (checkForBlock)
					user.setUserBlocked(IgnoreUserManager.isUserBlocked(user._userName));
				_userListArray.push(user);
				_userHash[user._userName] = user;
				
            }
			makeUserList(_userListArray);
			//trace("in iser list player",_userListArray);
			
			 
		}
		public function GetActiveUserCount():int
		{ 
			var num:int = 0;
			if (_userListArray == null)
				return 0;
				
			if (_userListArray.length > maxUsersForProcess)
				return 10;
			for (var i:int = 0; i < _userListArray.length; i++ )
			{
				if ((_userListArray[i]._utype!=2)&&(_userListArray[i]._utype<10))
				{
					num++;
				}
			}
			return num;
		}
		public function getUserByName(name:String):BingoUser
		{
			var bu:BingoUser;
			for (var j:int = 0; j < _userListArray.length; j++)
			{
				if (name == _userListArray[j]._userName)
				{
					bu = _userListArray[j];
					break;
				}
			}
			return bu;			
		}
		
		public function makeUserList(userArray:Array):void
		{
			
			//trace("make user list is called++++++++++++++++++++++++++++++++");
		
			if (userArray.length < maxUsersForProcess)
				userArray.sort(sortUsers);
			_userHolder = new Sprite();
			//_sp.change
			 currentY = 0;
			 
			 for (var us:int = 0; us<userArray.length; us++ )
			 {
				//trace("user is ............",userArray[us]._userName)
				 _userHolder.addChild(userArray[us]);
				userArray[us].y = currentY;
				currentY += userArray[us]._userHeight;
			//	trace (currentY, " Current Y");
			 }
			_userListArray = new Array();
			_userListArray = userArray;
			_sp.changeUI(_userHolder);
			//_sp.setFullScroll();
			_sp.setFullScrollUserList();
			//stage.invalidate();
			
		}
		
		private function sortUsers(user1:BingoUser,user2:BingoUser):int
		{
			if (user1.weight > user2.weight)
			{
				return -1;
			}
			else if (user1.weight == user2.weight)
			{
				return user1._userName.localeCompare(user2._userName);
			}
			return 1;
		}
	
		public function  setWinner(name:String,noOfWinningCard:int,noOfTotalCard:String,WinningAmount:String,state:int):void
		{
			//trace("'''''''''''''''''''''",name)
			/*var k:int = 0;
			if (_userListArray.length > maxUsersForProcess)
			{
				var user:BingoUser = _userHash[name];
				if (user)
				{
					user.setState(state);
					user.setName(noOfWinningCard, noOfTotalCard, WinningAmount);
					return;
				}
			}
			for (var i:int = 0; i < _userListArray.length; i++)
			{*/
				
				/*if (k == 1)
				{
					_userListArray[i].y = currentY;
					currentY += _userListArray[i]._userHeight;
					
				}*/
				/*
				if (_userListArray[i]._userName == name)
				{
					_userListArray[i].setState(state);
					_userListArray[i].setName(noOfWinningCard, noOfTotalCard,WinningAmount);
					//_userListArray[i].y += 10;
				//	currentY = _userListArray[i].y + _userListArray[i]._userHeight;
					//k = 1;
				}
				makeUserList(_userListArray);
				
				
			}
		//	_sp.setFullScroll();*/
					
		}
		public function setuserInGame(Name:String,i:int,fun:Function=null):void
		{
			var flag:int = 0;
			if (i == 3 && _userHash[Name]!= null)
				{
					if (_userHash[Name]._isAdmin)
					{
						removeUserFromList(Name);
						_userHash[Name] = null;
					}
					else
					{
						_userHash[Name].setState(2);
					}
								
				}
				if ( i == 0||i==10)
				{
					
					    if (_userHash[Name]!= null)
					      {
						
					      _userHash[Name].setState(i+1);
					
					       }
					   else
				        {
							var obj:Object = { name:Name, type:String(i+1) };
							var user:BingoUser = new BingoUser(obj);
				           user.setUserBlocked(IgnoreUserManager.isUserBlocked(Name));
				           _userListArray.push(user);
				            _userHash[Name] = user;
				                makeUserList(_userListArray);
							
				        }
	
					}
			//stage.invalidate();
			}
		/*public function addSingleUser(Str:String,type:int):void
		{
			removeChild(_userHolder);
			var user:User = new User(Str, type);
			_userHolder.addChild(user);
			user.y = currentY;
			currentY += User._userHeight;
		    _userListArray.push(user);
			addChild(_userHolder);
			_userHolder.mask = _userListMask;
			 setuserSlider();
			
		}*/
	
		public function removeUserFromList(userName:String):void
		{
			var k:int = 0;
			//currentY = 0;
			for (var i:int = 0; i < _userListArray.length;++i )
			{
				if (_userListArray[i]._userName== userName &&k==0)
				{
					_userHolder.removeChild(_userListArray[i]);
					_userListArray.splice(i, 1);
					 break;
				}
				
			}
		/*	if (k != 0)
			{
				var j:int;
				for (j=k-1; j < _userListArray.length;++j )
				{
					//_userHolder.removeChild(_userListArray[i]);
					//_userHolder.addChild(_userListArray[i]);
					_userListArray[j].y = currentY-_userListArray[j].height;
					currentY += _userListArray[j].height;
				
				}
				currentY-=_userListArray[j-1].height;
			}
			*/
			//_userListArray.splice((k - 1), 1);
			makeUserList(_userListArray);
			//_sp.setFullScroll();
			stage.invalidate();
			
		}
		
		
		
		/*private function drawMask():void
		{
			_userListMask = new Sprite();
            addChild(_userListMask);
           _userListMask.graphics.lineStyle(3,0x00ff00);
           _userListMask.graphics.beginFill(0x0000FF);
           _userListMask.graphics.drawRect(0,0,168,250);
			_userListMask.visible = false;
		}*/
	}

}