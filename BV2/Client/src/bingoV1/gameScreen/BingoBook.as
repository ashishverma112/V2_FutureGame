package bingoV1.gameScreen 
{
	import adobe.utils.CustomActions;
	import gameCommon.screens.BaseScreen;
	/**
	 * ...
	 * @author dwijendra
	 */
	public class BingoBook extends BaseScreen
	{
		private var _pattern:String ;
		private var _cardArr:Array;
		private var splitA:Array;
		
		private var card:BingoCard;
	    private var _cardArray:Array;
		public static var _cardWidth:Number = 340;
		public static var _cardHeight:Number = 106 * 6;
		public static var _cardH:Number;
		
		public static var _cardW:Number = 246;
		private var curry:Number = 1;
		private var _isMainCard:Boolean;
		private var _funMarkNum:Function;
		public function BingoBook(pattern:String,funMarkNum:Function,ismain:Boolean=true) 
		{
			_isMainCard = ismain;
			_pattern = pattern;
			_funMarkNum = funMarkNum;
			splitA = _pattern.split(";");
			_cardArray = new Array();
			_cardH = _cardHeight;
			setCard();
		}
		public function markCards(num:String):void
		{
			for (var i:int = 0; i < _cardArray.length;i++)
			{
				_cardArray[i].checkNumber(num);
				//_cardArray[i].height = _cardHeight/6;
				//_cardArray[i].width = _cardWidth;
			
			}
			
		}
		public function setListener(num:String):void
		{
			for (var i:int = 0; i < _cardArray.length;i++)
			{
				_cardArray[i].setListener(num);
			
			}
			
		}
		private function setCard():void
		{
		//var curry:Number = 0;
			if (splitA.length > 1)
			{
				for (var i:int = 0; i<splitA.length; i++ )
				{
				// trace(splitA[i].length, "splitlength", i);
				   card = new BingoCard(splitA[i].split(","),_funMarkNum,_isMainCard);
				   _cardArray.push(card);
				   
				   //card.height=card._cardHeight;
				   //card.width =scr;
				    card.setCardBackGround(BingoGameScreen.roundno);
				   card.y = curry;
				  // curry += 1;
				  if(_isMainCard)
				     curry += 97;
				  else 
				      curry += 101;
				   addChild(card);
				}
				_cardWidth = card._cardWidth;
				_cardHeight = card._cardHeight * 6+10;
				_cardH = _cardHeight;
			}
			
	
		}
		public function resize(hsf:Number,vsf:Number):void
		{
			//trace("kdsfjklds")
			curry = 2;
			_cardW = _cardWidth * hsf;
			_cardH = _cardHeight * vsf;
			for (var i:int = 0; i < _cardArray.length;i++)
			{
			_cardArray[i].width=_cardW;
			_cardArray[i].height = _cardH / 6 ;
			_cardArray[i].y = curry;
			 curry += 2;
		     curry += _cardH / 6 ;
			}
			//_cardHeight = _cardArray[0].height * 6;
			
		}
	
		
	}

}