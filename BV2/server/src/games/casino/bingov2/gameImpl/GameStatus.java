package games.casino.bingov2.gameImpl;
import java.util.ArrayList;
import java.util.HashMap;
import it.gotoandplay.smartfoxserver.data.User;
public class GameStatus {
  
	//user instance of the winner
	ArrayList<User> firstLineWinnerUsers;
	ArrayList<User> SecondLineWinnerUsers;
	ArrayList<User> bingoWinnerUsers;
	
	 /// info fro game record database use
	public String firstLineInfo;
    public String secondLineInfo;
    public String bingoInfo;
	/// winners card info for announcement use
	public String noOfFirstLineWinningCards;
	public String noOfSecondLineWinningCards;
	public String noOfBingoWinningCards;
	public int noOfFirstLineWinners;
	public int noOfSecondLineWinners;
	public int noOfBingoWinners;
	public String totalNoOfCardOfFirstLineWinner;
	public String totalNoOfCardOfSecondLineWinner;
	public String totalNoOfCardOfBingoWinner;
	public String firstLineWinnerCard; 
	public String secondLineWinnerCard; 
	public String BingoWinnerCard;
	//announceed status
	 boolean firstLineWinnerAnnounced;
     boolean secondLineWinnerAnnounced;
     boolean bWinnerAnnounced;
	// winner names
     public String firstLineWinnersName;
     public String secondLineWinnersName;
     public String bingoWinnersName;
     public String totalGeneratedNumbers;
     public int patternWinner;
     public int firstlineWinner;
     public int secondLineWinner;
     public int bingoWinner;
     public int noofSentBall;
    
     public int stateSend;
     int [] numberCollection=new int[90];
     public enum States {WAIT, TIMER, GAMEON };
     public States state;
     public HashMap<Integer,Player> firstLinePlayer; 
     public HashMap<Integer,Player> secondLinePlayer; 
     public HashMap<Integer,Player> bingoPlayer; 
     
 	private void suffle()
	{
		for(int i=0;i<90;i++)
		{	
		    int temp=0;
		    int first=(int)(Math.random()*90);
		    //System.out.print(first+"value of first************s");
		   // int second=(int)Math.random()*74;
		    temp=numberCollection[first];
		    numberCollection[first]=numberCollection[i];
		    numberCollection[i]=temp;
		}
		
	}
    boolean setNextNumber(String nu)
   	{
    	int num=Integer.parseInt(nu);
    	//System.out.print("next number function is called");
    	for(int i=noofSentBall;i<numberCollection.length;i++)
    	{
    		if(numberCollection[i]==num)
    		{
    			int temp=numberCollection[noofSentBall];
    			numberCollection[noofSentBall]=numberCollection[i];
    			numberCollection[i]=temp;
    			return true;
    			
    		}
    		
    	}
    	return false;
 		
 	}
 	
