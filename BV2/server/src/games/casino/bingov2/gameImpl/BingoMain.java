package games.casino.bingov2.gameImpl;
 import java.nio.channels.SocketChannel;
//import games.casino.bingov1.GameManager;
import games.casino.bingov2.gameImpl.BingoDbm;
import games.casino.bingov2.gameImpl.GameManager;
import games.casino.bingov2.gameImpl.Player;

import java.text.ParseException;
import java.util.*;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

import it.gotoandplay.smartfoxserver.data.Room;
import it.gotoandplay.smartfoxserver.data.RoomVariable;
import it.gotoandplay.smartfoxserver.data.Zone;
import it.gotoandplay.smartfoxserver.extensions.ExtensionHelper;
import it.gotoandplay.smartfoxserver.extensions.ISmartFoxExtension;
import it.gotoandplay.smartfoxserver.data.UserVariable;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;
import it.gotoandplay.smartfoxserver.util.scheduling.ITaskHandler;
import it.gotoandplay.smartfoxserver.util.scheduling.Scheduler;
import it.gotoandplay.smartfoxserver.util.scheduling.Task;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.db.DataRow;
public class BingoMain  extends AbstractExtension
{
	public Scheduler scheduler;
	public ITaskHandler handler;
	public Room gameRoom;
	public ExtensionHelper helper;
	public Zone currentZone;
	public int _maxCard;
    AbstractExtension ext;
	GameManager newgame;
	public long inBetweenRoomTimerValue=20;
	public ConcurrentHashMap<Integer,Player> automatePlayers; 
	public int rId;
    public int _round;
    public int _maxRound=8;
    public HashMap<Integer, Comparable> hmap;
    public ZoneObj obj;
    public RequestHttp _rhttp;
    public String _URLstring;
    public GetUrlClass _GURLC;
    public int gameId;
    public boolean destroyRoom;
    public String PRIZE1[];
    public String PRIZE2[];
    public String PRIZE3[];
    public CentralCashHandler _cch;
   	@Override 
	public void init()
	{
		trace("Extension initial BingoV2 16/12/2011");
		
		destroyRoom=false;
		automatePlayers =new ConcurrentHashMap<Integer,Player>();
		helper = ExtensionHelper.instance();
		_cch=CentralCashHandler.getInstance(helper);
		gameRoom = helper.getZone(getOwnerZone()).getRoomByName(getOwnerRoom());
		//_maxCard = gameRoom.getVariable("mcp").getIntValu
		 rId=gameRoom.getVariable("rid").getIntValue();
		 gameId=Integer.parseInt(gameRoom.getVariable("gameId").getValue());
		 PRIZE1=gameRoom.getVariable("p1").getValue().split(";");
		 PRIZE2=gameRoom.getVariable("p2").getValue().split(";");
		 PRIZE3=gameRoom.getVariable("p3").getValue().split(";");
		 _maxRound=gameRoom.getVariable("mrnd").getIntValue();
		 _round=0;
		 _rhttp=new RequestHttp();
		 _GURLC=new GetUrlClass(getOwnerZone());
			// main.sendResponseToAll(104,_GURLC);
			_URLstring=_GURLC.getUrl();
	      currentZone = ExtensionHelper.instance().getZone(getOwnerZone());
		ISmartFoxExtension iext = currentZone.getExtManager().get("zoneExt");
	     ext = (AbstractExtension)iext;
	     restartGame();


		
	}
   	private String getDateinMilisecond(String JackpotDate)
	{
		 //JackpotDate=date;
			// System.out.print("date********** is "+JackpotDate);
			Calendar cal=Calendar.getInstance();
			Date dt;
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat( "yyyy-MM-dd HH:mm:ss" );  
			 //String cdate=sdf.format(currentdate);  
			 try
				{
				   dt=(Date)sdf.parse(JackpotDate);
				   cal.setTime(dt);
				   //currentdate=(Date)sdf.parse(cdate);z
				}
				catch(ParseException e)
				{

				}
				 return Long.toString(cal.getTimeInMillis());
		
	}
   
