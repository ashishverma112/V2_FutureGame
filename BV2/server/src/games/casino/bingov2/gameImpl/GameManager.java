package games.casino.bingov2.gameImpl;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.data.UserVariable;
//import it.gotoandplay.smartfoxserver.extensions.ExtensionHelper;
import games.casino.bingov2.gameImpl.BingoDbm;
import games.casino.bingov2.gameImpl.GameStatus;
import games.casino.bingov2.gameImpl.GameStatus.States;
import games.casino.bingov2.gameImpl.Player;
import it.gotoandplay.smartfoxserver.util.scheduling.Scheduler;
import it.gotoandplay.smartfoxserver.util.scheduling.Task;
import it.gotoandplay.smartfoxserver.util.scheduling.ITaskHandler;
import it.gotoandplay.smartfoxserver.data.RoomVariable;
public class GameManager 
{	
	  BingoMain main;
	  Scheduler scheduler;
      ITaskHandler handler;
      public Double totalStakeAmount;
      int noOfPlayer=0;
      long timer;
     // int _currentEachUserInfoId;
      private Date startTime;
      public BingoDbm bingoDbm;
      String game_info[];
      int thisRoomID;
      public double fullSetMoney ;
  	  public double firstLineMoney;
  	  public double secondLineMoney;
  	  double _fWinAmount;
	  double _sWinAmount;
	  double _bWinAmount;
      int presentWinningStatus;
      int minPlayerRequired=1;
      String patternString;
      int ballGenDif=5;
      int timeBetweenBalls =9;
      int total_books=0;
     // public HashMap<Integer,Player> playersHash;
      public ConcurrentHashMap<Integer,Player> players;
     // public static  int Pattern;
      GameStatus game;
     
      GameManager(BingoMain v2,BingoDbm pbingodbm)
      {
    	 // System.out.print("++++++++++++++++++game manager is called++++++++++++++++++++");
    	// _currentEachUserInfoId=0;
    	  startTime=new Date();
    	  bingoDbm=pbingodbm;
    	  game_info=new String[13];
      	  game=new GameStatus();
      	  total_books=0;
      	  this.main=v2;
      	  presentWinningStatus=0;
      	  SetPrizes();
          minPlayerRequired=main.gameRoom.getVariable("minpl").getIntValue();
          main.gameId=Integer.parseInt(main.gameRoom.getVariable("gameId").getValue());
          totalStakeAmount=0.0;
      	  timer = main.inBetweenRoomTimerValue;
      	  timeBetweenBalls=main.gameRoom.getVariable("TI").getIntValue();
          // timer=1;
      	// System.out.println("gsdfkjgsd"+timeBetweenBalls);
      	  game.state=States.TIMER;
          init();
         // initializeGameinfo();		
      }
      
