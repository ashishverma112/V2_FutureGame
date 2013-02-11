package games.casino.bingov2.gameImpl;
//main game code...................................................................
import games.casino.bingov2.gameImpl.GameManager.MyTaskHandler;
import games.casino.bingov2.gameImpl.GameStatus.States;
import it.gotoandplay.smartfoxserver.data.Room;
import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.data.UserVariable;
import it.gotoandplay.smartfoxserver.data.Zone;
import it.gotoandplay.smartfoxserver.db.DataRow;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.exceptions.LoginException;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.extensions.ExtensionHelper;
import it.gotoandplay.smartfoxserver.extensions.ISmartFoxExtension;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;
import it.gotoandplay.smartfoxserver.util.scheduling.ITaskHandler;
import it.gotoandplay.smartfoxserver.util.scheduling.Scheduler;
import it.gotoandplay.smartfoxserver.util.scheduling.Task;
import it.gotoandplay.smartfoxserver.extensions.*;
import java.nio.channels.SocketChannel;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.ListIterator;
import java.util.Map;
import java.util.Set;
//importRequestObj
import it.gotoandplay.smartfoxserver.data.RoomVariable;

public class ZoneLevelExtension extends AbstractExtension 
{
    public HashMap<Integer,ZoneUser> zoneUserMap =new HashMap<Integer,ZoneUser>();
    public String last2LineWInfo="--@--";
    public String last3LineWInfo="--@--";
    public int [] roomRoundArr={0,0,0,0,0};
	public String balance="";
	public ExtensionHelper helper;
	public Zone currentZone;
	private Scheduler scheduler;
	private MyTaskHandler handler;
	public BingoDbm bingoDbm;
	//private ModeratorRequest Moderator;
	public HashMap<Integer,Room> activeRoomMap;
	private String activeRooms; 
    public  HashMap<Integer,String> userMap;
    public  String []userNamesByRoom={"","","","",""};
    public HashMap requestTomainMap;
    private String lobbyWelcomeMessage;
    AbstractExtension ext;
	 public HashMap robj;
	 private CentralCashHandler _cch;
	 private long roomCount;
	public void init()
	{
		roomCount = 10;
		//trace("dekho"+775/1000);
		//trace("ab dekho"+775/1000.0);
		//userNamesByRoom=new String[5];
		//roomRoundArr=new int[5];
		activeRoomMap=new HashMap<Integer,Room>();
		helper = ExtensionHelper.instance();
		_cch=CentralCashHandler.getInstance(helper);
		currentZone = helper.getZone(getOwnerZone());
		userMap=new HashMap<Integer,String>();
		//Moderator=new ModeratorRequest(this);
		bingoDbm=BingoDbm.getBingoDBM(getOwnerZone());
		checkForRoomCreation();
		lobbyWelcomeMessage=bingoDbm.getLobbyWelcomeMessage();
		
		// currentZone.dbManager=bingoDbm.getDBmanager();
		sendDbManager();

	}
	public void sendDbManager()
	{
		//arr.get(0).getItem("WELCOME_MEASAGE");
		   ISmartFoxExtension iext = currentZone.getExtManager().get("accountExt");
	       ext = (AbstractExtension)iext;
		    robj=new HashMap();
			//robj.put(0,1);
			robj.put(0,bingoDbm.getDBmanager());
			//trace("+++++++++++++send db manager is called++++++++++++");
	       // boolean bl=Boolean.valueOf(ext.handleInternalRequest(robj).toString());
		   ext.handleInternalRequest(robj);
		
	}
	
	
	
