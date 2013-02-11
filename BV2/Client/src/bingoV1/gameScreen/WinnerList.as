package bingoV1.gameScreen 
{
	    /**
	    * ...
	    * @author dwijendra
	    */
	    import flash.display.Sprite;
		import flash.geom.Point;
		import gameCommon.customUI.ScrollPane;
	    import gameCommon.screens.BaseScreen;
	
		public class WinnerList extends BaseScreen
		{
		   private var _winnerArray:Array;
		   private var _winnerHolder:Sprite;
	       private var _currentY:Number = 0.0;
		   private var _visibleHieght:Number=240;
		   private var _visibleWidth:Number = 180;
		   private var _sp:ScrollPane;
		   private var _sliderPos:Point;
           public static  var userscreen:*;
		   private var _bgs:BingoGameScreen;
			public function WinnerList(scr:*,bgs:BingoGameScreen) 
			{
				 userscreen = scr;
				 _bgs = bgs;
				_winnerArray = new Array();
				_winnerHolder = new Sprite();
				screenUI = new Resources.winnerSlider();
				screenUI.x = userscreen.sliderPosW.x-userscreen.winnerList.x;
			    screenUI.y = userscreen.sliderPosW.y-userscreen.winnerList.y;
				addChild(screenUI);
			    _visibleHieght = userscreen.winnerlistendP.y - userscreen.winnerliststartP.y;
			    _visibleWidth= userscreen.winnerlistendP.x - userscreen.winnerliststartP.x;
			   _sp = new ScrollPane(_visibleWidth, _visibleHieght, _winnerHolder, screenUI.bidSlider);
			    addChild(_sp);
			//addChild(_winnerHolder);
				
			}
			public function addWinner(sa:Array,type:int):void
			{
					var nameArray:Array = sa[0].split(",");
					var cardArray:Array = sa[1].split(";");
					var genaratedNO:String = sa[5];
					
					for (var i:int = 0; i < nameArray.length;i++)
					{
						var flag:int = 0;
						/*if (_winnerHash[nameArray[i]]==null)
						{
							flag = 1;
						}
						else
						{
							if (_winnerHash[nameArray[i]]._winType!=type)
							{
								flag=1
							}
						}*/
						//if (flag==1)
						//{
						//var crd:BingoCard = new BingoCard ();
						
						    
							var win:Winner = new Winner(type, nameArray[i],cardArray[i],genaratedNO,_bgs);
							win.y = _currentY;
							_currentY += 20;
							_winnerHolder.addChild(win);
							_winnerArray.push(win);
							_sp.changeUI(_winnerHolder);
							_sp.setFullScroll();
						//}
				
					}
			}
			
			
	  public function removeCard():void
		{
			//trace("hi listener4");
			for (var i:int = 0; i < _winnerArray.length;i++ )
			{
				_winnerArray[i].removeCard();
			}
			
		}		
        
		public function resizeScreen(hsf:Number, vsf:Number):void
		{
						
			screenUI.scaleY =  vsf;
			_sp._visibleHeight = _visibleHieght*vsf;
			_sp.setMask();
			
			
		}
		 public function clearList():void
		  {
			   screenUI.removeChild(_winnerHolder);
			   _winnerHolder = null;
			  _winnerArray= new Array();
		   }
	 }

}