      public void SetPrizes()
      {
   	      firstLineMoney=Double.parseDouble(main.PRIZE1[main._round-1]);
          secondLineMoney=Double.parseDouble(main.PRIZE2[main._round-1]);
          fullSetMoney=Double.parseDouble(main.PRIZE3[main._round-1]);
         
      }
   
      
      public double roundOff(Double val, int n) 
  	   {
  		long v1=(long)(val*Math.pow(10,n));
  		double v2=val*Math.pow(10,n)-v1;
  		if(v2>=.5)
  		{
  			v1=v1+1;
  		}
  		return (double)v1/Math.pow(10,n);
  		
  	}
      public void setOfline(int id)
      {
    	  if(players.containsKey(id))
    	  {
    	  Player tempPlayer=players.get(id);
    	  tempPlayer.isOnlineP=false;
    	  }
    	  
      }
      public String getTotalPlayersName()
  	{
  		String name="";
  		Set  set = players.entrySet();
  		Iterator<Map.Entry<Integer, Player>> playerIter = set.iterator();
  		while(playerIter.hasNext())
  		{
  			Map.Entry<Integer, Player> tmpEntry = (Map.Entry<Integer, Player>)playerIter.next();
  			Player tmpPlayer = tmpEntry.getValue();
  			if(name=="")
  			{
  				 name=tmpPlayer.name;
  			}
  			else
  			{
  				 name=tmpPlayer.name+","+name;
  			}
  			//if(!tmpPlayer.isOnlineP)
  			
  			
  		} 
  		//System.out.print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&s"+name);
  		return name;
  	}
    public String setOnline(int id,User u)
    {
    	//System.out.print("set on line  is called");
    	if(players.containsKey(id))
    	{
    	Player tempPlayer=players.get(id);
    	tempPlayer.isOnlineP=true;
        u.setVariable("id",Integer.toString(id),UserVariable.TYPE_STRING);
    	tempPlayer.user=u;
    	//tempPlayer.name=u
    	}
    	String str=getgamestatus(id);
    	return str;
    	
    }
    public void setAutomate(int id)
    {
    	if(players.containsKey(id))
    	{
    	Player tmpPlayer=players.get(id);
    	tmpPlayer.isAutomate=!tmpPlayer.isAutomate;
    	}
    	
    }

      
      private Player addPlayer(User u)
      {
      	Player abc=new Player(u);
      	int sid=u.getVariable("id").getIntValue();
      	players.put(sid,abc);
      	noOfPlayer++;
      	//System.out.print("add player is called"+noOfPlayer);
      	return abc;
      	
      }
      public void addAutomatePlayer(Player tmpPlayer)
      {
    	  players.put(tmpPlayer.serverId,tmpPlayer);
    		noOfPlayer++;
    		setcplRoomVariable();
  	   
      }
      public void setcplRoomVariable()
  	{
  		HashMap<String,RoomVariable> roomVarMap=new HashMap<String,RoomVariable>(); 
  		RoomVariable cplVar = new RoomVariable(Integer.toString(noOfPlayer),"n",null,true,true);
  		roomVarMap.put("cpl", cplVar);
  		main.helper.setRoomVariables(main.gameRoom, null,roomVarMap, true, true);		
  		
  	}
      public String getgamestatus(int i)
      {
    	  
    	  String res="";
    	  
  		res=game.firstLineWinnersName+":"+game.firstLineWinnerCard+":"+game.totalNoOfCardOfFirstLineWinner+":"+game.noOfFirstLineWinningCards+":"+_fWinAmount+"@"+game.secondLineWinnersName+":"+game.secondLineWinnerCard+":"+game.totalNoOfCardOfSecondLineWinner+":"+game.noOfSecondLineWinningCards+":"+_sWinAmount+"@"+game.bingoWinnersName+":"+game.BingoWinnerCard+":"+game.totalNoOfCardOfBingoWinner+":"+game.noOfBingoWinningCards+":"+_bWinAmount+"@"+Integer.toString(game.noofSentBall)+"@"+game.totalGeneratedNumbers; 
  		if(!players.containsKey(i))
  		{
  			return res;
  		}
  		else
  		{
  			Player tempPlayer=players.get(i);
  			res+="@"+tempPlayer.totalNumberIncards;
  			//System.out.print("cad no++++"+tempPlayer.totalNumberIncards+"++++ cr no");
  			
  		}
  		return res;
    	
      }
      public Boolean purchageCardByDB(int userid,String name,int noofbook,Double amount)
      {
    	   Player pl=new Player(userid,name);
        	//int sid=u.getVariable("id").getIntValue();
    	  // System.out.println("hi playeradd"+userid);
        	players.put(userid,pl);
        	noOfPlayer++;
        	total_books += noofbook;
        	pl.purchageCard(noofbook,game.totalGeneratedNumbers,presentWinningStatus+1);
        	bingoDbm.insertIntoIn_btw_cards(main.rId,main.gameId,userid,noofbook);
        	pl.amountInGame+=amount;
	      	totalStakeAmount+=amount;
    	  
		   return true;
      }
      public String purchageCard(int noOfCard,User u,Double amount,Boolean isfreshPurchase)
  	  {  
  		try{
    	      	int flag=0;
    	      	//System.out.print("-------------add player is called---------");
    	      	Player pl=null;
    	      	Player player=null;
    	      	int sid=u.getVariable("id").getIntValue();
    	      	String response="";
    	      	total_books += noOfCard;
    	      	if(!players.containsKey(sid))
    	      	{
    	      		 player=addPlayer(u); 
       	      	}
    	      	else
    	      	{
    	      		 player=players.get(sid);
    	      	}
       	      	player.purchageCard(noOfCard,game.totalGeneratedNumbers,presentWinningStatus+1);
       	      	if(isfreshPurchase)
       	      	{
       	      	 bingoDbm.insertIntoIn_btw_cards(main.rId,main.gameId,sid,noOfCard);
       	      	}
    	      	player.amountInGame+=amount;
    	      	totalStakeAmount+=amount;
    	      	return "1";
  			}
  		catch (Exception e)
  		{
  			System.out.print("what is this man");
			return "0";
		}
  		
   	}
      public void isOnline(int sid ,boolean status)
      {
      	Player player= players.get(sid);
      	player.isOnlineP=status;
      	
      }
      public void isRealPlayer(int sid ,boolean status)
      {
      	Player player= players.get(sid);
      	player.isRealP=status;
      	
      }
      private void updateGameinfo()
		{
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat( "yyyy-MM-dd HH:mm:ss" );   
		     String sdate=sdf.format(startTime); 
		    game_info[0]=Integer.toString(main._round); 
			game_info[1]=main.gameRoom.getVariable("rid").getValue();//roomid
			game_info[2]=sdate;//START_TIME
			game_info[3]= Double.toString(firstLineMoney);////FIRSTLINE_AMOUNT
			game_info[4]=Double.toString(secondLineMoney);////SECOUNDLINE_AMOUNT
			game_info[5]=Double.toString(fullSetMoney);//BINGO_AMOUNT
			game_info[6]=game.firstLineInfo;//FIRSTLINE_WINNER
			game_info[7]=game.secondLineInfo;//SECOUNDLINE_WINNER
			game_info[8]=game.bingoInfo;//BINGO_WINNER
			game_info[9]=game.totalGeneratedNumbers;//ALLBALLS
			game_info[10]=Integer.toString(noOfPlayer);//TOTAL_PLAYERS
			game_info[11]=Integer.toString(total_books);//TOTAL_BOOKS
			game_info[12]=Double.toString(totalStakeAmount);//TOTAL_STAKE
			bingoDbm.updateGameRecord(game_info,main.gameId);
		}
        public void updateUserWinVariable(User u,Double amount)
      	{
  		   // System.out.print("++++++++++user is on line+++++++++++++");
  			 Double CashBalance =Double.valueOf(u.getVariable("cashB").getValue().trim()).doubleValue();
  			 Double winBalance =Double.valueOf(u.getVariable("winB").getValue().trim()).doubleValue(); 
  			 int uid=u.getVariable("id").getIntValue();
  			 winBalance+=amount;
  			 winBalance=roundOff(winBalance,2);
  			 bingoDbm.setBalance(uid, CashBalance, winBalance);
  			 u.setVariable("winB",Double.toString(winBalance),UserVariable.TYPE_STRING);
  			 main.sendResponseToUser(21,Double.toString(CashBalance)+","+Double.toString(winBalance),u);
  					
  	   }
        public void sendWinOutRequest(int i)
    	{
    		//for first line  winner i=1
    		//for second line winner i=2
        	//for bingowinner i=3
    		Set  set;
    		if(i==1)
    		{
    	      set = game.firstLinePlayer.entrySet();
    		}
    		else if(i==2)
    		{
    			set=game.secondLinePlayer.entrySet();
    		}
    		else
    		{
    			set=game.bingoPlayer.entrySet();
    		}
    		
    		Iterator<Map.Entry<Integer, Player>> playerIter = set.iterator();
    		main.automatePlayers=new ConcurrentHashMap<Integer,Player>();
    		while(playerIter.hasNext())
    		{
    			     Map.Entry<Integer, Player> tmpEntry = (Map.Entry<Integer, Player>)playerIter.next();
    				Player tmpPlayer = tmpEntry.getValue();
    		   		 User juser=tmpPlayer.user;
    		    	int id=juser.getVariable("id").getIntValue();
    		    	  if(tmpPlayer.isFlineWinner &&(i==1))
		               {
		               // main.sendOutRequest(juser,0.0,roundOff(_fWinAmount*tmpPlayer.noOfFCard,2));
    		    		  main._cch.addAmount(id,tmpPlayer.name, 0.0, roundOff(_fWinAmount*tmpPlayer.noOfFCard,2));
  		               }
		               if(tmpPlayer.isSlineWinner&& (i==2))
		               {
		            	  // System.out.print("bingo out winner is called"+roundOff(_bWinAmount*tmpPlayer.noOfbCard,2));
		            	//main.sendOutRequest(juser,0.0,roundOff(_sWinAmount*tmpPlayer.noOfSCard,2));
		            	  main._cch.addAmount(id,tmpPlayer.name, 0.0,roundOff(_sWinAmount*tmpPlayer.noOfSCard,2));
		            	  
		               }
		               if(tmpPlayer.isBingoWinner&& (i==3))
		               {
 		            	  // main.sendOutRequest(juser,0.0,roundOff(_bWinAmount*tmpPlayer.noOfBCard,2));
 		            	  main._cch.addAmount(id,tmpPlayer.name, 0.0,roundOff(_bWinAmount*tmpPlayer.noOfBCard,2));
  		               }
		         
    		    	 if((main.currentZone.getUserByName(tmpPlayer.name)!=null))
    		    		{
    		    		 juser= main.currentZone.getUserByName(juser.getName());
    		    		 if(tmpPlayer.isFlineWinner &&(i==1))
    		              {		                	
    		       	    	 //updateUserWinVariable(juser,_fWinAmount*tmpPlayer.noOfFCard);  
    		       	    	if(!tmpPlayer.isOnlineP)
    		       	    	{
    		       	    		main.sendResponseToUser(123,_fWinAmount*tmpPlayer.noOfFCard+"@"+main.gameRoom.getName(), juser);
    		       	    	}
    		    					
    		    						            
    		              }
    		               if(tmpPlayer.isSlineWinner && (i==2))
    		               {
    		            	  // updateUserWinVariable(juser,_sWinAmount*tmpPlayer.noOfSCard);
    		            	   if(!tmpPlayer.isOnlineP)
    			       	    	{
    			       	    		main.sendResponseToUser(123,_sWinAmount*tmpPlayer.noOfSCard+"@"+main.gameRoom.getName(), juser);
    			       	    	}
    			    					
    		               }
    		               if(tmpPlayer.isBingoWinner && (i==3))
    		               {
    		            	 // updateUserWinVariable(juser,_bWinAmount*tmpPlayer.noOfBCard);
    		            	   if(!tmpPlayer.isOnlineP)
    			       	    	{
    			       	    		main.sendResponseToUser(123,_bWinAmount*tmpPlayer.noOfBCard+"@"+main.gameRoom.getName(), juser);
    			       	    	}
    			    					
    		               }
    		             
    		    		}
    		    	
    		    }
    		
    	}