	public void stopShedular()
	{   if(scheduler!=null)
	     {
		    //scheduler.stopService();
		    scheduler.destroy(null);
		    scheduler=null;
	      }
	}
   	public void sendInfoToZone(String cmd,String info)
	{
		helper = ExtensionHelper.instance();
		 currentZone = helper.getZone(getOwnerZone());
			//Zone currentZone = ExtensionHelper.instance().getZone(getOwnerZone());
			ISmartFoxExtension iext = currentZone.getExtManager().get("zoneExt");
		     ext = (AbstractExtension)iext;

		//cmd=100 for on login request
		//cmd=101 for card purchage
		//cmd=102 search usr by name
		     hmap=new HashMap<Integer, Comparable>();
			 hmap.put(0,"100");
			 hmap.put(1,rId);
			 hmap.put(2,cmd);
			 hmap.put(3,info);
		// System.out.print("+++++++++++++++++hihi"+hmap.get(3));
    	ext.handleInternalRequest(hmap);
	}
   	public void sendDestroyMsgToZone()
	{
   		
   		HashMap<Integer, Object> roomMap=new HashMap<Integer, Object>();
		 roomMap.put(0,"100");
		 roomMap.put(1,rId);
		 roomMap.put(2,"1");
		 roomMap.put(3,gameRoom);
		 ext.handleInternalRequest(roomMap);
		
	}
   	
	
	public void updateRound()
	{
		HashMap<String,RoomVariable> roomVarMap=new HashMap<String,RoomVariable>(); 
		RoomVariable CurrentRoundRV = new RoomVariable(Integer.toString(_round),"s",null,true,true);
		roomVarMap.put("Crnd", CurrentRoundRV);
		
	//	System.out.print("value of the variables in the room...."+cardValue+amountInGame+bingoP+patternP);
		helper.setRoomVariables(gameRoom, null,roomVarMap, true, true);		
		
		
	}
	public String sendOutRequest(User u,Double cashB,Double winB)
	{
		double totalAmount=cashB*100+winB*100;
		 int id=u.getVariable("id").getIntValue();
		
		String url=_GURLC.getOutUrl();
		String data="url="+_URLstring+"/TransferOutRequest&client_session_id=7967858765675&gameid="+getOwnerZone()+"&timestamp=123&account_id="+u.getVariable("id").getValue()+"&amount="+totalAmount+"&transaction_id=123456&licensee_reverse_password=123456&deposit_pot="+cashB*100+"&winning_pot="+winB*100;
		
		String str=_rhttp.SendRequest(url,data);
		 if(str.equals("0"))
		 {
			 newgame.bingoDbm.insertMoneyTransaction(id,"out",cashB, winB,"0");
		 }
		 else
		 {
			 newgame.bingoDbm.setFailedBalance(id, cashB, winB);
			 newgame.bingoDbm.insertMoneyTransaction(id,"out",cashB, winB,"1");
		 }
				//String str=_rhttp.SendRequest(_URLstring+"/TransferOutRequest",data);
		// System.out.print("this is  out result"+str+"this is  out result");
		 return str;
	}
	private Double getBookValueAmount(Room room,int numbooks)
	{
		RoomVariable var = null;
		Double amount = 0.0;
		if(numbooks == 1)
		{			
			var = room.getVariable("bp1");
		}
		else if(numbooks == 2)
		{
			var = room.getVariable("bp2");
		}
		else if(numbooks == 3)
		{
			var = room.getVariable("bp3");
		}
		else if(numbooks == 4)
		{			
			var = room.getVariable("bp4");
		}
		else if(numbooks == 5)
		{
			var = room.getVariable("bp5");
		}
		else if(numbooks == 6)
		{
			var = room.getVariable("bp6");
		}
		amount = Double.parseDouble(var.getValue());
		return amount;
		
	}

