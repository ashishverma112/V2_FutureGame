package games.casino.bingov2.gameImpl;
import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.data.UserVariable;
import it.gotoandplay.smartfoxserver.data.Zone;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.exceptions.LoginException;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.extensions.ExtensionHelper;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;

import java.text.ParseException;
import java.util.ArrayList;
import it.gotoandplay.smartfoxserver.db.DataRow;
import java.nio.channels.SocketChannel;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
public class LoginExtention extends AbstractExtension {
	private ExtensionHelper helper;
	private Zone currentZone;
	private int i=1;
	private UserDBM bingoDbm;
	private int id=-1;
	private String blockedUser="";
	public void init()
	{
		helper = ExtensionHelper.instance();
		 currentZone=helper.getZone(getOwnerZone());
		// trace("login init for||||||||||||||||||||||||"+getOwnerZone());
			bingoDbm=UserDBM.getBingoDBM();
	}
	
	@Override
	public void handleRequest(String arg0, ActionscriptObject arg1, User arg2, int arg3) {
		
	}

	@Override
	public void handleRequest(String cmd, String[] params, User user, int roomId) {
		//String evtname = evt.getEventName();
 	      String str="";
 	  //  trace ("event rcvd");
	}
	public void setBalance(User newUser,int id)
	{
		ArrayList<DataRow> result=bingoDbm.getBalance(id);
			//id=-1;
			if(result.size()>0)
			{
				DataRow drows=result.get(0);
			    newUser.setVariable("cashB",drows.getItem("CASH_BALANCE"),UserVariable.TYPE_STRING);
			    newUser.setVariable("winB",drows.getItem("WIN_BALANCE"),UserVariable.TYPE_STRING);
				
			}
		
	}

