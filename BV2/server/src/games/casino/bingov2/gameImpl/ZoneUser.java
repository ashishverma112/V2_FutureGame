package games.casino.bingov2.gameImpl;

public class ZoneUser 
{
	
          public Player[] roomInstance;
          ZoneUser()
          {
        	  roomInstance=new Player[5];
        	  for(int i=0;i<5;i++)
        	  {
        		  roomInstance[i]=null;
        	  }
          }
          public void updatePlayer(Player pl,int i)
          {
        	roomInstance[i]=pl;  
          }
          public void removePlayer(int i)
          {
        	  roomInstance[i]=null;    
          }
       
          public String GetcardNos()
          {
        	  String str="";
        	  for(int i=0;i<5;i++)
        	  {
        		if(i==0)
                {
        			if(roomInstance[i]!=null)
        			{
        				str= Integer.toString(roomInstance[i].noOfcard);
        			}
        			else
        				str="-1";
        			
        		}
        		else
        		{
        			if(roomInstance[i]!=null)
        			{
        				str=str+","+ Integer.toString(roomInstance[i].noOfcard);
        			}
        			else
        				str=str+","+"-1";
        			
        		}
        		
        	  }
        	return  (roomInstance[0].noOfcard+","+roomInstance[1].noOfcard+","+roomInstance[2].noOfcard +","+roomInstance[3].noOfcard+","+roomInstance[5].noOfcard);
          }
    

}
