package games.casino.bingov2.gameImpl;

import java.nio.channels.SocketChannel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;

import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.extensions.ExtensionHelper;
import it.gotoandplay.smartfoxserver.extensions.ISmartFoxExtension;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;
import it.gotoandplay.smartfoxserver.data.Room;
import it.gotoandplay.smartfoxserver.data.RoomVariable;
import it.gotoandplay.smartfoxserver.data.UserVariable;
import it.gotoandplay.smartfoxserver.data.Zone;
import it.gotoandplay.smartfoxserver.db.DataRow;
public class LobbyExt  extends AbstractExtension
{
	public Room gameRoom;
	public ExtensionHelper helper;
	private Zone currentZone;
    AbstractExtension ext;
    public HashMap hmap;
    private BingoDbm bingoDbm;
    public RequestHttp _rhttp;
    public String _URLstring;
    public GetUrlClass _GURLC;

	@Override 
	public void init()
	{
		//trace("___________lobbby is initialize|||||||||");

		helper = ExtensionHelper.instance();
		bingoDbm=BingoDbm.getBingoDBM(getOwnerZone());
	   // _rhttp=new RequestHttp();
	   // _GURLC=new GetUrlClass(getOwnerZone());
	   // _URLstring=_GURLC.getUrl();

	
		
	}
	public void joinRoom(User u,String roomName) throws Exception
	{
		
		 // trace("+++++++++++++calling for join room +++++++++++++"+u.getVariable("id").getValue());
        Room rm=helper.getZone(getOwnerZone()).getRoomByName(roomName);
        
        if(rm.getUserByName(u.getName())!=null)
		{
			return;
		}
        //trace("joinP+++++++++++++++"+rm.getVariable("joinP").getIntValue());
		boolean flag=false;
		if(roomName.equals("Lobby1"))
		{
	       helper.joinRoom(u,u.getRoom(),rm.getId(), true,"", false,true);
			return;
		}
		if(rm.getVariable("cpl").getIntValue()<rm.getVariable("mp").getIntValue())
		{
			// trace("+++++++++++abc++calling for join room +++++++++++++if part");
			flag=true;
			
		}
		else
		{
			//ISmartFoxExtension iext = rm.getExtManager().get("gameExt");
			ISmartFoxExtension iext = rm.getExtManager().get("gameExt");
		     ext = (AbstractExtension)iext;
		     hmap=new HashMap();
		     hmap.put(0,"8");
		     hmap.put(1,u.getVariable("id").getValue());
		     String str=ext.handleInternalRequest(hmap).toString();
		    // trace("+++++++++++++calling for join room +++++++++++++"+u.getVariable("id").getValue());
		     //String str="1";
		     if(str.equals("1")||(u.getVariable("Utype").getIntValue()==1))
		     {
		    	// trace("+++++++++++++calling for join room +++++++++++++");
		    	 flag=true;
		     }
		}
		if((rm.getVariable("joinP").getValue().equals("1")&& flag))
		{
			//trace(" for join room called   +++++++++++++ +++++++++++++"+roomName);
		  helper.joinRoom(u,u.getRoom(),rm.getId(), true,"", false,true);
		}
			
	}
	