	public void checkForRoomCreation()
	{
		try
		{
		  createRoom();
		}
		catch(Exception e)
		{
			
		}
		
	}
	
	
	private Double getBookValueAmount(Room room,int numbooks)
	{
		//System.out.print(room.getName()+"+++++++++++++jai hind jai bharat+++++++++++++++++++");
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
			var= room.getVariable("bp6");
		}
		//System.out.print("hi888888888"+var.getDoubleValue()+"888888hi");
		amount = Double.parseDouble(var.getValue());
		return roundOff(amount,3);
		
	}
	public void updateBalance(User u,int cost)
	{
		int flag=0;
		//cost=cost*1000;
		int sid=u.getVariable("id").getIntValue();
		_cch.substractAmount(sid,u.getName(),cost/1000.0);
		
	}
	/*public Double verifyPurchage(User u, int NoOfcard,String Roomnm)
	{
		int flag=0;
		int sid=u.getVariable("id").getIntValue();
		Room room=currentZone.getRoomByName(Roomnm);
		 Double cost=getBookValueAmount(room,NoOfcard);
		 Double CashBalance =Double.parseDouble(u.getVariable("cashB").getValue().trim());
		 Double winBalance =Double.parseDouble(u.getVariable("winB").getValue().trim());
		 
		// trace("cost"+cost+"balance"+(CashBalance+winBalance));
		 // double totalAmount=Double.parseDouble( CashBalance)+Double.parseDouble( winBalance);
		 
		 if( (int)(cost*100)<=( (int)(CashBalance*100)+(int)(winBalance*100) ) )
		 {
			return cost; 
		 }
		 else
		 {
			 return -1.0;
		 }
		 
	}*/
	
	public void buyCard(User u,String rmName,int numBooks,int numbkInCurrentRoom,int cost)
	{
		Room targetRoom =currentZone.getRoomByName(rmName);
		ISmartFoxExtension iext = targetRoom.getExtManager().get("gameExt");
		AbstractExtension ext = (AbstractExtension)iext;
		requestTomainMap=new HashMap();
		requestTomainMap.put(0,"1");
		requestTomainMap.put(1,u);
		requestTomainMap.put(2,Integer.toString(numBooks-numbkInCurrentRoom));
		requestTomainMap.put(3,Double.toString(cost/1000.0));
	    String res=(String)ext.handleInternalRequest(requestTomainMap);
	   //ext.handleInternalRequest(requestTomainMap);
	    if(res.equals("1"))
	   {
	    	//trace("balance update is called++++++++++++++++++");
	        updateBalance(u,cost);
	   }
	}
	/*public void searchUser(User u,String Name)
	{
		String str="";
		if(!Name.equals("0"))
		{
		    for(int i=1;i<=activeRoomMap.size();i++)
		     {
		          if(activeRoomMap.get(i)!=null)
		        {
		    	     Room rm=activeRoomMap.get(i);
		    	    if(rm.contains(Name))
		    	   {
		    		    if(str.equals(""))
		    		   {
		    			  str=rm.getName(); 
		    		   }
		    		   else
		    		   {
		    			  str=str+","+rm.getName();  
		    		   }
		    	   }
		        }
		    }
		}
		else
		{
			
			 for(int i=1;i<=activeRoomMap.size();i++)
		     {
		          if(activeRoomMap.get(i)!=null)
		        {
		    	     Room rm=activeRoomMap.get(i);
		    	    if(rm.contains(Name))
		    	   {
		    		    if(str.equals(""))
		    		   {
		    			  str=rm.getName(); 
		    		   }
		    		   else
		    		   {
		    			  str=str+","+rm.getName();  
		    		   }
		    	   }
		        }
		    }
			
			
		}
		sendResponseToUser(2,str, u);
		
	}*/
	
	@Override
	public void handleRequest(String arg0, ActionscriptObject arg1, User arg2, int arg3)
	{
		
	}
	@Override
	public Object handleInternalRequest(Object obj)
	{
		    HashMap objMap=(HashMap)obj;
		    if(objMap.get(0).equals("101"))
		    {
		    	if(objMap.get(1).equals("100"))
		    	{
		    		senUserInfo((User)objMap.get(2));
		    	}
		    	if(objMap.get(1).equals("101"))
		    	{
		    		 purchageCard((User)objMap.get(2),objMap.get(3).toString());
		    		 
		    	}
		    	if(objMap.get(1).equals("102"))
		    	{
		    		//searchUser((User)objMap.get(2),objMap.get(2).toString());
		    	}
		    	
		    	
		    }
		    else if(objMap.get(0).equals("purchaseCardfromDB"))
	    	{
		    	int id=Integer.parseInt(objMap.get(1).toString());
		    	int roomid=Integer.parseInt(objMap.get(3).toString());
		    	
		    	String NoOfBookVar=userMap.get(id);//"100000";
		    	if(NoOfBookVar== null)
		    		NoOfBookVar="100000";
		    	
		    	NoOfBookVar=NoOfBookVar.substring(0,roomid)+objMap.get(2).toString()+NoOfBookVar.substring(roomid+1);
		    	//trace(roomid+"purchaseCardfromDB"+Integer.parseInt(objMap.get(1).toString())+""+objMap.get(2).toString());
		    	userMap.put(id,NoOfBookVar);
	    	} 
		    else if(objMap.get(0).equals("cashHandler"))
		    {
		    			if(objMap.get(1).equals("13"))
		    			{
		    				checkForRoomCreation();
		    			}
		    			//Moderator.handleModeratorRequest((String)objMap.get(1));	isRoomRunning
		    }
		    else if(objMap.get(0).equals("isRoomRunning"))
		    {
		    	int gmid=Integer.parseInt(objMap.get(1).toString());
		    	int rmid=Integer.parseInt(objMap.get(2).toString());
		    	Room rm= activeRoomMap.get(rmid);
		    	if(rm != null && gmid==rm.getVariable("gameId").getIntValue())
		    		return true;
		    	else
		    		return false;
		    		
		    }
		   	else
		    {
		    				// int riid=robj.getVariable("rid").getIntValue();
			    				if(objMap.get(2).toString().equals("1"))
		    					{
		    					
		    					   Room robj = (Room)objMap.get(3);
		    					   //robj.setTemp(true);
		    					   int roomid=robj.getVariable("rid").getIntValue();
		    					    activeRoomMap.remove(roomid);
		    					    userNamesByRoom[roomid-1]="";
		    					    resetNoOfCard(roomid);
		    						//helper.destroyRoom(helper.getZone(getOwnerZone()),robj.getId());
		    					    robj.setName("Globalstars_temp_" + roomCount++);
		    					    RoomVariable var = new RoomVariable(Long.toString(roomCount), "s", null, true, true);
		    						HashMap variables = new HashMap();
		    						variables.put("rid", var);
		    						helper.setRoomVariables( robj, null, variables, true, true); 
		    					    
		    		                 sendStatusToAll(Integer.toString(roomid),"10","abc:x");
		    		               
		    		              // System.out.print("++++++++++++++++++destroy room is called++++++++++++++++++++++");
		    						checkForRoomCreation();
		         
		    					}
		    				if(objMap.get(2).toString().equals("2"))
	    					{
		    					int rid=Integer.parseInt(objMap.get(1).toString());
		    					String spl[]=objMap.get(3).toString().split(":");
			    	  	  		roomRoundArr[rid-1]=Integer.parseInt(spl[0]);	 
		    					sendStatusToAll(objMap.get(1).toString(),objMap.get(2).toString(),objMap.get(3).toString());
	    					}
		    				/*
		    				if(objMap.get(2).toString().equals("3"))
	    					{   
		    					last2LineWInfo= objMap.get(3).toString();
		    					sendStatusToAll(objMap.get(1).toString(),objMap.get(2).toString(),objMap.get(3).toString());
	         
	    					}
		    				if(objMap.get(2).toString().equals("4"))
	    					{
		    					last3LineWInfo= objMap.get(3).toString();	 
		    					sendStatusToAll(objMap.get(1).toString(),objMap.get(2).toString(),objMap.get(3).toString());
	         
	    					}*/
		    			
		    	
		    }
		    
		
		    return null;	
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
	public void purchageCard(User u,String info)
	{
		int id=u.getVariable("id").getIntValue();
		//trace("string info "+info);
		String str[]=info.split(",");
		int roomid=Integer.parseInt(str[0]);
		String roomName=str[2];
		int NoOfBook=Integer.parseInt(str[1]);
		//String userBook=userMap.get(id);
		Room room=currentZone.getRoomByName(roomName);
		if(room.getVariable("Crnd").getIntValue()==room.getVariable("mrnd").getIntValue())
		{
			return;
		}
		
		String NoOfBookVar=u.getVariable("NofB").getValue();
		///trace("book var"+NoOfBook);
		String NOB=u.getVariable("NofB").getValue();
	    int NoOfBookInCurrentRoom=Integer.parseInt(NoOfBookVar.substring(roomid,roomid+1));
	    //trace("NoOfBookInCurrentRoom"+NoOfBookInCurrentRoom);
		if((NoOfBook-NoOfBookInCurrentRoom)>0)
		{
			//trace("string info "+info);
			Double currentCost=0.0;
			if(NoOfBookInCurrentRoom>0)
			{
				currentCost=getBookValueAmount(room,NoOfBookInCurrentRoom);
			}
			 //Double cost=getBookValueAmount(room,NoOfBook)*1000-currentCost*1000;
			int cost=(int)(getBookValueAmount(room,NoOfBook)*1000)-(int)(currentCost*1000);
			 Double CashBalance =Double.parseDouble(u.getVariable("cashB").getValue().trim());
			 Double winBalance =Double.parseDouble(u.getVariable("winB").getValue().trim());
			//trace("cost"+cost+"balance"+(CashBalance+winBalance));
			 // double totalAmount=Double.parseDouble( CashBalance)+Double.parseDouble( winBalance);
			 if(cost>(int)(roundOff((CashBalance+winBalance),3)*1000))
			 {
				//trace("cost is greater than available"+(int)(cost*100)+"hihhi"+( (int)(CashBalance*100)+"hi"+(int)(winBalance*100))+"hi"+winBalance);
				cost=-1; 
			 }
			// trace("book var"+(NoOfBook-NoOfBookInCurrentRoom));
			if(cost>=0)
			{
				//trace("string info "+info);
				//System.out.print("trace for+++++++++++ buy card  "+cost+"  trace for+++++++++++ buy card");
				buyCard(u,roomName,NoOfBook,NoOfBookInCurrentRoom,cost);
				//trace("noof book var+++as++++++"+NoOfBookVar);
				NoOfBookVar=NoOfBookVar.substring(0,roomid)+NoOfBook+NoOfBookVar.substring(roomid+1);
				//trace("noof book var+++++++++"+NoOfBookVar);
				u.setVariable("NofB",NoOfBookVar,UserVariable.TYPE_STRING);
				
				/*if(!userMap.containsKey(id))
				{
					
					if(userNamesByRoom[roomid-1].equals(""))
					{
						userNamesByRoom[roomid-1]=u.getName();
					}
					else
					{
						userNamesByRoom[roomid-1]+=":"+u.getName();
					}
					sendStatusToAll(Integer.toString(roomid),"21",u.getName());
				}
				else*/
				//{
				//System.out.print("555555555555555555555555555555555"+NOB.substring(roomid,roomid+1).equals("0")+"5555555555555555555555555555555555");
					if(NOB.substring(roomid,roomid+1).equals("0"))
					{
						
						//System.out.print("555555555555555555555555555555555"+u.getName()+"5555555555555555555555555555555555");
					    if(userNamesByRoom[roomid-1].equals(""))
					    {
						   userNamesByRoom[roomid-1]=u.getName();
					    }
					    else
					     {
						    userNamesByRoom[roomid-1]+="*"+u.getName();
					     }
					    sendStatusToAll(Integer.toString(roomid),"25",u.getName());
					}
				//}
				userMap.put(id,NoOfBookVar);
				//System.out.print("send response to user is called in if");
				sendResponseToUser(206,Integer.toString(roomid)+":"+Integer.toString(NoOfBook), u);
				
			}
			else
			{
				//System.out.print("send response to user is called in else");
				sendResponseToUser(206,"0", u);
			}
			
		}
		
	}
	//when room is destroyed
 public void resetNoOfCard(int rid)
 {
	 Set  set =userMap.entrySet();
		Iterator<Map.Entry<Integer,String>> userIter = set.iterator();
		while(userIter.hasNext())
  		{
		    Map.Entry<Integer, String> tmpEntry = (Map.Entry<Integer, String>)userIter.next();
			int id=tmpEntry.getKey();
	    	String cards=tmpEntry.getValue();
	    	cards=cards.substring(0,rid)+"0"+cards.substring(rid+1);
	        userMap.put(id, cards);
  		}
	 
 }
 
 void destroyTempRooms()
 {
	 LinkedList lList=currentZone.getRoomList();
	 ListIterator itr = lList.listIterator();
	 while(itr.hasNext())
	 {
	    Room rm=(Room)(itr.next());
	    String roomName = rm.getName();
	    if ((roomName.indexOf("Globalstars_temp") != -1)&&(rm.getUserCount()==0))
	    {
	    	helper.destroyRoom(helper.getZone(getOwnerZone()),rm.getId());	
	    }
	    //if(!(rm.getName().equals("Lobby1")))
	 } 
 }
 void sendMsgToAllRoom(String obj)
	{
		//trace("jai hind");
		String aobj[]={"102",obj};
		LinkedList<SocketChannel> list=new LinkedList<SocketChannel>();
		LinkedList lList=currentZone.getRoomList();
		 ListIterator itr = lList.listIterator();
		 while(itr.hasNext())
		 {
		    Room rm=(Room)(itr.next());
		    if(!(rm.getName().equals("Lobby1")))
		    {
		    	sendResponse(aobj,-1,null,rm.getChannellList());	
		    }
	     }
		
	}

	@Override
	public void handleRequest(String cmd, String[] params, User u, int roomId)
	{
		
	}
	public void senUserInfo(User u)
	{
		String uCInfo="";
		//String roundNo="";
		User joinedUser = u;
		//trace("yes part of user info========================");
		int i=joinedUser.getVariable("id").getIntValue();
		  if(userMap.containsKey(i))
		   {
			 // trace("yes part of user info======"+userMap.get(i));
			  u.setVariable("NofB",userMap.get(i),UserVariable.TYPE_STRING);
		   }
		  else
		  {
			 u.setVariable("NofB","100000",UserVariable.TYPE_STRING);
		  }
		//  String str="";
		  String roundInfo="";
		
		 for(int j=0;j<userNamesByRoom.length;j++)
		 {
			if(j==0)
			{
				//str=userNamesByRoom[j];
				roundInfo=Integer.toString(roomRoundArr[j]);
				// 
			}
			else
			{
			   // str=str+";"+userNamesByRoom[j];	
			    roundInfo= roundInfo+";"+roomRoundArr[j];
			 //   System.out.println("userlist++++++++++++++"+userNamesByRoom[j]+"++++++++++++userlist");
			}
			
		 }
		
		// System.out.println("msg is sent to the user++++++++++++user msg");
		 sendResponseToUser(5,userMap.get(i)+":"+roundInfo+":"+lobbyWelcomeMessage,joinedUser);
	}
	void sendResponseToUser(int cmd,String obj,User u)
	{
		//trace("jai hind");
		//System.out.print("send response to user is called");
		String aobj[]={Integer.toString(cmd),obj};
		LinkedList<SocketChannel> list=new LinkedList<SocketChannel>();
		list.add(u.getChannel());
		sendResponse(aobj, u.getRoom(),null, list);
		//trace("response sent.....................to the client");
	}
	


	@Override
	public void handleInternalEvent(InternalEventObject evt)
	{
		   String evtname = evt.getEventName();
			String str="";

			ActionscriptObject ao = new ActionscriptObject();
			
	}
	   public void createRoom() throws Exception
	   {
		   		destroyTempRooms();
		        
	              activeRooms="";
	            //  trace("room list size----------"+bingoDbm.currentRoomList.size());
	              lobbyWelcomeMessage=bingoDbm.getLobbyWelcomeMessage();
	              sendStatusToAll("11","3",lobbyWelcomeMessage);
	              boolean newRoomMade = false;
	              for(int i=1;i<=5;i++)
	              {
	            	  ArrayList<DataRow> currentRoomList= bingoDbm.fetchActiveRoom(i);
	            	 // System.out.print("+++++++++++++++currentRoomList size+++++++++"+currentRoomList.size());
	            	  if(currentRoomList.size()==0)
	            		  continue;
	            	  DataRow drows=currentRoomList.get(0);
	            	  int roomId=Integer.parseInt(drows.getItem("NUMBER"));
	            	  String name="";
	            	  //activeRooms= activeRooms+","+roomId;
	            	  //trace("room(((((((((((())))))))))) NAME----------"+drows.getItem("NAME")+"@"+currentRoomList.size()+"@"+i);
	            	  if(currentZone.getRoomByName(drows.getItem("NAME"))==null)
	            	  {
	            		 
	            		  
	            		 HashMap<String, RoomVariable> rvMap = getRoomVariableMapForRoom(roomId,drows);
	            		// System.out.print("jai@@@@@@@@@@@@@@"+drows.getItem("NAME")+"@@@@@@@@@@@jai");
	   	                 HashMap<String,String> params=new HashMap<String,String>();
	   	                 name=drows.getItem("NAME");
	            		 params.put("name",drows.getItem("NAME"));
	            		 params.put("pwd","");
	            		 params.put("maxU","1000");
	            		 params.put("isGame","true");
	            		 params.put("isLimbo", "false");
	            		 params.put("uCount","true");
	            		 params.put("xtName","gameExt");
	            		 params.put("xtClass","games.casino.bingov2.gameImpl.BingoMain");
	            		 helper.createRoom(currentZone, params, null, rvMap, null,true, true, false);
	            		 activeRoomMap.put(roomId,currentZone.getRoomByName(name));
	            		 //trace("room(((((((((((())))))))))) NAME----------"+drows.getItem("NAME")+"@"+drows.getItem("NUMBER")+"@"+i);
	            		 newRoomMade=true;
	            		 //helper.createRoom(currentZone, params, null, null, null,true, true, false);
	            	  }
	            	 /* else
	            	  {
	            		 Room rm= currentZone.getRoomByName(drows.getItem("NAME"));
	            		 if(rm.getVariable("rs").getIntValue()==2)
	            		 {
	            		    HashMap<String, RoomVariable> rvMap = getRoomVariableMapForRoom(roomId,drows);
	            		    newRoomMade=true;
	            		     helper.setRoomVariables(rm, null,rvMap, true, false);
	            		     ISmartFoxExtension iext = rm.getExtManager().get("gameExt");
	            			AbstractExtension ext = (AbstractExtension)iext;
	            			requestTomainMap=new HashMap();
	            			requestTomainMap.put(0,"2");
	    	          	    String res=(String)ext.handleInternalRequest(requestTomainMap);
	            		 }
	            		  
	            	  }*/
	            	
	              }
	              sendRoomUpdateStatus();
		
	       }
	      public void sendRoomUpdateStatus()
		  {
			  String aobj[]=new String[2];
			  aobj[0]="4";
			  LinkedList<SocketChannel> users=helper.getZone(getOwnerZone()).getRoomByName("Lobby1").getChannellList();
			 		  sendResponse(aobj,-1,null,users);  
		   }
	     
          private HashMap<String, RoomVariable> getRoomVariableMapForRoom(int roomId,DataRow drows)
          {
            	  
     		 HashMap<String, RoomVariable> rvMap=new HashMap<String, RoomVariable>();
     		 RoomVariable timerRV = new RoomVariable(drows.getItem("InBtTime"),"s",null,true,true);	
     		  RoomVariable gameIdRV = new RoomVariable(drows.getItem("ID"),"s",null,true,true);	
     		 RoomVariable annoncementRV = new RoomVariable(drows.getItem("ANNOUNCEMENT"),"s",null,true,true);
     		 RoomVariable mipRV = new RoomVariable(drows.getItem("MIN_PLAYERS"),"n",null,true,true);
     		 RoomVariable ridRV = new RoomVariable(drows.getItem("NUMBER"),"s",null,true,true);
     		// RoomVariable rdRV = new RoomVariable(drows.getItem("DESCRIPTION"),"s",null,true,true);
     		 RoomVariable mpRV = new RoomVariable(drows.getItem("MAX_PLAYERS"),"n",null,true,true);
     		 RoomVariable b1pRV = new RoomVariable(drows.getItem("BOOKPRICE1"),"s",null,true,true);
     		 RoomVariable b2pRV = new RoomVariable(drows.getItem("BOOKPRICE2"),"s",null,true,true);
     		 RoomVariable b3pRV = new RoomVariable(drows.getItem("BOOKPRICE3"),"s",null,true,true);
     		 RoomVariable b4pRV = new RoomVariable(drows.getItem("BOOKPRICE4"),"s",null,true,true);
     		 RoomVariable b5pRV = new RoomVariable(drows.getItem("BOOKPRICE5"),"s",null,true,true);
     		 RoomVariable b6pRV = new RoomVariable(drows.getItem("BOOKPRICE6"),"s",null,true,true);
     		 //trace("book ((((((((((((()))))))))))))))))prices"+drows.getItem("BOOKPRICE3")+drows.getItem("BOOKPRICE4")+drows.getItem("BOOKPRICE5"));
     		 RoomVariable welcmMsgRV = new RoomVariable(drows.getItem("WELCOME_MESSAGE"),"s",null,true,true);
     		 RoomVariable chatstRV = new RoomVariable(drows.getItem("CHAT"),"s",null,true,true);
     		// RoomVariable mcpRV = new RoomVariable(drows.getItem("MAX_CARDS"),"s",null,true,true);
     		 String str[]=bingoDbm.getPrizeByRoomId(Integer.parseInt(drows.getItem("ID"))).split(":");
     		 RoomVariable p1RV = new RoomVariable(str[0],"s",null,true,true);
     		 RoomVariable p2RV = new RoomVariable(str[1],"s",null,true,true);
     		 RoomVariable p3RV = new RoomVariable(str[2],"s",null,true,true);
     		// RoomVariable dtRV = new RoomVariable(drows.getItem("GAMEDT").substring(0,19),"s",null,true,true);
     		 RoomVariable dtRV = new RoomVariable(drows.getItem("GAMEDT").substring(0,19),"s",null,true,true);
     		 RoomVariable totalgameRV = new RoomVariable(drows.getItem("TOTAL_GAME"),"s",null,true,true);
     		 RoomVariable CurrentRoundRV = new RoomVariable("0","s",null,true,true);
     	      RoomVariable cplRV = new RoomVariable("0","n",null,true,true);
     		// trace("this is date+++++"+drows.getItem("GAMEDT").substring(0,19)+"+++");
     		 RoomVariable join = new RoomVariable("1","s",null,true,true);
      		 rvMap.put("joinP", join);
     		 RoomVariable rsRV = new RoomVariable("1","n",null,true,true);
     		 rvMap.put("announcement", annoncementRV);
     		 rvMap.put("minpl",mipRV);
     		 rvMap.put("gameId",gameIdRV);
     		 rvMap.put("cpl",mipRV);
    		 rvMap.put("rid", ridRV);    		
    		 rvMap.put("welcmmsg", welcmMsgRV);
    		 rvMap.put("chatst",chatstRV);
    		 rvMap.put("mp", mpRV);
    		 rvMap.put("bp1",b1pRV);
    		 rvMap.put("bp2",b2pRV);
    		 rvMap.put("bp3",b3pRV);
    		 rvMap.put("bp4",b4pRV);
    		 rvMap.put("bp5",b5pRV);
    		 rvMap.put("bp6",b6pRV);
    		 rvMap.put("p1",p1RV);
    		 rvMap.put("p2",p2RV);
    		 rvMap.put("p3",p3RV);
    		 rvMap.put("dt",dtRV);
    		 rvMap.put("Crnd",CurrentRoundRV);
    		 rvMap.put("rs", rsRV);
    		 rvMap.put("TI",timerRV);
    		// trace("room id is ========"+drows.getItem("NUMBER"));
       		// rvMap.put("mcp", mcpRV);
       		 rvMap.put("mrnd", totalgameRV);
    	   	 return rvMap;         	  
          }
      
	

	  public void initialize()
      {		    
          scheduler = new Scheduler();
         // handler = new MyTaskHandler();
          Task sendRoomUpdates = new Task("sendRoomUpdates");
          //Task TimerTask = new Task("TimerTask");
          scheduler.addScheduledTask(sendRoomUpdates, 5, true, handler);
          // scheduler.addScheduledTask(TimerTask, 5, false, handler);
          scheduler.startService();    
      }
	  
	  public void destroy()
      {
		  scheduler.destroy(null);
      }
	  
	  private void sendStatusToAll(String rid,String cmd,String info)
	  {
		 
		 String str1[]={cmd,rid+":"+info};
		  LinkedList<SocketChannel> users=helper.getZone(getOwnerZone()).getRoomByName("Lobby1").getChannellList();
		  //trace (users.size() + " size");
		  sendResponse(str1,-1,null,users);  
	  }
}