	  class MyTaskHandler implements ITaskHandler
      {
		  
			
			public void checkAndAnnounceWinners()
			{
				String	sstr="";
				if(game.firstLineWinnerAnnounced==false&&game.firstLineWinnersName!="")
				{
					_fWinAmount= roundOff(firstLineMoney/game.noOfFirstLineWinners, 2);
					
					sstr=game.firstLineWinnersName+":"+game.firstLineWinnerCard+":"+game.totalNoOfCardOfFirstLineWinner+":"+game.noOfFirstLineWinningCards+":"+_fWinAmount+":"+game.totalGeneratedNumbers;
					game.firstLineWinnerAnnounced=true;
					sendWinOutRequest(1);
					main.sendResponseToAll(13,sstr);
				}
				if(game.secondLineWinnerAnnounced==false&&game.secondLineWinnersName!="")
				{
					_sWinAmount= roundOff(secondLineMoney/game.noOfSecondLineWinners, 2);
					
					sstr=game.secondLineWinnersName+":"+game.secondLineWinnerCard+":"+game.totalNoOfCardOfSecondLineWinner+":"+game.noOfSecondLineWinningCards+":"+_sWinAmount+":"+game.totalGeneratedNumbers;
					//updateUserWinVariable(game.firstLineWinnerUsers, _fWinAmount);
				//	 System.out.print("secondline winner declared................."+game.secondLineWinnersName);
					
					game.secondLineWinnerAnnounced=true;
					sendWinOutRequest(2);
					main.sendResponseToAll(14,sstr);
					// main.sendInfoToZone("3",game.secondLineWinnersName+"@"+_sWinAmount);
				}
				if(game.bWinnerAnnounced==false &&game.bingoWinnersName!="")
				{
					sstr="";
					 _bWinAmount=roundOff(fullSetMoney/game.noOfBingoWinners, 2);
					
					// _bWinAmount+=Double.valueOf(main.gameRoom.getVariable("bonus").getValue().trim()).doubleValue();
					// System.out.print( _bWinAmount+"bingo win amount");
				   game.bWinnerAnnounced=true;
				   sstr=game.bingoWinnersName+":"+game.BingoWinnerCard+":"+game.totalNoOfCardOfBingoWinner+":"+game.noOfBingoWinningCards+":"+_bWinAmount+":"+game.totalGeneratedNumbers;
				  // main.sendInfoToZone("4",game.bingoWinnersName+"@"+_bWinAmount);
				   sendWinOutRequest(3);
				   main.sendResponseToAll(15,sstr);
				   updateGameinfo();
				}
			}