	public String sendOutRequest(User u,Double cashB,Double winB)
	{
		double totalAmount=cashB*100+winB*100;
		
		String url=_GURLC.getOutUrl();
		String data="url="+_URLstring+"/TransferOutRequest&client_session_id=7967858765675&gameid="+getOwnerZone()+"&timestamp=123&account_id="+u.getVariable("id").getValue()+"&amount="+totalAmount+"&transaction_id=123456&licensee_reverse_password=123456&deposit_pot="+cashB*100+"&winning_pot="+winB*100;
		
		String str=_rhttp.SendRequest(url,data);
				//String str=_rhttp.SendRequest(_URLstring+"/TransferOutRequest",data);
		 //System.out.print("this is  out result"+str+"this is  out result");
		 return str;
	}
	public void sendInfoToZone(String cmd,User u ,String info)
	{
		//helper = ExtensionHelper.instance();
		 Zone currentZone = helper.getZone(getOwnerZone());
			//Zone currentZone = ExtensionHelper.instance().getZone(getOwnerZone());
			ISmartFoxExtension iext = currentZone.getExtManager().get("zoneExt");
		     ext = (AbstractExtension)iext;

		//cmd=100 for on login request
		//cmd=101 for card purchage
		//cmd=102 search usr by name
		 hmap=new HashMap();
		 hmap.put(0,"101");
		 hmap.put(1,cmd);
		 hmap.put(2,u);
		 hmap.put(3,info);
		// System.out.print("+++++++++++++++++hihi"+hmap.get(3));
    	ext.handleInternalRequest(hmap);
	}
	public void handleRequest(String cmd, ActionscriptObject ao, User u,int fromRoom)
	{
	}
	public void handleRequest(String cmd, String[] params, User u, int fromRoom)
	{
		
		
		int i=u.getVariable("id").getIntValue();
		String str1="";
		int cmdValue = Integer.parseInt(params[0]);
		//System.out.print("|||||||||||||hi|||||||||||||||||"+cmdValue);
		if(cmdValue==11||cmdValue==12||cmdValue==13||cmdValue==14||cmdValue==15)
		{
			//purchage card from the given room
			int URoomId=cmdValue%10;
			int noOfCard=Integer.parseInt(params[1]);
			sendInfoToZone("101",u,URoomId+","+noOfCard+","+params[2]);
		}
		
		if(cmdValue==2)
		{
			//search user by name  	
		
			sendInfoToZone("100",u,"abc");
		}
		if(cmdValue==4)
		{
			//trace("hi aaaya kya hh");
			handleBuyCards(params,u);
			
		}
		if(cmdValue==3)
		{
			//trace("hi aaaya kya hh");
			sendFutureGameInfoToUser(u);
		}
		if(cmdValue==1)
		{
			try
			{
				 joinRoom(u,params[1]);	
			}
			catch(Exception e)
			{
				
			}
		
			
		}
	}
	private void handleBuyCards(String[] params, User u) {
		String[] info=new String[3];
		info[0]=params[1];//gameid
		info[1]=u.getName();
		info[2]=params[2];//noofcards
		int gameid=Integer.parseInt(params[1]);
		int currrentNoofbooks=Integer.parseInt(UserDBM.getBingoDBM().getPurchaseCradsInfoByUser(gameid,u.getName()));
		//
		Double currentCost=0.0;
		if(currrentNoofbooks>0)
			currentCost=getBookValueAmount(gameid,currrentNoofbooks+"");
		int cost=(int)(getBookValueAmount(gameid,params[2])*1000)-(int)(currentCost*1000);
		
		if( deductBalace(u,cost))
		{
		  String resp=params[1]+",";
		  if(UserDBM.getBingoDBM().insertPurchaseFutureCrdsInfo(info))
		     resp+=params[2];
		  else
		    resp+=currrentNoofbooks;
		    sendResponseToUser(12,resp,u);
		}
	}
	private boolean deductBalace(User u, int cost) {
		 Double CashBalance =Double.parseDouble(u.getVariable("cashB").getValue().trim());
		 Double winBalance =Double.parseDouble(u.getVariable("winB").getValue().trim());
		 if(cost>(int)(roundOff((CashBalance+winBalance),3)*1000))
		 {
		    return false;
		 }
		 else
		 {
			 CentralCashHandler.getInstance(helper).substractAmount(u.getVariable("id").getIntValue(),u.getName(),cost/1000.0);;
			return true; 
		 }
		 
		
	}
	Double getBookValueAmount(int gameid,String bookprice)
	{
		bookprice="BOOKPRICE"+bookprice;
		return Double.valueOf(bingoDbm.getBookValueAmount(gameid,bookprice));
	}
	
