package  
{
	/**
	 * ...
	 * @author dwijendra
	 */
	public class GetDisplayObject
	{
		public static var i:int = 1;
		 public static var paymentArray:Array = ["https://secure.payments4all.com/es/", "http://www.myglobalgames.com/opwaarderen/", "https://secure.payments4all.com/de/"];
		public static var registerArray:Array = ["http://www.myglobalgames.com/aanmelden/", "http://www.myglobalgames.com/aanmelden/", "http://www.myglobalgames.com/aanmelden/"];
	    public static var pwd:Array = ["http://www.myglobalgames.com/wachtwoord-vergeten/", "http://www.myglobalgames.com/wachtwoord-vergeten/", "http://www.myglobalgames.com/wachtwoord-vergeten/"];
		public static var bonus1:Array = [ "Felicidades MyGlobalGames (€","Gefeliciteerd MyGlobalGames heeft (€","Herzlichen Glückwunsch MyGlobalGames (€"];
		public static var bonus2:Array = [")se ha sumado a la cantidad de Bingo.", ")toegevoegd aan het Bingo bedrag.", ")hat den Betrag Bingo hat"];
	    public static var profileArray:Array = ["http://www.myglobalgames.es/pg/profile/", "http://www.myglobalgames.com/speler/", "http://www.myglobalgames.de/pg/profile/"];
		public static var BalanceRequestArray:Array = ["http://omega.myglobalgames.es", "http://omega.globalstarsgames.com", "http://omega.myglobalgames.de"];
		public static var winAnnounce1:Array = [ "Felicidades ","Gefeliciteerd ","Glückwünsche "];
		public static  var fwinAnnounce2:Array = [" la primera línea de €", " met het eerste lijn bedrag van €", " die erste Zeile von €"];
		public static  var swinAnnounce2:Array = [" la segunda línea de €", " met het tweede lijn bedrag van €", " In der zweiten Zeile von €"];
		public static  var bwinAnnounce2:Array = [" tarjeta con el importe total de €", " met het volle kaart bedrag van €", " Karte mit den vollen Betrag von €"];
		public static var winInotherRoomInfo1:Array = ["", "u heeft","Sie haben" ];
		public static var winInotherRoomInfo2:Array = ["euros que ganó en la habitación","euro gewonnen in zaal","Euro gewonnen in Raum"];
		//public static var lng:String="_Spanish";
         //public static var lng:String="_Germany";
        public static var lng:String = "_Dutch"
        public static function setType():void
		{
			if (lng == "_Spanish")
			{
				i = 0;
			}
			if (lng == "_Dutch")
			{
				lng = "_Duch";
				i = 1;
			}
			if (lng == "_Germany")
			{
				i = 2;
			}
		}
	    public static function getBonusP1():String
		{
			return bonus1[i];
		}
		 public static function getBalanceRequestURL():String
		{
			return BalanceRequestArray[i];
		}
		 public static function getBonusP2():String
		{
			return bonus2[i];
		}
		public static function winAnnounceP1():String
		{
			return winAnnounce1[i];
		}
		public static function fwinAnnounceP2():String
		{
			return fwinAnnounce2[i];
		}
		public static function swinAnnounceP2():String
		{
			return swinAnnounce2[i];
		}
		public static function bwinAnnounceP2():String
		{
			return bwinAnnounce2[i];
		}
		public static function getORoomWin1():String
		{
			return winInotherRoomInfo1[i];
		}
		public static function getORoomWin2():String
		{
			return winInotherRoomInfo2[i];
		}
		
	     public static function getProfileArray():String
		{
			return profileArray[i];
		}
		public function GetDisplayObject() 
		{
			
		}
		public static function getPath(cmd:int):String
		{
			setType();
			if (cmd == 1)
			{
				return pwd[i];
			}
			if (cmd == 2)
			{
				return registerArray[i];
			}
			return "0"
			
		}
		 public static function getPaymentArray():String
		{
			return paymentArray[i];
		}
		public static function getSymbol(str:String):*
		{
			var Symbol:*=new Resources[str+lng]();
			return Symbol;
			
		}
		
			
	}

}