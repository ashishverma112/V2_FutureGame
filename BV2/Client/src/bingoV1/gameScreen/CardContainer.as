package bingoV1.gameScreen 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gameCommon.screens.BaseScreen;
	import multiLanguage.ResizeableContainer;
	import multiLanguage.LanguageXMLLoader;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CardContainer extends BaseScreen
	{
		private var _cardArray:Array;
		private var _cardNumberArray:Array;
		private var _cardHolder:Sprite;
		private var _cardMask:Sprite;
	    private var _cardPointer:int;
		private var pointerMaxVal:int;
		private var  numCards:int ;
		private var _mainCardArray:Array;
		public function CardContainer() 
		{
		
		}
	
		public function setPreviousTextVisible(a:Boolean):void
		{
			//screenUI.previous_res.visible = a;
			//screenUI.topEnd.visible = a;
		//	screenUI.topStart.visible = a;
			//ResizeableContainer.setTextToUI(screenUI, LanguageXMLLoader._loadedXML.GameRoom.CardContainer);
			
		}
		public function setNextTextVisible(a:Boolean):void
		{
			
				//screenUI.next_res.visible = a;
			//	screenUI.bottomEnd.visible = a;
			 //   screenUI.bottomStart.visible = a;
			    //ResizeableContainer.setTextToUI(screenUI, LanguageXMLLoader._loadedXML.GameRoom.CardContainer);
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			_cardArray = new Array();
			//screenUI = new Resources.cardContainerButton();
			screenUI = GetDisplayObject.getSymbol("cardContainerButton");
			addChild(screenUI);
			screenUI.previousB.visible = false;
			screenUI.nextB.visible = false;			
			
			//screenUI.nextB.buttonMode = true;
			//screenUI.previousB.buttonMode = true;
			//setTextVisibility(false);
			//setPreviousTextVisible(false);
			//setNextTextVisible(false);
			//drawMask();
			
		}
		
		public function addCards(numString:String):int
		{
			 //trace("num screen in card..................*************************************",numString);
			   var s:int = 0;
		      _mainCardArray = new Array();
		      var seperator:int = -1;
			   if (_cardHolder)
			   {
			     removeChild(_cardHolder);
				 _cardHolder = null;
			   }
			
			
				 
						var cardArray:Array = numString.split(";");
			     numCards = _cardArray.length;
			// var innerArray:Array=new Array();
			for (var i:int = 0; i < cardArray.length;++i )

			{
				//trace("i/10 is equal to::::::::::::::::::",i/10)
				if (int(i /10) > seperator)
				{
				       //trace("seperator block is executed++++++++++++++++++++++++++++++++++++++++++++");
					seperator++;
					s = 0;
					_mainCardArray[seperator] = new Array();
				     	//if (seperator > 0)
					       // _mainCardArray.push(innerArray);
					      /// innerArray = new Array();
					
				}
				_mainCardArray[seperator][s++]= new BingoCard( cardArray[i].split(","));
			}
			//_mainCardArray.push(innerArray);
			pointerMaxVal = seperator;
			_cardPointer = pointerMaxVal;
			
			showCard();
			numCards = i;
		//	trace("number string...............", numString);
		//	trace("formattedArray..............*******************.", _mainCardArray[_cardPointer].length);
			return i;			
		}
		private function showCard():void
		{
			     var count:int = 1;
			     var currentY:Number = 0.0;
			    var currentX:Number = 0.0;
				_cardHolder = new Sprite();
				//trace("show card is called.........................................",_mainCardArray[_cardPointer].length);
				for (var l:int = 0; l < _mainCardArray[_cardPointer].length;l++)
				{
				  //var cardNumberArray:Array = _mainCardArray[_cardPointer][l].split(",");
				   var bingoCard:BingoCard = _mainCardArray[_cardPointer][l];
				   //trace("card number array is written&&&&&&&&&&&&&&&&&&&&&&&&&&",cardNumberArray);
				  _cardHolder.addChild(bingoCard);
				  bingoCard.x = currentX;
				  bingoCard.y = currentY;
				  currentX += BingoCard._cardWidth+2;
				if (l == count*5-1)
				{
					currentY += BingoCard._cardHeight;
					currentX =0.0;
					count++;
				}
				_cardArray.push(bingoCard);	
				}
			
			addChild(_cardHolder);
			//_cardHolder.mask = _cardMask;
			setListenerOnButtons();
				
			
		}
		
		private function setListenerOnButtons():void
		{
			if (_mainCardArray.length>1)
			{
				screenUI.previousB.visible = true;
				screenUI.nextB.visible = true;
				//setTextVisibility(true);
			    setPreviousTextVisible(true);
			    setNextTextVisible(true);
				showText();
			
			var noOfCards:int = _cardArray.length;
			addGameEventListener(screenUI.nextB, MouseEvent.CLICK, showNextScreen);
			addGameEventListener(screenUI.previousB, MouseEvent.CLICK, showPreviousScreen);
			}
			
		}
		private function showText():void
		{
			//trace("number of cards;;;;;;;;;",numCards);
			var remain:int = 0;
			var result:int = 0;
			 setPreviousTextVisible(true);
			 setNextTextVisible(true); 
			  remain = numCards % 10;
			  result = int(numCards / 10);
			 // trace("remainder;;;;;;;;;;;;", remain);
			 // trace("result;;;;;;;;;;;;;;;", result);
			 // trace("pointer max value;;;;;;;;;;", pointerMaxVal);
			 // trace("card ponter;;;;;;;;",_cardPointer);
			if (_cardPointer==0)
			{
				 screenUI.previousB.visible = false;
				 setPreviousTextVisible(false);
				if (remain == 0)
				      remain = 10;
					 screenUI.bottomEnd.text = 10 + remain;
				    screenUI.bottomStart.text =11;
			}
			else if (_cardPointer == pointerMaxVal)
			{
				screenUI.nextB.visible = false;
				setNextTextVisible(false);
				screenUI.topStart.text = (_cardPointer-1)*10+1;
				screenUI.topEnd.text = _cardPointer*10;
			}
			
			if(_cardPointer!=0 &&_cardPointer!=pointerMaxVal)
			{
				 screenUI.topStart.text = (_cardPointer*10)+1;
				 screenUI.topEnd.text = (_cardPointer+1) * 10;
				
				  screenUI.bottomStart.text = (_cardPointer + 1) * 10 +1 ;
				    screenUI.bottomEnd.text =(_cardPointer+2) * 10;
				
			}
			
			
		
				//showPatternsInCards(_);
		}
		
		private function showNextScreen(evt:MouseEvent):void
		{
			//trace("next button evenlistener is called");
			if (_cardPointer < pointerMaxVal)
			{
				
				_cardPointer++;
				
				showText();
				removeChild(_cardHolder);
				showCard();
			}
		
	
		}
		
		private function showPreviousScreen(evt:MouseEvent):void
		{
			//trace("previous evenlistener is called");
			if (_cardPointer>0)
			{
				_cardPointer--;
				showText();
				removeChild(_cardHolder);
				showCard();
				
			}
			
		}
		
		public function markNumberInCards(number:String):void
		{
			if (_mainCardArray)
			{
				//trace("number in card container",number);
						for (var i:int = 0; i <_mainCardArray.length;++i )
						{
						for (var j:int = 0; j < _mainCardArray[i].length; j++)
						{
							//trace("number in loop container",number);
						_mainCardArray[i][j].checkNumber(number);
						}
						}
			}
		}
		
		public function showPatternsInCards(patternString:String):void
		{
			var patternArray:Array = patternString.split(",");
			for (var i:int = 0; i <_mainCardArray.length;++i )
			{
				for (var j:int = 0; j < _mainCardArray[i].length; j++)
				{
				 _mainCardArray[i][j].setPatternOnCard(patternArray);
				}
			}
		}
		private function drawMask():void
		{
			_cardMask = new Sprite();
            addChild(_cardMask);
           _cardMask.graphics.lineStyle(3,0x00ff00);
           _cardMask.graphics.beginFill(0x0000FF);
           _cardMask.graphics.drawRect(0,0,900,240);
			_cardMask.visible = false;
		}
		
	}
}