	private void sendFutureGameInfoToUser(User u) 
	{
		String info="";
		 for(int i=1;i<=5;i++)
         {
			 ArrayList<DataRow> currentRoomList= bingoDbm.fetchActiveRoom(i);
        	 // System.out.print("+++++++++++++++currentRoomList size+++++++++"+currentRoomList.size());
        	  if(currentRoomList.size()==0)
        		  continue;
        	      if(info.equals(""))
        		    info=i+"";
        		  else
        		    info+="#"+i;  
        			  
        	  for(int k =0; k<currentRoomList.size();k++ )
        	  {
        	     DataRow drows=currentRoomList.get(k);
        	     int gameId=Integer.parseInt(drows.getItem("ID"));
        	     if(isRoomRunning(gameId,i))
        	    	 continue;
        	      info+="*"+gameId;
        	      info+=","+drows.getItem("NAME");
        	      info+=","+drows.getItem("TOTAL_GAME");
        	      info+=","+drows.getItem("GAMEDT").substring(0,19);
        	      info+=","+drows.getItem("BOOKPRICE1");
        	      info+=","+drows.getItem("BOOKPRICE2");
        	      info+=","+drows.getItem("BOOKPRICE3");
        	      info+=","+drows.getItem("BOOKPRICE4");
        	      info+=","+drows.getItem("BOOKPRICE5");
        	      info+=","+drows.getItem("BOOKPRICE6");
        	      String str[]=bingoDbm.getPrizeByRoomId(gameId).split(":");
        	      info+=","+str[0];
        	      info+=","+str[1];
        	      info+=","+str[2];
        	      info+=","+UserDBM.getBingoDBM().getPurchaseCradsInfoByUser(gameId,u.getName());
        	  }
         }
		 sendResponseToUser(11,info,u);
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
	private boolean isRoomRunning(int gameId, int roomId) {
		// TODO Auto-generated method stub
		 Zone currentZone = helper.getZone(getOwnerZone());
			//Zone currentZone = ExtensionHelper.instance().getZone(getOwnerZone());
			ISmartFoxExtension iext = currentZone.getExtManager().get("zoneExt");
		     ext = (AbstractExtension)iext;
		     hmap=new HashMap();
		     hmap.put(0,"isRoomRunning");
		     hmap.put(1,gameId);
		     hmap.put(2,roomId);
		    
		// System.out.print("+++++++++++++++++hihi"+hmap.get(3));
		    return (Boolean) ext.handleInternalRequest(hmap);
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
	@Override
	public void handleInternalEvent(InternalEventObject evt)
	{
		   String evtname = evt.getEventName();
		   User juser = (User)evt.getObject("user");
		   //int id=juser.getVariable("id").getIntValue();
			String str="";

			ActionscriptObject ao = new ActionscriptObject();
			if (evtname.equals("userJoin"))
			{
				//sendInfoToZone("100",juser,"");
			}
			else if ( evtname.equals("userLost") || evtname.equals("logOut"))
			{
				//User juser = (User)ieo.getObject("user");
				//int id=juser.getVariable("id").getIntValue();
				//Double CashBalance =Double.valueOf(juser.getVariable("cashB").getValue().trim()).doubleValue();
			  //  Double winBalance =Double.valueOf(juser.getVariable("winB").getValue().trim()).doubleValue(); 
			   // bingoDbm.setBalance(id, CashBalance, winBalance);
			  //  bingoDbm.setBalance(id,0.0,0.0);
		    	//juser.setVariable("cashB","0.0",UserVariable.TYPE_STRING);
		    	//juser.setVariable("winB","0.0",UserVariable.TYPE_STRING);
			   
			    	  //if(sendOutRequest(juser,CashBalance,winBalance).equals("0"))
					   // {
					    	// bingoDbm.setFailedBalance(id, CashBalance, winBalance);   	
					  //  }
			
			}
			else if (evtname.equals("userExit"))
			{						
			}
	}

}