	@Override
	public void handleInternalEvent(InternalEventObject evt) 
	{
		  String evtname = evt.getEventName();
   	      String str="";
   	    //  trace (evtname + "--------------->event rcvd");
  		  
  		//ActionscriptObject aobj = new ActionscriptObject();
   	   if (evtname.equals("loginRequest"))
  		{
   		      	    boolean loginOk = false;
   		      		String[] loginResponse = new String[]{};
   		   			String nick = evt.getParam("nick");
   		   			String pass = evt.getParam("pass");
   		   			User  newUser=null;
   		   			//boolean ok = false;
   		   			SocketChannel chan = (SocketChannel) evt.getObject("chan");
   		   			currentZone = helper.getZone("BingoV1");
   		   			LinkedList<SocketChannel> userList = new LinkedList <SocketChannel>();
   		   			userList.add(chan);
   		   			//BingoDbm BingoDbm=new BingoDbm();
   		   			String aobj[]=new String[2];
   		   			aobj[0]="6";
   		   		//	System.out.print("value of the passward"+pass);
   		   		if(pass.equals("1"))
   		   		{
   		   			try{
   		   				//System.out.print("value of the passward"+pass);
   		   				newUser = helper.canLogin(nick, pass, chan,getOwnerZone(),false);
   		   				newUser.setVariable("id",Integer.toString(0),UserVariable.TYPE_STRING);
   		   				newUser.setVariable("type","fun",UserVariable.TYPE_STRING);
   		   				newUser.setVariable("cashB","0.0",UserVariable.TYPE_STRING);
   		   				newUser.setVariable("winB","0.0",UserVariable.TYPE_STRING);
   		   				newUser.setVariable("IU","",UserVariable.TYPE_STRING);
   		   				newUser.setVariable("chatS","0",UserVariable.TYPE_STRING);
   		   				newUser.setVariable("Utype","0",UserVariable.TYPE_STRING);
   		   			  	aobj[1]="1";
   		   				}
   		   				catch (LoginException le)
   		   				{
   		   					this.trace("Could not login user: " + nick);
   		   					loginResponse = new String[]{ "loginKO", null, le.getMessage()};
   		   					aobj[1]="0";
  					
   		   				}
   		   				sendResponse(aobj, -1, null, userList);
   		   		}
   		   		else
   		   		{
  					ArrayList<DataRow> result=bingoDbm.authenticateUser(nick, pass);
  					int status=5;
  					Calendar currentDatecl=Calendar.getInstance();
  					Calendar dtcl=Calendar.getInstance();
  					Calendar UntillDtcl=Calendar.getInstance();
  					Date currentDate=new Date();
  					Date dt=new Date();
  					Date UntillDt=new Date();
  					String chatStatus="";
  					id=-1;
  					if(result.size()>0)
  						{
  					
  							String ipadd = chan.socket().getInetAddress().getHostAddress(); 
  							DataRow drows=result.get(0);
  							id=Integer.parseInt(drows.getItem("USER_ID"));
  							//System.out.println(name+passWord+"   ufiyweiyfiuwey");
  							blockedUser=drows.getItem("IGNORED_USERS");
  							status=Integer.parseInt(drows.getItem("STATUS"));
  							chatStatus=drows.getItem("CHAT_STATUS");
  							java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat( "yyyy-MM-dd HH:mm:ss" );  
   				 
  							//System.out.print("hi comparison"+drows.getItem("B1")+"hi");
  							try
  							{
  								dt=(Date)sdf.parse("1111-11-11 11:11:11");
  								String st=drows.getItem("B1");
  								String st1=st.substring(0,4)+"-"+st.substring(4,6)+"-"+st.substring(6,8)+" "+st.substring(8,10)+":"+st.substring(10,12)+":"+st.substring(12,14);
  								UntillDt=(Date)sdf.parse(st1);
  								dtcl.setTime(dt);
  								UntillDtcl.setTime(UntillDt);
  								//System.out.print("o comparison"+st1+"lastDate"+UntillDt.compareTo(currentDate));
  								}
  							catch(ParseException e)
  							{
  								// System.out.print("o comparison"+drows.getItem("B1"));
  							}
  							//System.out.print("o comparison"+bingoDbm.authenticateIP(ipadd)+"hi");
  							if(( status==1 || ((status==-1)&& (dtcl.compareTo(UntillDtcl)!=0)&&(UntillDtcl.compareTo(currentDatecl)<0))))
  							{
  								try
  								{
  					
  									if(helper.getZone(getOwnerZone()).getUserByName(nick)!=null)
  									{
  										//u=currentZone.getUserByName("nick");
  										//trace(":::::::::::user is found again:::::::::");
  										helper.disconnectUser(helper.getZone(getOwnerZone()).getUserByName(nick));
  									}
  									
  									newUser = helper.canLogin(nick, pass, chan,getOwnerZone(),false);
  									newUser.setVariable("id",Integer.toString(id),UserVariable.TYPE_STRING);
  									newUser.setVariable("type","real",UserVariable.TYPE_STRING);
  									newUser.setVariable("name",nick,UserVariable.TYPE_STRING);
  									newUser.setVariable("NofB","100000",UserVariable.TYPE_STRING);
  								    newUser.setVariable("IU",blockedUser,UserVariable.TYPE_STRING);
  								  	newUser.setVariable("Utype",drows.getItem("USER_TYPE"),UserVariable.TYPE_STRING);
  									newUser.setVariable("chatS",chatStatus,UserVariable.TYPE_STRING);
  									// bingoDbm.setBalance(id,1000,0);
  									ArrayList<DataRow> result1=bingoDbm.getBalance(id);
  									//id=-1;
  									if(result1.size()>0)
  									{
  										//System.out.print("jai hind jai bharat{}{}{}{}{}{}}{{}{}{}{}{{");
  										DataRow drows1=result1.get(0);
  										// id=Integer.parseInt(drows.getItem("user_id"));
  										//System.out.print("cash balance{}{}{}{}{}{}}{{}{}{}{}{{"+drows1.getItem("CASH_BALANCE")+id+getOwnerZone());
  										newUser.setVariable("cashB",drows1.getItem("CASH_BALANCE"),UserVariable.TYPE_STRING);
  										newUser.setVariable("winB",drows1.getItem("WIN_BALANCE"),UserVariable.TYPE_STRING);
  										//newUser.setVariable("winB","2000",UserVariable.TYPE_STRING);
  										
   									}
  									else
  									{
  										newUser.setVariable("cashB","0.0",UserVariable.TYPE_STRING);
  										newUser.setVariable("winB","0.0",UserVariable.TYPE_STRING);
   									}
  									//setBalance(newUser, id);
  									loginResponse = new String[]{"8", String.valueOf(newUser.getUserId()), newUser.getName(), "10", "100"};
  									loginOk = true;
  									aobj[1]="1";
  					//ok = true;
  								}
  								catch (LoginException le)
  								{
  									this.trace("Could not login user: " + nick);
  									loginResponse = new String[]{ "loginKO", null, le.getMessage()};
  									aobj[1]="0";
  					
  								}
  				 
  								//aobj.putNumber("0", 1);
  				
  								sendResponse(aobj, -1, null, userList);
  				
  							}
  							else
  							{
  				
  								//0--fake user
  								//3--not active user
  								//2--banned user 
  				
  								if(status==0)
  								{
  									aobj[1]="3";
  								}
  								else
  								{
  									aobj[1]="2";
  								}
  								sendResponse(aobj, -1, null, userList); 	
  							}
  				 
  				
  			      }
  				else
  		  		{
  		  				 			
  		  			aobj[1]="0";
  		  	  		sendResponse(aobj, -1, null, userList); 	
  		  		}
  					
  				
  		  }
      }

		
		
   	if(evt.getEventName().equals(InternalEventObject.EVENT_USER_LOST)||evt.getEventName().equals(InternalEventObject.EVENT_LOGOUT)||evt.getEventName().equals(InternalEventObject.EVENT_USER_EXIT))
	{
		User juser = (User)evt.getObject("user");
		int _id=juser.getVariable("id").getIntValue();
		String ulist=juser.getVariable("IU").getValue();
		bingoDbm.setBlockedUser(_id, ulist);
		
	}
	
	}


}
