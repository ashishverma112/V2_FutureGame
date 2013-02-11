package games.casino.bingov2.gameImpl;
import java.util.*;

import games.casino.bingov2.gameImpl.CardPage;
import it.gotoandplay.smartfoxserver.data.User;

public class Player {
	    //public int eachUserId; 
	    public User user; 
	    public int serverId;
	    public String name;
	    public boolean isRealP;
	    public boolean isOnlineP;
	    public int noOfFCard;
	    public int noOfSCard;
	    public int noOfBCard;
	    public int noOfcard;
	    public boolean isFlineWinner;
	    public boolean isSlineWinner;
	    public boolean isBingoWinner;
	    public Double amountInGame;
	    public int won;
	
	    public  boolean isAutomate;
	    public String totalNumberIncards;
	    public ArrayList<CardPage> cardArray=new ArrayList<CardPage>();
	   
	 Player(User u)
	{
		// eachUserId=0;
		  user=u;
		 isAutomate=true;
		 totalNumberIncards="";
		 this.name=u.getVariable("name").getValue();
		 won=0;
		 noOfFCard=0;
		 noOfSCard=0;
		 noOfBCard=0;
		 isFlineWinner=false;
		 isSlineWinner=false;
		 isBingoWinner=false;
          amountInGame=0.0;
		// this.isRealP=u.getVariable("isReal").getBooleanValue();
		// System.out.print("name of the user++++++++"+name);
		 this.isRealP=true;
	     serverId=u.getVariable("id").getIntValue();
		 isOnlineP=true;
		 noOfcard=0;
	}
	 Player(int id,String name)
	 {
		 this.name=name;
		 isOnlineP=false;
		 serverId=id;
		 isAutomate=true;
		 totalNumberIncards="";
		 won=0;
		 noOfFCard=0;
		 noOfSCard=0;
		 noOfBCard=0;
		 isFlineWinner=false;
		 isSlineWinner=false;
		 isBingoWinner=false;
         amountInGame=0.0;
         noOfcard=0;
	 }
	 public void marknum( CardPage cp,String totalgeneratednum,int presentstatus)
	 {
		 if(totalgeneratednum.equals(""))
			 return;
		  String numcl[]=totalgeneratednum.split(",");
		  for(int i=0;i<numcl.length;i++)
		  {
			  cp.markNumberInCards(Integer.parseInt(numcl[i]),1);
		  }
	 }
	 
	 public void purchageCard(int i,String totalgeneratednum,int presentstatus)
		{
			       noOfcard+=i;
			       String NumbersInCards="";
			       for(int k=0;k<i;k++)
			       {
			    	   CardPage card=new CardPage();
			    	   marknum(card,totalgeneratednum,presentstatus);
			    	   if (k == 0)
			    		   NumbersInCards+= card.pageString;
			    	   else
			    		   NumbersInCards+= "*" + card.pageString;
			    	   
			    	
			    	   //NumbersInCards+=card.pageString;
			    	   cardArray.add(card);
			       }
			       if(totalNumberIncards=="")
			       {
			    	   totalNumberIncards=NumbersInCards;
			       }
			       else
			       {
			    	   totalNumberIncards=totalNumberIncards+"*"+NumbersInCards;
			       }
			//totalNumberIncards+=NumbersInCards;
	        // return NumbersInCards;
	    }

	public void reset()
	{
		cardArray=new ArrayList<CardPage>();
		totalNumberIncards="";
		 //amountInGame=0.0;
		 won=0;
		 noOfFCard=0;
		 noOfSCard=0;
		 noOfBCard=0;
		 isFlineWinner=false;
		 isSlineWinner=false;
		 isBingoWinner=false;
		
	}

	
}