     GameStatus()
     {
    	  for(int i=0;i<90;i++)
    	  {
    		  numberCollection[i]=i+1;  
    	  }
    	 suffle();
    	 firstLinePlayer=new HashMap<Integer,Player>();
    	 secondLinePlayer=new HashMap<Integer,Player>();
    	 bingoPlayer=new HashMap<Integer,Player>();
    	 firstLineWinnerUsers= new ArrayList<User>();
         SecondLineWinnerUsers= new ArrayList<User>();
    	 bingoWinnerUsers= new ArrayList<User>();
    	 //patternWinner=-1;
       	 noofSentBall=0;
    	 totalGeneratedNumbers="";
    	 noOfFirstLineWinningCards="";
    	 noOfSecondLineWinningCards="";
    	 noOfBingoWinningCards="";
    	 firstLineWinnerAnnounced=false;
    	 secondLineWinnerAnnounced=false;
    	 bWinnerAnnounced=false;
    	 totalNoOfCardOfFirstLineWinner="";
         totalNoOfCardOfSecondLineWinner="";
          totalNoOfCardOfBingoWinner="";
    	 firstLineWinnersName="";
    	 secondLineWinnersName="";
    	 bingoWinnersName="";
    	 noOfFirstLineWinners=0;
    	 noOfSecondLineWinners=0;
    	 noOfBingoWinners=0;
    	 firstLineWinnerCard=""; 
    	 secondLineWinnerCard=""; 
    	 BingoWinnerCard="";
    	 stateSend=0;
    	 state=States.TIMER;
    	 
     }
     public int generatenumber()
     {    
    	    int k=numberCollection[noofSentBall];
    	   // System.out.print(k);
    	    noofSentBall++;
    	    if(totalGeneratedNumbers.equals(""))
    	    {
    	       totalGeneratedNumbers=Integer.toString(k);
    	    }
    	    else
    	    {
    	    	totalGeneratedNumbers+=","+k;	
    	    }
    	   return k;
     }
     public void  setFirstLineCardCount(int id)
 	{
 		if(firstLineWinnerAnnounced==false)
 		{
 				if(noOfFirstLineWinningCards=="")
 				{
 					noOfFirstLineWinningCards=Integer.toString(id);
 					
 				}
 				else
 				{
 					noOfFirstLineWinningCards=noOfFirstLineWinningCards+","+Integer.toString(id);
 				}
 				
 		}		
 			
 		
 	}
     public void  setSecondLineCardCount(int id)
  	{
  		if(secondLineWinnerAnnounced==false)
  		{
  				if(noOfSecondLineWinningCards=="")
  				{
  					noOfSecondLineWinningCards=Integer.toString(id);
  					
  				}
  				else
  				{
  					noOfSecondLineWinningCards=noOfSecondLineWinningCards+","+Integer.toString(id);
  				}
  				
  		}		
  			
  		
  	}
  	
 	
 	public void  setBingoCardCount(int id)
 	{
 		    if(bWinnerAnnounced==false)
 		   { 
 				if(noOfBingoWinningCards=="")
 				{
 					noOfBingoWinningCards=Integer.toString(id);
 					
 				}
 				else
 				{
 					noOfBingoWinningCards=noOfBingoWinningCards+","+Integer.toString(id);
 				}
 		   }
 		
 	}
 	public void setFirstLineWinner(String bc,Player p)
 	{
 		
 		String name=p.name;
		 int TotalNoOfCard=p.noOfcard;
		User u=p.user;
 		//System.out.print("name of  the winner||||||||||||||"+name);
 		if(firstLineWinnerAnnounced==false)
 		{
 			p.isFlineWinner=true;
			p.noOfFCard++;
			p.won=1;
 			if(firstLineWinnersName=="")
 			{
 				firstLineWinnersName=name;
 				totalNoOfCardOfFirstLineWinner=Integer.toString(TotalNoOfCard);
 				firstLineWinnerCard=bc;
 				firstLineInfo=name+":"+bc+"|";
 			}
 			else
 			{
 				firstLineWinnersName=firstLineWinnersName+","+name;
 				totalNoOfCardOfFirstLineWinner=totalNoOfCardOfFirstLineWinner+","+TotalNoOfCard;
 				 firstLineWinnerCard= firstLineWinnerCard+";"+bc;
 				firstLineInfo+=name+":"+bc+"|";
 			}
 			noOfFirstLineWinners++;
 			//setPatternCardCount(name);
 			firstLineWinnerUsers.add(u);
 			firstLinePlayer.put(p.serverId,p);
 		}
 		
 	}
 	public void setSecondLineWinner(String bc,Player p)
 	{
 		//System.out.print("name of  the winner||||||||||||||"+name);
 		String name=p.name;
		 int TotalNoOfCard=p.noOfcard;
		User u=p.user;
 		if(secondLineWinnerAnnounced==false)
 		{
 			p.isSlineWinner=true;
			p.noOfSCard++;
			p.won=1;
 			if(secondLineWinnersName=="")
 			{
 				secondLineWinnersName=name;
 				totalNoOfCardOfSecondLineWinner=Integer.toString(TotalNoOfCard);
 				secondLineWinnerCard=bc;
 				secondLineInfo=name+":"+bc+"|";
 			}
 			else
 			{
 				secondLineWinnersName=secondLineWinnersName+","+name;
 				totalNoOfCardOfSecondLineWinner=totalNoOfCardOfSecondLineWinner+","+TotalNoOfCard;
 				secondLineWinnerCard=secondLineWinnerCard+";"+bc;
 				secondLineInfo+=name+":"+bc+"|";
 			}
 			noOfSecondLineWinners++;
 			//setPatternCardCount(name);
 			SecondLineWinnerUsers.add(u);
 			secondLinePlayer.put(p.serverId,p);
 		}
 		
 	}
 	public void setBingoWinner(String bc,Player p)
 	{
 		//System.out.print("name of  the winner||||||||||||||"+name);
 		String name=p.name;
		 int TotalNoOfCard=p.noOfcard;
		User u=p.user;
 		if(bWinnerAnnounced==false)
 		{
 			p.isBingoWinner=true;
			p.noOfBCard++;
			p.won=1;
 			if(bingoWinnersName=="")
 			{
 				bingoWinnersName=name;
 				totalNoOfCardOfBingoWinner=Integer.toString(TotalNoOfCard);
 				BingoWinnerCard=bc;
 				bingoInfo=name+":"+bc+"|";
 			}
 			else
 			{
 				bingoWinnersName=bingoWinnersName+","+name;
 				totalNoOfCardOfBingoWinner=totalNoOfCardOfBingoWinner+","+TotalNoOfCard;
 				 BingoWinnerCard=BingoWinnerCard+";"+bc;
 				 bingoInfo+=name+":"+bc+"|";
 			}
 			noOfBingoWinners++;
 			//setBingoCardCount(name);
 			bingoPlayer.put(p.serverId,p);
 			bingoWinnerUsers.add(u);
 			 
 		}
 		
 	}
          
}