		  public void setGameOver()
	    	{
			  	destroy();
			     Set  set = players.entrySet();
			  	Iterator<Map.Entry<Integer, Player>> playerIter = set.iterator();
			  	//game.state=States.GAMEON;
			  	game.stateSend=1;
			  	//if(game.noofSentBall>=90||game.patternWinner>0 && game.bingoWinner>0)
			  	//{
			  		main.automatePlayers=new ConcurrentHashMap<Integer,Player>();
			  		
			  		
			  		    while(playerIter.hasNext())
			  		   {
			  			  Map.Entry<Integer, Player> tmpEntry = (Map.Entry<Integer, Player>)playerIter.next();
			  			  Player tmpPlayer = tmpEntry.getValue();
			  			//_currentEachUserInfoId=bingoDbm.getmaxidfromEachuserinfo(main._round,tmpPlayer.name,main.gameId);
			  			  bingoDbm.inserteachUserInfo(tmpPlayer.name,main.gameId,main._round,tmpPlayer.noOfcard,tmpPlayer.totalNumberIncards, tmpPlayer.won, Double.toString(tmpPlayer.amountInGame));
			  			  tmpPlayer.reset();
			  			  main.automatePlayers.put(tmpPlayer.serverId, tmpPlayer);
			  			if((main._round==main._maxRound) &&(main.currentZone.getUserByName(tmpPlayer.name)!=null))
			  			{
			  				tmpPlayer.user=main.currentZone.getUserByName(tmpPlayer.name);
			  			    String NoOfBookVar=tmpPlayer.user.getVariable("NofB").getValue();
						    NoOfBookVar=NoOfBookVar.substring(0,main.rId)+"0"+NoOfBookVar.substring(main.rId+1);
						    tmpPlayer.user.setVariable("NofB",NoOfBookVar,UserVariable.TYPE_STRING);
						   //main.helper.joinRoom(tmpPlayer.user,gameRoom.getId(),helper.getZone(getOwnerZone()).getRoomByName("Lobby1").getId(), true,"", false,true);
			  			 // jai ho
			  		    }
			  			  
			  				
			  		   }
			  		  game.state=States.TIMER; 
			  				
			  		main.destroyGame();
			  		
 			  		//gameend
     			}
		
