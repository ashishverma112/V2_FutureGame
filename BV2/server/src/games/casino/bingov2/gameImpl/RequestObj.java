package games.casino.bingov2.gameImpl;
import it.gotoandplay.smartfoxserver.data.User;
public class RequestObj {
	static public enum RequestType {ADD_PLAYER, ADD_BOOKS, RESET_PRICE, SET_WINNERS, HIGHPRICE_FIX};

	public User userobj;
	//
	//public int toRoom;
	public RequestType rqtype;
	//public Player newPlayer;
	//public int playerid;
	//public int numBooks;
	public int newBooks;
	//public double gamePrice;
	//public int rid;	
	//public int fixNumber;
    public Double totalPrice;
   
   
}