	void sendResponseToAll(int cmd,String obj)
	{
		if(cmd==8)
		{
		//trace("sending response to all user initialy when user log...................................");
		//trace(obj);
		//trace("sending response to all user initialy when user log...................................");
		}
		String aobj[]={Integer.toString(cmd),obj};
		LinkedList<SocketChannel> userList = gameRoom.getChannellList();
		sendResponse(aobj, gameRoom.getId(), null,userList );
	} 
	

	
		
		void destroyGame()
		{
			 if(_round<_maxRound)
			 {
			   restartGame();
			 }
			 else
			 {
			  newgame.bingoDbm.deleteFromIn_btw_crads(Integer.toString(rId)); 
			  sendUserToLobbyNew(); 
			 }
		
		 
	}
	private void sendUserToLobbyNew()
	{
		//stopShedular();
		 sendDestroyMsgToZone();
		// HashMap roomMap=new HashMap();
		// roomMap.put(0,"100");
		// roomMap.put(1,rId);
		// roomMap.put(2,"1");
		// roomMap.put(3,gameRoom);
		 try
			{
			 
			 if((gameRoom.getUserCount()==0))
				{
				 sendDestroyMsgToZone();
				   return;
				}
			destroyRoom=true;
			setJoinPermission("0");
			sendResponseToAll(100,"MTL");
			//sendUserToLobby();
			}
			catch(Exception e)
			{
				
			}
			
	}
	public void setJoinPermission(String str)
	{
		 HashMap<String,RoomVariable> roomVarMap=new HashMap<String,RoomVariable>();
		 RoomVariable join = new RoomVariable(str,"s",null,true,true);
		 roomVarMap.put("joinP", join);
		 helper.setRoomVariables(gameRoom, null,roomVarMap, true, false);
	}
	