		public void generateNumbersAndMarkCards()
		{
			  if(game.bWinnerAnnounced)
				return;
			  Set  set = players.entrySet();
			  Iterator<Map.Entry<Integer, Player>> playerIter = set.iterator();
			  int num=game.generatenumber();
			  //System.out.print("number is"+num);
		      main.sendResponseToAll(3,Integer.toString(num));
		  	
			while(playerIter.hasNext())
			{
				Map.Entry<Integer, Player> tmpEntry = (Map.Entry<Integer, Player>)playerIter.next();
				Player tmpPlayer = tmpEntry.getValue();
				//System.out.print("=======player name====="+tmpPlayer.name+"playre size"+players.size());
				int noOfFirstLineWinningCard=0;
				int noOfSecondLineWinningCard=0;
				int noOfbingoWinningCard=0;
				for(int i=0;i< tmpPlayer.cardArray.size();i++)
				{
					    //System.out.print("=======size====="+tmpPlayer.cardArray.get(i).markNumberInCards(num,0));
					int winnerType=tmpPlayer.cardArray.get(i).markNumberInCards(num,presentWinningStatus+1);
				//=winnerType;
					if(winnerType==1)
					{
						
					    //System.out.print("+++right+++"+tmpPlayer.name);
						noOfFirstLineWinningCard++;
						game.setFirstLineWinner(tmpPlayer.cardArray.get(i).curWinCardString,tmpPlayer);
					}
					else if(winnerType==2)
					{
						
						noOfSecondLineWinningCard++;
						game.setSecondLineWinner(tmpPlayer.cardArray.get(i).curWinCardString,tmpPlayer);
					}
					else if(winnerType==3)
					{
						
						noOfbingoWinningCard++;
						game.setBingoWinner( tmpPlayer.cardArray.get(i).curWinCardString,tmpPlayer);
					}
					 
		     	}
				if(noOfFirstLineWinningCard!=0)
				{
					
					game.setFirstLineCardCount(noOfFirstLineWinningCard);
					noOfFirstLineWinningCard=0;
				}
				if(noOfSecondLineWinningCard!=0)
				{
					
					game.setSecondLineCardCount(noOfSecondLineWinningCard);
					noOfSecondLineWinningCard=0;
				}
				if(noOfbingoWinningCard!=0)
				{
					
					game.setBingoCardCount(noOfbingoWinningCard);
					noOfbingoWinningCard=0;
				}
				
			}
		    if(game.noOfFirstLineWinners>0)
		    {
		    	presentWinningStatus=1;
		    }
		    if(game.noOfSecondLineWinners>0)
		    {
		    	presentWinningStatus=2;
		    }
		    if(game.noOfBingoWinners>0)
		    {
		    	presentWinningStatus=3;
		    }
		}
		public void doTimerTask()
		{
			//
			  if(timer>=0)
        	  {
			    main.sendResponseToAll(0, Long.toString(timer));
                timer--;
             //  System.out.print("timer++"+timer);
               return;
                   
        	  }
			  else if(noOfPlayer<minPlayerRequired)
        	  {
				 // System.out.print("noof player"+noOfPlayer+"min player"+minPlayerRequired);
        		  timer=60;
        		  main.sendResponseToAll(0, Long.toString(timer));
        		 // System.out.print("min player++"+timer);
        		  timer--;
        		  return;
        	  }
			  else
        	  {
				 // System.out.print("noof player"+noOfPlayer+"min player"+minPlayerRequired);
			//	 System.out.print("game on++");
				  main.setGameStatus(0);
        		  game.state=States.GAMEON;
        		  if(main._round==1)
        		  {
        		     main.callSendInfoToZone();	  
        		  }
        		  startTime=new Date();
        	  }
			  
			
		}
		
		
		  
