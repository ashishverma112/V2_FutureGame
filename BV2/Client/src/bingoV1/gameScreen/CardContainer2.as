package bingoV1.gameScreen 
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gameCommon.screens.BaseScreen;
	import multiLanguage.ResizeableContainer;
	import multiLanguage.LanguageXMLLoader;
	import gameCommon.customUI.ScrollPaneHorizontal;
	import com.gskinner.motion.GTween;
    import flash.filters.DropShadowFilter;
	import flash.display.GradientType;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import bingoV1.lobbyScreen.MainLobbyScreen;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import gameCommon.lib.SoundPlayer;
	
	/**
	 * ...
	 * @author ashish
	 */
	public class CardContainer2 extends BaseScreen
	{
		private var _numStr:String;
		private var _cardArray:Array;
		private var _cardNumberArray:Array;
		private var _cardHolder:Sprite;
		private var _cardMask:Sprite;
	    private var _cardPointer:int;
		private var pointerMaxVal:int;
		private var  numCards:int ;
		private var _mainCardArray:Array;
		private var _mainCardArray1:Array;
		
		private var _bookNumArray:Array;
		private var _bookDisplayArray:Array;
		private var _bookPointer:int;
		public  var noOfRoomCard:int = 0;
		private var flagN:Boolean = false;
	
		public var pageTurn:Sprite;
		public var Mask:Sprite;
		public var topBook:Sprite;
		public var bottomBook:Sprite;
		public var bookToShow:Sprite;
		public var currentAnimation:*;
		public var mainSpiral:Sprite;
		public var _currentPageArray:Array;
		public var _wholeCardContainer:*;
		public var _wholeCardVisible:Boolean = false;
		public var _WCscreen:WholeCardContainer;
		public function CardContainer2(numStr:String) 
		{
			//trace("in card container",numStr);
			_bookPointer = 1;
			_cardArray = new Array();
			_currentPageArray= new Array();
		    //trace("number screen+++++++++++++++++++",numStr);
			_bookNumArray = numStr.split("*");
			//trace(_bookNumArray.length,"card lrength",numStr)
			//_cardArray = _numStr.split(";");
			_mainCardArray = new Array();
			_mainCardArray1 = new Array();
			_wholeCardContainer = new Sprite();
			//_mainCardArray2 = new Array();
		
		}
		public function tweenAction():void
		{
			new GTween(Mask,4, { width:0.0 } );
		}
		public function removemask(tw:GTween):void
		{
			removeChild(pageTurn);
		}
		override public function initialize():void
		{
			 super.initialize();
			 screenUI = new Resources.cardContainer();
			 mainSpiral = new Resources.MainSpiral();
		   // screenUI.width = 3 * BingoBook._cardWidth;
		   // screenUI.height=BingoBook._cardHeight;
		    addGameEventListener(screenUI.nextB, MouseEvent.CLICK, showNextScreen);
			screenUI.previousB.enabled = false;
			addGameEventListener(screenUI.showCardsB, MouseEvent.CLICK,showWholeCard);
				 
	        addGameEventListener(screenUI.previousB, MouseEvent.CLICK, showPreviousScreen);
			 addChild(screenUI);
			_cardHolder = new Sprite();
			 numCards = _cardArray.length / 6;
	
			 generateCard();
			 _bookPointer = int((numCards - 1) / 2) + 1;
			  screenUI.addChild(_cardHolder);
		    showCard();
			// topBook = bookToShow;
		   // _cardHolder.addChild(topBook);
			//topBook.name = "topBook";
		}
		private function mainCardArray():void
		{
			   
				//trace("dfdsg",_mainCardArray);
		}
		private function showCard():void
		{
			 var len:int = 0;
			
			if (_mainCardArray.length>=_bookPointer*2)
			{
				len=2
			}
			else
			{
				len=_mainCardArray.length-(_bookPointer-1)*2
			}
			if (len<=0)
			{
				return;
			}
			if (_cardHolder)
			{
				screenUI.removeChild(_cardHolder);
				_cardHolder = null;
				//_currentPageArray = new Array();
				//screenUI.removeChild(mainSpiral);
			}
			
		     _cardHolder = new Sprite();
			  var currentY:Number = 0.0;
			  var currentX:Number = 0.0;
			  var i:int = (_bookPointer - 1) * 2;
				
			for( i = (_bookPointer-1)*2; i <((_bookPointer-1)*2+len);i++)
			//for(var i:int =0; i <_mainCardArray.length;i++)
			{
				
				// addChild(_mainCardArray[i]);
			      _cardHolder.addChild(_mainCardArray[i]);
				 // _currentPageArray.push(_mainCardArray[i]);
				  _mainCardArray[i].x = currentX;
				  _mainCardArray[i].y = currentY;
				  currentX += BingoBook._cardW+35;
				 //.width = (i + 1) * BingoBook._cardWidth;
				//trace("noOfRoomCard", (i + 1));
			}
		
		      screenUI.addChild(_cardHolder);
			  // if (_mainCardArray.length>1)
			   //{
			     _cardHolder.addChild(mainSpiral);
			     mainSpiral.x = screenUI.spiralP.x;
			     mainSpiral.y = screenUI.spiralP.y;
			   //}
			   
		      //currentAnimation = new PageAnimation( _mainCardArray[(_bookPointer - 1) * 2], _mainCardArray[(_bookPointer - 1) * 2 + 1],endAnimation);
		     //screenUI.addChild(currentAnimation);
			 //drawMask(bookToShow);
			//_sp = new ScrollPaneHorizontal(3 * BingoBook._cardWidth,BingoBook._cardH, _cardHolder,screenUI.bidSlider);
		
		//	addChild(_sp);
			//_sp.setFullScroll();
		
			 
		}
		private function generateCard():void
		{
			     var count:int = 1;
			     var cX:Number = 4.0;
				if (_bookNumArray)
				{
					for (var k:int = 0; k < _bookNumArray.length; k++)
					{
						
						 var bcrd:BingoBook = new BingoBook(_bookNumArray[k],markNumberInCards ,false);
						 _mainCardArray1.push(bcrd);
						 	 bcrd.x = cX;
						 cX += BingoBook._cardWidth+1;
						 var bingoCard:BingoBook = new BingoBook(_bookNumArray[k],markNumberInCards);
						  _mainCardArray.push(bingoCard);
						
						 _wholeCardContainer.addChild(bcrd);
					
						 // _mainCardArray2.push(new BingoBook(_bookNumArray[k]));
						if ((k!=0)&&(k%3==0))
						{
							_bookPointer=3;
						}
						  
					}
				_WCscreen = new WholeCardContainer( _wholeCardContainer,closeWCscreen);
				 				  
				 noOfRoomCard = _bookNumArray.length;
				 if (noOfRoomCard <= 2)
				  {
					  screenUI.nextB.enabled = false;
					  screenUI.previousB.enabled = false;
					 removeGameEventListener(screenUI.nextB, MouseEvent.CLICK, showNextScreen);
	                 removeGameEventListener(screenUI.previousB, MouseEvent.CLICK, showPreviousScreen);
					  
				   }
			
				}
					
		}
		public function showWholeCard(evt:MouseEvent):void
		{
			SoundPlayer.playSound("buttonClick");
		    parent.addChild(_WCscreen);
			if (this.y >= 90 )
		    _WCscreen.y = this.y-27;
		
			if(_cardHolder)
			screenUI.removeChild(_cardHolder);
			_cardHolder = null;
			_wholeCardVisible = true;
		
		}
		public function closeWCscreen():void
		{
			if (_wholeCardVisible)
			{
			   showCard();
			   parent.removeChild(_WCscreen);
			  _wholeCardVisible = false;
			}
		}

		public function showNextScreen(evt:MouseEvent):void
		{
			SoundPlayer.playSound("buttonClick");
			if (_bookPointer >= 1)
			{
				   screenUI.previousB.enabled = true;
		           addGameEventListener(screenUI.previousB, MouseEvent.CLICK, showPreviousScreen);
			}
			
			endAnimation(0);
			if (_bookPointer<3)
			{
				_bookPointer++;
				  	if (_bookPointer == int((noOfRoomCard+1)/2))
		 	        {
				      screenUI.nextB.enabled = false;
					  removeGameEventListener(screenUI.nextB, MouseEvent.CLICK, showNextScreen);
			        }
				
			   if (_mainCardArray.length>=_bookPointer*2)
			    {
					 var c1:BitmapData = new BitmapData(BingoBook._cardWidth,BingoBook._cardHeight, true, 0x0);
                      c1.draw(_mainCardArray[(_bookPointer - 1) * 2]);
                    var card1:Bitmap = new Bitmap(c1);
					var c2:BitmapData = new BitmapData(BingoBook._cardWidth,BingoBook._cardHeight, true, 0x0);
                      c2.draw( _mainCardArray[(_bookPointer - 1) * 2 + 1]);
                    var card2:Bitmap = new Bitmap(c2);
					
				  currentAnimation = new PageAnimation( card1,card2,endAnimation);
				  screenUI.addChild(currentAnimation);
			    }
			   else if((_bookPointer*2-_mainCardArray.length)==1)
			   {
				   
				   
				   
				      var crd:BitmapData = new BitmapData(BingoBook._cardWidth,BingoBook._cardHeight, true, 0x0);
                      crd.draw(_mainCardArray[(_bookPointer - 1) * 2]);
                    var crd1:Bitmap = new Bitmap(crd);  
					
				     var p2:Sprite = new Resources.CoverPage();
					//p2.width = 700;
					
					 p2["bck"].gotoAndStop(MainLobbyScreen._bgcolor);
					 var b:BitmapData = new BitmapData(p2.width,p2.height, true, 0x0);
                      b.draw(p2);
                    var bitmap:Bitmap = new Bitmap(b);
					//bitmap.height = BingoBook._cardHeight;
					//
					bitmap.width =  BingoBook._cardWidth;
					currentAnimation = new PageAnimation(crd1,bitmap,endAnimation);
				     screenUI.addChild(currentAnimation);
				  // }
			   }
			   else
			   {
				  _cardPointer--; 
			   }
				
				//showCard();
			   
			}
			
			flagN = true;
		  
		}
		
		public function showPreviousScreen(evt:MouseEvent):void
		{
			//trace("----------previous button is clicked----------------------", _bookPointer);
			SoundPlayer.playSound("buttonClick");
			 if (_bookPointer <= int((noOfRoomCard+1)/2))
		 	        {
				      screenUI.nextB.enabled = true;
					  addGameEventListener(screenUI.nextB, MouseEvent.CLICK, showNextScreen);
			        }
		     endAnimation(0);
		    if (_bookPointer>1)
			{
				_bookPointer--;
				if (_bookPointer == 1)
					{
				   screenUI.previousB.enabled = false;
		           removeGameEventListener(screenUI.previousB, MouseEvent.CLICK, showPreviousScreen);
					}
				
				
				
				if (_mainCardArray.length>=_bookPointer*2&&_bookPointer!=0)
			    {
				//trace("why in this+++++++++++++++++++++++++++show previous");	
				 var c1:BitmapData = new BitmapData(BingoBook._cardWidth,BingoBook._cardHeight, true, 0x0);
                      c1.draw(_mainCardArray[(_bookPointer - 1) * 2]);
                    var card1:Bitmap = new Bitmap(c1);
					var c2:BitmapData = new BitmapData(BingoBook._cardWidth,BingoBook._cardHeight, true, 0x0);
                      c2.draw( _mainCardArray[(_bookPointer - 1) * 2 + 1]);
                    var card2:Bitmap = new Bitmap(c2);
				//currentAnimation = new PageAnimationBack(card2,card1,endAnimation);
				
				 currentAnimation = new PageAnimationBack(card1,card2,endAnimation);
				  screenUI.addChild(currentAnimation);
			    }
				else
				{
					_bookPointer++;
				}
				
				//showCard();
			}
			
					flagN = false;	
		}
		public function endAnimation(flg:int=1):void
		{
			//
			//trace("current animation is called++++++++++++++++");
			if (currentAnimation)
			{
				//trace("current animation is called++++++++++++++++");
				currentAnimation.myTimer.stop();
				screenUI.removeChild(currentAnimation);
				currentAnimation = null;
			}
			if (flg!=0)
			{
			  showCard();
			}
		}
		//public function 
		
		public function markNumberInCards(num:String):void
		{
			if (_mainCardArray)
			{
				for (var i:int = 0; i < _mainCardArray.length;i++)
				{
					_mainCardArray[i].markCards(num);
					_mainCardArray1[i].markCards(num);
					//_mainCardArray2[i].markCards(num);
				}
			}
		}
		public function setListener(num:String):void
		{
			if (_mainCardArray)
			{
				for (var i:int = 0; i < _mainCardArray.length;i++)
				{
					_mainCardArray[i].setListener(num);
					_mainCardArray1[i].setListener(num);
				}
			}
		}
		public function resize1(hsf:Number,vsf:Number):void
		{
			if (this.y >= 90 )
			 _WCscreen.y = this.y - 27;
			// trace(this.y,"gshdfjhdf")
			_WCscreen.resizeScreen(hsf,vsf);
			
		}
		public function resizeScreen(hsf:Number,vsf:Number):void
		{
		
			screenUI.scaleX = hsf;
			screenUI.scaleY = vsf;
			
		
		}
		
	}

}