	public void sendUserToLobby()throws Exception
	{
		User u[]= gameRoom.getAllUsers();
		for(int i=0;i<u.length;i++)
		{
			String NoOfBookVar=u[i].getVariable("NofB").getValue();
			NoOfBookVar=NoOfBookVar.substring(0,rId)+"0"+NoOfBookVar.substring(rId+1);
			u[i].setVariable("NofB",NoOfBookVar,UserVariable.TYPE_STRING);
			helper.joinRoom(u[i],gameRoom.getId(),helper.getZone(getOwnerZone()).getRoomByName("Lobby1").getId(), true,"", false,true);
			//helper.joinRoom(usr, currRoom, newRoom, leaveRoom, pword, isSpectator, broadcast)o
			
		}
		
	}
	 @Override
	 public Object handleInternalRequest(Object obj)
	    {
		 //1 for card purchage
			//System.out.println("here obtained request");
		 HashMap<?, ?> objMap=(HashMap<?, ?>)obj;
			if(objMap.get(0).equals("1"))
			{
			return newgame.purchageCard(Integer.parseInt(objMap.get(2).toString()),(User)objMap.get(1),Double.parseDouble(objMap.get(3).toString()),true);
			}
			if(objMap.get(0).equals("6"))
			{
				newgame.destroy();
				 sendUserToLobbyNew(); 
			}
			/*if(objMap.get(0).equals("2"))
			{
				_round=0;
				newgame.destroy();
				restartGame();
			}*/
			
			 if(objMap.get(0).equals("8"))
			    {
			    	String str=objMap.get(1).toString();
			    	//trace("id in main "+str);
			    	//trace("id in main "+str+newgame.players.containsKey(Integer.parseInt("str")));
			    	if(newgame.players.containsKey(Integer.parseInt(str)))
			    	{
			    		//trace("id in main in if");
			    		return "1";
			    		
			    	}
			    	else
			    	{
			    		//trace("id in main in else");
			    		return "0";
			    	}
			    }
			    if(objMap.get(0).equals("501"))
			    {
			    	 return Integer.toString(currentZone.getRoomByName(getOwnerRoom()).getUserCount());
			    }
			    if(objMap.get(0).equals("14"))
			    {
			    	return newgame.game.setNextNumber(objMap.get(1).toString());
			    }
	    	return true;
	    }
	 public void callSendInfoToZone()
	 {
		 sendInfoToZone("2",Integer.toString(_round)+":"+gameRoom.getVariable("rs").getValue());
	 }
	void restartGame()
	{  
		//stopShedular();
		     setGameStatus(1);
		     setNumBallsPassed(0);
		           _round++;
		              updateRound();
		              if(_round==1)
		              {
		                    	 	            	  
		                Calendar currentdate=Calendar.getInstance();
		          		long jdate=Long.parseLong(getDateinMilisecond(gameRoom.getVariable("dt").getValue()));
		          		inBetweenRoomTimerValue=(jdate-currentdate.getTimeInMillis());
		          		inBetweenRoomTimerValue=inBetweenRoomTimerValue/1000;
		          		
		              }
		               if(_round!=1)
		               {
		            	  inBetweenRoomTimerValue=30;
		                 // sendInfoToZone("2",Integer.toString(_round)+);
		               }
		               callSendInfoToZone();
			 			setGameStatus(1);
			 			setNumBallsPassed(0);
			 			newgame=new GameManager(this,BingoDbm.getBingoDBM(getOwnerZone()));
			 			//sendResponseToAll(20, newgame.patternString);
			 			 if(_round==1)
			              {
			 				 purchseCardsFromDB();
			              }
			 			
			 			String str1;
			 			Set<Entry<Integer, Player>>  set = automatePlayers.entrySet();
			 			Iterator<Map.Entry<Integer, Player>> playerIter = set.iterator();
			 	while(playerIter.hasNext())
			 		{
			 				Map.Entry<Integer, Player> tmpEntry = (Map.Entry<Integer, Player>)playerIter.next();
			 				Player tmpPlayer = tmpEntry.getValue();
			 				int cardNo=tmpPlayer.noOfcard;
			 				tmpPlayer.noOfcard=0;
			 				//Double CashBalance =Double.valueOf(tmpPlayer.user.getVariable("cashB").getValue().trim()).doubleValue();
			 				//Double winBalance =Double.valueOf(tmpPlayer.user.getVariable("winB").getValue().trim()).doubleValue(); 
			 				
			 					//newgame.addAutomatePlayer(tmpPlayer);
			 					//obj.type=1;
			 					tmpPlayer.amountInGame=0.0;
			 					//newgame.purchageCard(cardNo,tmpPlayer.user,tmpPlayer.amountInGame);
			 					newgame.purchageCard(cardNo,tmpPlayer.user,tmpPlayer.amountInGame,false);
			 					if(tmpPlayer.isOnlineP)
			 					{
			 						//trace("+++++++++++++++RESTART IS CALLED+++++++++++++++++++");
						 	       str1=newgame.getgamestatus(tmpPlayer.serverId);
			 			           sendResponseToUser(6, str1, tmpPlayer.user);
			 					}
			 		}
		 
			 	      sendResponseToAll(511,Integer.toString(gameId));
			 			sendUserListToAll();
			 			automatePlayers=new ConcurrentHashMap<Integer,Player>();
 }
		