              public void doTask(Task task) throws Exception
              {
            	  if(game.state==States.TIMER)
            	  {
            		 doTimerTask(); 
            	  }
            	  else if(game.state==States.GAMEON)
            	  {
            		 doGameOnTask();
            		           		  
            	  }
            	  else
            	  {
            		  
            	  }
                    


              }
              public void doGameOnTask()
              {
            	  ballGenDif--;
            	  if(ballGenDif==0)
            	  {
            	      if(game.bWinnerAnnounced==true)
            	        {
            		//  System.out.print("++++++++++++++++++restart is callled++++++++++++++++++");
            		     setGameOver();
            	        }
            	      else
            	      {
            		     checkAndAnnounceWinners(); 
            		     if (game.bWinnerAnnounced)
            		     {
            					ballGenDif = 7;
            					return;
            			 } 
            		      generateNumbersAndMarkCards();
            		      if(game.noOfBingoWinners>0)
            		      {
            		    	  ballGenDif = 10;
          					  return;
            		      }
            		      
            	       }
            	       ballGenDif=timeBetweenBalls;
            	       
            	
            	       
            	      }
            	
              }
                    			
              
 }

	  public void init()
      {
		  players =new ConcurrentHashMap<Integer,Player>();
              scheduler = new Scheduler();
              handler = new MyTaskHandler();
              Task generateBall = new Task("generateBall");
              Task TimerTask = new Task("TimerTask");
              scheduler.addScheduledTask(generateBall, 1, true, handler);
              //scheduler.addScheduledTask(TimerTask, 5, false, handler);
              scheduler.startService();
    
      }
	  private void updateRoomVariableString(String varname,String value)
		{
			RoomVariable var = new RoomVariable(value, "s", null, true, true);
			//trace ("Room variable passed is " + value);
			HashMap variables = new HashMap();
			variables.put(varname, var);
			main.helper.setRoomVariables( main.gameRoom, null, variables, true, true); 
		}

	  public void destroy()
      {
		  if(scheduler!=null)
		  {
		    scheduler.destroy(null);
		    scheduler=null;
		  }
      }
}
