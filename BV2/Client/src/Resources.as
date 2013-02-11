           package  
{
	/**
	 * ...
	 * @author
	 */
	import flash.display.DisplayObject;
    import flash.display.Sprite;

	 import flash.utils.getDefinitionByName;

	public class Resources
	{
		
		[Embed(source = "assets/Bingo2.swf", symbol = "WinnerCardContainer")]
	   public static var WinnerCardContainer :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "Number1")]
	    public static var txt:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "WholeCardContainer")]
		public static var wholeCardContainer:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "NewCard")]
		public static var NewCard:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "Line")]
		public static var Line:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "MainSpiral")]
		public static var MainSpiral:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "maskBack")]
		public static var maskBack:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "rectangleMask")]
		public static var rectangleMask:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "rectangleMask1")]
		public static var rectangleMask1:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "CoverPage")]
		public static var CoverPage:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "BookContainer")]
		public static var BookContainer:Class;
		[Embed(source = "assets/V1Sound.swf", symbol = "backgroundsound")]
		public static var backgroundSound:Class;
		
		[Embed(source = "assets/V1Sound.swf", symbol = "tick")]
		public static var ticksound:Class;
		
		//[Embed(source = "assets/movingball.png")]
		//public static var ballClass:Class;
		//adding emoticons
		[Embed (source = "assets/EmotionIcons.swf" , symbol = "Emoticon")]
		public static var emoticons:Class;
		
		[Embed (source = "assets/EmotionIcons.swf" , symbol = "smileWithSymbol")]
		public static var smilies:Class;
		
	
        [Embed(source = "assets/New Bingo Background.swf", symbol = "ButtonPrize")]
	    public static var filtersym :Class;
		
		[Embed(source = "assets/New Bingo Background.swf", symbol = "ChatonoffScreen")]
	    public static var chatOnOff :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "UserBlockSymbol")]
	    public static var userBlockSymbol :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "RedBall")]
	    public static var redBall :Class;
	
		[Embed(source = "assets/Bingo2.swf", symbol = "timerTxt")]
	    public static var clockT:Class;
		
		
		[Embed(source = "assets/Bingo2.swf", symbol = "AnnounceSymbol")]
	    public static var announceSymbol:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "textScreen")]
	    public static var  textS:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "ballgenrator")]
	    public static var  ballGenerate:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "Glass_background")]
	    public static var  glassB:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserScreen1")]
	    public static var userScreen1:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserScreen2")]
	    public static var userScreen2:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserScreen3")]
	    public static var userScreen3:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserScreen4")]
	    public static var userScreen4:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserScreen5")]
	    public static var userScreen5:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserScreen6")]
	    public static var userScreen6:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserScreen7")]
	    public static var userScreen7:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserScreen8")]
	    public static var userScreen8:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserScreenText_Duch")]
	    public static var userScreenText_Duch:Class;
	
		
		[Embed(source = "assets/Bingo2.swf", symbol = "UserSlider")]
	    public static var userSlider:Class;
		
		[Embed(source = "assets/New Bingo Background.swf", symbol = "NumberGenerator")]
	    public static var numberGenerator:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "BingoCard")]
		public static var card:Class;
		
		[Embed(source = "assets/New Bingo Background.swf", symbol = "LobbySlider")]
		public static var lobbyslider:Class;
		[Embed(source = "assets/Bingo2.swf" , symbol = "UserSymbol")]
		public static var userSymbol:Class;
		[Embed(source = "assets/Bingo2.swf" , symbol = "CloseB")]
		public static var closeB:Class;
		
	
		
		
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "onnotingame")]
		public static var OnNotInGame:Class;
		
		[Embed(source = "assets/New Bingo Background.swf", symbol = "BallScreen")]
	    public static var ballScreen:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "CashAmountScreen_Duch")]
	   public static var CashAmountScreen_Duch :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "GameAmountSymbol_Duch")]
	   public static var gameAmountSymbol_Duch :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "PattarnScreen_Duch")]
	    public static var patScreen_Duch:Class;
		[Embed(source = "assets/Bingo2.swf" , symbol = "BanedScreen_Duch")]
		public static var bannedScreen_Duch:Class;
		[Embed(source = "assets/Bingo2.swf" , symbol = "NotActiveScreen_Duch")]
		public static var nonActiveScreen_Duch:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "FunScreen_Duch")]
		public static var funScreen_Duch:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "pwinner_Duch")]
		public static var PWinner_Duch:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "bwinner_Duch")]
		public static var BWinner_Duch:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "RoomSymbol_Duch")]
   		public static var roomSymbolClass_Duch:Class;
		[Embed(source = "assets/Bingo2.swf" , symbol = "RoomBackGround_Duch")]
		public static var roomBG_Duch:Class;
	
		
		[Embed(source = "assets/Bingo2.swf", symbol = "LoginScreen_Duch")]
		public static var loginScreen_Duch:Class;
		
	
		[Embed(source = "assets/Bingo2.swf", symbol = "winnerCard_Duch")]
		public static var WinnerCard_Duch:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "winnerCard_German")]
		public static var WinnerCard_German:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "winnerCard_Spenish")]
		public static var WinnerCard_Spenish:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "WinSymbol")]
		public static var winnerInfo:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "WinSym")]
		public static var winSym:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "WinnerSlider")]
		public static var winnerSlider:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "ErrorLoginScreen_Duch")]
		public static var errorloginScreen_Duch:Class;
		//[Embed(source = "assets/New Bingo Background.swf", symbol = "Background_Duch")]
		//public static var gameScreen_Duch:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "GameScreen_Duch")]
		public static var gameScreen_Duch:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "SearchScreen_Duch")]
		public static var searchScreen_Duch:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "SearchScreen_Spenish")]
		public static var searchScreen_Spenish:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "SearchScreen_German")]
		public static var searchScreen_Germany:Class;
		
		[Embed(source = "assets/New Bingo Background.swf", symbol = "BingoWinnerScreen_Duch")]
		 public static var bingoWinnerScreen_Duch:Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "PatternWinnerScreen_Duch")]
		  public static var patternWinnerScreen_Duch:Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "CardBuyScreen_Duch")]
	    public static var buyCardScreen_Duch:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "MusicScreen_Duch")]
	    public static var musicScreen_Duch:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserClickedScreen_Duch")]
	    public static var userClickedScreen_Duch:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "PrivateChatScreen_Duch")]
	    public static var privateChatScreen_Duch:Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "BallGenerator")]
	    public static var ballGenerator:Class;
		//[Embed(source = "assets/Bingo2.swf", symbol = "PublicChatScreen_Duch")]
	    //public static var publicChatScreen_Duch:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "ConnectionBrokenScreen_Duch")]
	    public static var connectionBrokenScreen_Duch :Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "KassaScreen_Duch")]
	    public static var kassaScreen_Duch :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "CardContainer_Duch")]
	    public static var cardContainerButton_Duch:Class;
		
		
		[Embed(source = "assets/Bingo2.swf", symbol = "CashAmountScreen_Spenish")]
	    public static var CashAmountScreen_Spanish :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "GameAmountSymbol_Spenish")]
	    public static var gameAmountSymbol_Spanish :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "PattarnScreen_Spenish")]
	    public static var patScreen_Spanish:Class;
		[Embed(source = "assets/Bingo2.swf" , symbol = "BanedScreen_Spenish")]
		public static var bannedScreen_Spanish:Class;
		//[Embed(source = "assets/Bingo2.swf" , symbol = "NotActiveScreen_Spenish")]
		//public static var nonActiveScreen_Spanish:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "FunScreen_Spenish")]
		public static var funScreen_Spanish:Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "CardContainer_Spenish")]
	    public static var cardContainerButton_Spanish:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "pwinner_Spenish")]
		public static var PWinner_Spanish:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "bwinner_Spenish")]
		public static var BWinner_Spanish:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "RoomSymbol_Spenish")]
   		public static var roomSymbolClass_Spanish:Class;
		[Embed(source = "assets/Bingo2.swf" , symbol = "RoomBackGround_Spenish")]
		public static var roomBG_Spanish:Class;
		//[Embed(source = "assets/New Bingo Background.swf", symbol = "LoginScreen_Spenish")]
		//public static var loginScreen_Spanish:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "LoginScreen_Spenish")]
		public static var loginScreen_Spanish:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "ErrorLoginScreen_Spenish")]
		public static var errorloginScreen_Spanish:Class;
		//[Embed(source = "assets/New Bingo Background.swf", symbol = "Background_Spenish")]
		//public static var gameScreen_Spanish:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "GameScreen_Spenish")]
		public static var gameScreen_Spanish:Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "BingoWinnerScreen_Spenish")]
		 public static var bingoWinnerScreen_Spanish:Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "PatternWinnerScreen_Spenish")]
		  public static var patternWinnerScreen_Spanish:Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "CardBuyScreen_Spenish")]
	    public static var buyCardScreen_Spanish:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "MusicScreen_Spenish")]
	    public static var musicScreen_Spanish:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserClickedScreen_Spenish")]
	    public static var userClickedScreen_Spanish:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "PrivateChatScreen_Spenish")]
	    public static var privateChatScreen_Spanish:Class;
		//[Embed(source = "assets/New Bingo Background.swf", symbol = "BallGenerator")]
	   // public static var ballGenerator:Class;
		//[Embed(source = "assets/Bingo2.swf", symbol = "PublicChatScreen_Spenish")]
	   // public static var publicChatScreen_Spanish:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "ConnectionBrokenScreen_Spenish")]
	    public static var connectionBrokenScreen_Spanish :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "KassaScreen_Spenish")]
	    public static var kassaScreen_Spanish :Class;
		
		
		[Embed(source = "assets/Bingo2.swf", symbol = "CashAmountScreen_German")]
	     public static var CashAmountScreen_Germany :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "GameAmountSymbol_German")]
	    public static var gameAmountSymbol_Germany :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "PattarnScreen_German")]
	    public static var patScreen_Germany:Class;
		[Embed(source = "assets/Bingo2.swf" , symbol = "BanedScreen_German")]
		public static var bannedScreen_Germany:Class;
		//[Embed(source = "assets/Bingo2.swf" , symbol = "NotActiveScreen_German")]
	//	public static var nonActiveScreen_Germany:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "FunScreen_German")]
		public static var funScreen_Germany:Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "CardContainer_German")]
	    public static var cardContainerButton_Germany:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "pwinner_German")]
		public static var PWinner_Germany:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "bwinner_German")]
		public static var BWinner_Germany:Class;
		[Embed(source = "assets/New Bingo Background.swf" , symbol = "RoomSymbol_German")]
   		public static var roomSymbolClass_Germany:Class;
		[Embed(source = "assets/Bingo2.swf" , symbol = "RoomBackGround_German")]
		public static var roomBG_Germany:Class;
	//	[Embed(source = "assets/New Bingo Background.swf", symbol = "LoginScreen_German")]
	//	public static var loginScreen_Germany:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "LoginScreen_German")]
		public static var loginScreen_Germany:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "ErrorLoginScreen_German")]
		public static var errorloginScreen_Germany:Class;
		///[Embed(source = "assets/New Bingo Background.swf", symbol = "Background_German")]
		//public static var gameScreen_Germany:Class;
		
		
		[Embed(source = "assets/Bingo2.swf", symbol = "GameScreen_German")]
		public static var gameScreen_Germany:Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "BingoWinnerScreen_German")]
		 public static var bingoWinnerScreen_Germany:Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "PatternWinnerScreen_German")]
		  public static var patternWinnerScreen_Germany:Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "CardBuyScreen_German")]
	    public static var buyCardScreen_Germany:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "MusicScreen_German")]
	    public static var musicScreen_Germany:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "UserClickedScreen_German")]
	    public static var userClickedScreen_Germany:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "PrivateChatScreen_German")]
	    public static var privateChatScreen_Germany:Class;
		
		
		[Embed(source = "assets/Bingo2.swf", symbol = "ConnectionBrokenScreen_German")]
	    public static var connectionBrokenScreen_Germany :Class;
		[Embed(source = "assets/New Bingo Background.swf", symbol = "KassaScreen_German")]
	    public static var kassaScreen_Germany :Class;
		
	
		
		[Embed(source = "assets/Bingo2.swf", symbol = "container")]
	     public static var cardContainer:Class;
		 [Embed(source = "assets/Bingo2.swf", symbol = "vWinner")]
	     public static var vwinner:Class;
		 [Embed(source = "assets/Bingo2.swf", symbol = "fWinner")]
	     public static var fwinner:Class;
		 [Embed(source = "assets/Bingo2.swf", symbol = "sWinner")]
	     public static var swinner:Class;
		 
		 
		 
		[Embed(source = "assets/Bingo2.swf", symbol = "winnerMsg_Spenish")]
		public static var WinnerMsg_Spenish:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "winnerMsg_German")]
		public static var WinnerMsg_Germany:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "winnerMsg_Duch")]
		public static var WinnerMsg_Duch:Class;
		
		
		//public chat screen 
		
		[Embed(source = "assets/Bingo2.swf", symbol = "PublicChatScreen1")]
	    public static var publicChatScreen1:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "PublicChatScreen2")]
	    public static var publicChatScreen2:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "PublicChatScreen3")]
	    public static var publicChatScreen3:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "PublicChatScreen4")]
	    public static var publicChatScreen4:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "PublicChatScreen5")]
	    public static var publicChatScreen5:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "PublicChatScreen6")]
	    public static var publicChatScreen6:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "PublicChatScreen7")]
	    public static var publicChatScreen7:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "PublicChatScreen8")]
	    public static var publicChatScreen8:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "PublicChatScreenText_Duch")]
	    public static var publicChatScreenText_Duch:Class;
		
		[Embed(source = "assets/Bingo2.swf", symbol = "futureGameListScreen")]
	    public static var futureGameListScreen:Class;
		[Embed(source = "assets/Bingo2.swf", symbol = "cardspurchaseRoom")]
	    public static var cardspurchaseRoom:Class;
			
	}
}