	void purchseCardsFromDB()
	{
		ArrayList<DataRow> result=UserDBM.getBingoDBM().getPurchaseCradsInfo(gameId);
		if(result.size() > 0)
		{
			for(int j=0; j<result.size(); j++ )
			{
				DataRow dr=result.get(j);
				String name=dr.getItem("USER_NAME");
				int noofbooks=Integer.parseInt(dr.getItem("NO_OF_BOOKS"));
				int uid=Integer.parseInt(dr.getItem("USER_ID"));
				Double amt=getBookValueAmount(gameRoom, noofbooks);
				Boolean ok= (Boolean) newgame.purchageCardByDB(uid,name, noofbooks,amt);
				if(ok)
				{
					UserDBM.getBingoDBM().deletePurchasedCards(gameId,name);
					sendpurchasedetailTozone(uid,noofbooks);
				}
			}
		}
		
	}
	void sendpurchasedetailTozone(int id,int noofbooks)
	{
		ISmartFoxExtension iext = currentZone.getExtManager().get("zoneExt");
	     ext = (AbstractExtension)iext;
	     hmap=new HashMap<Integer, Comparable>();
		 hmap.put(0,"purchaseCardfromDB");
		 hmap.put(1,id);
		 hmap.put(2,noofbooks);
		 hmap.put(3,rId);
	   // System.out.print("+++++++++++++++++hihi"+hmap.get(2));
	    ext.handleInternalRequest(hmap);
	}

	void sendResponseToUser(int cmd,String obj,User u)
	{
		//trace("jai hind");
		String aobj[]={Integer.toString(cmd),obj};
		LinkedList<SocketChannel> list=new LinkedList<SocketChannel>();
		list.add(u.getChannel());
		sendResponse(aobj, u.getRoom(),null, list);
		//trace("response sent.....................to the client");
	}

	public void handleRequest(String cmd, String[] params, User u, int fromRoom)
	{
		int i=u.getVariable("id").getIntValue();
		//String str1="";
		int cmdValue = Integer.parseInt(params[0]);

	
			 if (cmdValue == 2)
			{
							 				 
				//trace ("Game State request recieved");
				 sendAllUserList(u);
				 String str=newgame.getgamestatus(i);
				 String blockedUser=u.getVariable("IU").getValue();
				 String CashBalance =u.getVariable("cashB").getValue().trim();
				 String winBalance =u.getVariable("winB").getValue().trim(); 
				 sendResponseToUser(21,newgame.roundOff(Double.parseDouble(CashBalance), 2)+","+newgame.roundOff(Double.parseDouble(winBalance), 2),u);
				 sendResponseToUser(22,blockedUser,u);
				 sendResponseToUser(6,str+"$"+gameId, u);
				 sendResponseToUser(23,gameRoom.getVariable("welcmmsg").getValue(), u);
				// sendResponseToUser(6,str+":"+getBackground(gameRoom), u);
			}
			
			if(cmdValue==1)
			{
				newgame.setAutomate(i);
			}
	}
	
	public void setRoomVariable(int noOfSentBall,int noOfCurrentPlayer)
	{
		//helper = ExtensionHelper.instance();
		HashMap<String,RoomVariable> roomVarMap=new HashMap<String,RoomVariable>(); 
		RoomVariable bpRv = new RoomVariable(Integer.toString(noOfSentBall),"n",null,true,true);
		RoomVariable cplRv = new RoomVariable(Integer.toString(noOfCurrentPlayer),"n",null,true,true);
		roomVarMap.put("cpl", cplRv);
		roomVarMap.put("bpass", bpRv);
		//gameRoom = helper.getZone(getOwnerZone()).getRoomByName(getOwnerRoom());
		helper.setRoomVariables(gameRoom, null,roomVarMap, true, false);
	}
	
	public void setNumBallsPassed(int numBallsSent)
	{
		HashMap<String,RoomVariable> roomVarMap=new HashMap<String,RoomVariable>(); 
		RoomVariable bpRv = new RoomVariable(Integer.toString(numBallsSent),"n",null,true,true);
		roomVarMap.put("bpass", bpRv);		
		helper.setRoomVariables(gameRoom, null,roomVarMap, true, true);		
	}
	
	public void setCurrentPlayers(int numCurrentPlayers)
	{
		HashMap<String,RoomVariable> roomVarMap=new HashMap<String,RoomVariable>(); 
		RoomVariable cplRv = new RoomVariable(Integer.toString(numCurrentPlayers),"n",null,true,true);
		roomVarMap.put("cpl", cplRv);
		helper.setRoomVariables(gameRoom, null,roomVarMap, true, false);		
	}
	
	public void setGameStatus(int newstatus)
	{
		String strs = "" + newstatus;
		//newstatus --- 1 TIMER_RUNNING , ---- 0 GAME_RUNNING
		Integer status = new Integer(newstatus);
		//trace (status.toString() + " Status dumped");
		RoomVariable rsRV = new RoomVariable(strs,"n",null,true,true);
		HashMap<String,RoomVariable> roomVarMap=new HashMap<String,RoomVariable>();
		roomVarMap.put("rs", rsRV);
		helper.setRoomVariables(gameRoom, null,roomVarMap, true, true);		
	}

	public void handleRequest(String cmd, ActionscriptObject ao, User u,int fromRoom)
	{
	}
	public void  sendUserListToAll()
	{
		String Name=null;
	    Name=newgame.getTotalPlayersName();
	    sendResponseToAll(8, Name);
	
	}
	public void sendAllUserList(User u)
	{
		String Name=null;
	    Name=newgame.getTotalPlayersName();
	    //trace(Name);
	  //  System.out.println("above is the list of total user&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&vipul"+Name+"above is the list of total user&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
	    sendResponseToUser(8,Name,u);
	}

	public void handleInternalEvent(InternalEventObject ieo)
	{
		String evtname = ieo.getEventName();
		String str="";

		ActionscriptObject ao = new ActionscriptObject();
		if (evtname.equals("userJoin"))
		{
			

			User joinedUser = (User)ieo.getObject("user");
			int i=joinedUser.getVariable("id").getIntValue();
			//trace("user join room++++++++++++++++++++++++++++++");
			if(newgame.players.containsKey(i))
			{
				newgame.setOnline(i, joinedUser);
			   
			}
			// trace("send user list to all is called...................");    
			
			// ArrayList<User> us=new ArrayList<User>();
			// us.add(joinedUser);
			// newgame.updateDataBase(us);
			
		}
		else if ( evtname.equals("userLost") || evtname.equals("logOut"))
		{
			/*User juser = (User)ieo.getObject("user");
			int id=juser.getVariable("id").getIntValue();
			 String ulist=juser.getVariable("IU").getValue();
			// trace("blocked user list given below>>>>>>>>>>>>>>"+ulist);
			newgame.setOfline(id);
			newgame.bingoDbm.setBlockedUser(id, ulist);
			
			Double CashBalance =Double.valueOf(juser.getVariable("cashB").getValue().trim()).doubleValue();
		    Double winBalance =Double.valueOf(juser.getVariable("winB").getValue().trim()).doubleValue(); 
		  
		    newgame.bingoDbm.setBalance(id,0.0,0.0);
		    //juser.setVariable("cashB","0.0",UserVariable.TYPE_STRING);
	    	//juser.setVariable("winB","0.0",UserVariable.TYPE_STRING);
		         if(!(sendOutRequest(juser,CashBalance,winBalance).equals("0")))
			      {
		    	      newgame.bingoDbm.setFailedBalance(id, CashBalance, winBalance);   	
				    	
			      }
		    	*/
		    	
		  
		  
		  //  sendResponseToUser(100,"MTL",juser);	
		}
		else if(evtname.equals("userExit")||evtname.equals("userLost")||evtname.equals("logOut"))
		{
			User juser = (User)ieo.getObject("user");
			int id=juser.getVariable("id").getIntValue();
			//String ulist=juser.getVariable("IU").getValue();
			newgame.setOfline(id);
			//newgame.bingoDbm.setBlockedUser(id, ulist);
			//if((gameRoom.getUserCount()==0)&&destroyRoom)
			//{
			//	sendDestroyMsgToZone();
				
			//}
		}
		
	}
}
