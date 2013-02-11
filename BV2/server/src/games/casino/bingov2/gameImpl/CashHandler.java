package games.casino.bingov2.gameImpl;

import java.nio.channels.SocketChannel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.ListIterator;

import it.gotoandplay.smartfoxserver.db.DataRow;
import it.gotoandplay.smartfoxserver.db.DbManager;
import it.gotoandplay.smartfoxserver.data.Room;
import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.data.UserVariable;
import it.gotoandplay.smartfoxserver.data.Zone;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.extensions.ExtensionHelper;
import it.gotoandplay.smartfoxserver.extensions.ISmartFoxExtension;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;
/*   related classes  with this extension
 * RequestHttp
 * GetUrlClass
 * moderator request
 */

public class CashHandler extends AbstractExtension
{
	 public RequestHttp _rhttp;
	 public String _URLstring;
	 public GetUrlClass _GURLC;
	 public ExtensionHelper helper;
	 private ModeratorRequest Moderator;
	 public Zone currentZone;
	 AbstractExtension ext;
	 public CentralCashHandler _cch;
	// private BingoDbm bingoDbm;
	 DbManager dbase2;
	 
	 public void init()
	{
		// bingoDbm=BingoDbm.getBingoDBM(getOwnerZone());
		 helper = ExtensionHelper.instance();
		 currentZone = helper.getZone(getOwnerZone());
		 _rhttp=new RequestHttp();
		 _GURLC=new GetUrlClass(getOwnerZone());
		 _URLstring=_GURLC.getUrl();
		 _cch=CentralCashHandler.getInstance(helper);
		 Moderator=new ModeratorRequest(this);
		 
	}
		public void sendInfoToZone(String cmd,String info)
		{
			
				ISmartFoxExtension iext = currentZone.getExtManager().get("zoneExt");
			     ext = (AbstractExtension)iext;
		     
			     HashMap  hmap=new HashMap();
			     hmap.put(0,"cashHandler");
				 hmap.put(1,cmd);
				 hmap.put(2,info);
			// System.out.print("+++++++++++++++++hihi"+hmap.get(3));
	    	ext.handleInternalRequest(hmap);
		}
	 
		public void sendInfoToMain(String cmd,String info,String RoomName)
		{
			// System.out.print("+++++++++++++++++hihi akhi r call hua"+RoomName);
				 ISmartFoxExtension iext = currentZone.getRoomByName(RoomName).getExtManager().get("gameExt");
				// System.out.print("+++++++++++++++++hihi akhi r call hua"+RoomName);
				 ext = (AbstractExtension)iext;
			     HashMap  hmap=new HashMap();
			     hmap.put(0,cmd);
				 hmap.put(1,info);
				// hmap.put(2,info);
			
	    	ext.handleInternalRequest(hmap);
		}
	 
	 public void insertMoneyTransaction(int id,String type,double CashB,double WinB,String Status)
		{
			String userQuery="insert into money_transaction_info(AccountID,Type,Date,Cash_Balance,Win_Balance,Status)values("+id+",'"+type+"',SYSDATE(),"+CashB+","+WinB+","+Status+")";
			dbase2.executeCommand(userQuery);
			
		}
		public String updateBalance(int id,double cashbalance)
		{
			//System.out.print("amount of the user"+cashbalance+winbalance);
			String userQuery="update accounts_master  set  cash_balance=cash_balance+"+cashbalance+" where account_number="+id+"";
			if(dbase2.executeCommand(userQuery))
			{
				 insertMoneyTransaction(id,"in",cashbalance,0.0,"0");	
			return "1";
			}
		    else
		    {
		    	 insertMoneyTransaction(id,"in",cashbalance,0.0,"1");
			return "0";	
		    }
		
		}
		public String setActiveStatus(String roomId,String status)
		{
			String userQuery="update star_room_master set active_status="+Integer.valueOf(status)+" where number="+Integer.valueOf(roomId)+" ";	
			if(dbase2.executeCommand(userQuery))
				{
				return "1";
				}
			else
			{
				return "0";	
			}
		}
		public void banUserChat(String username)
		{
			String sql ="update user_master set CHAT_STATUS=0 where user_name='"+username+"'";
			dbase2.executeCommand(sql);
		}
		public String setBalanceOnadminReq(String name,double cashbalance,double winbalance,String pwd,String cht_ban,String AccId,String uType)
		{
			cashbalance=cashbalance/100;
			winbalance=winbalance/100;
			try
			{
			String userQuery="select USER_ID from user_master where USER_NAME='"+name+"'";
			ArrayList<DataRow> result=dbase2.executeQuery(userQuery);
			if(result.size()>0)
			{
				userQuery="update user_master set USER_ID="+AccId+",CHAT_STATUS="+cht_ban+",PASSWORD='"+pwd+"',USER_TYPE="+uType+" where USER_NAME='"+name+"'";
				dbase2.executeCommand(userQuery);
			}
			else
			{
				userQuery="insert into user_master(USER_ID,USER_NAME,PASSWORD,EMAIL,REGISTRATION_DATE,AKEY,STATUS,BAN_UNTILL,user_note,CHAT_STATUS,USER_TYPE)values("+AccId+",'"+name+"','"+pwd+"','hi',SYSDATE(),'hi',1,'1111-11-11 11:11:11','hi',"+cht_ban+","+uType+")";
				dbase2.executeCommand(userQuery);
			}
			userQuery="select ACCOUNT_NUMBER from accounts_master where ACCOUNT_NUMBER='"+AccId+"'";
			result=dbase2.executeQuery(userQuery);
			if(result.size()>0)
			{
				userQuery="update accounts_master  set  CASH_BALANCE=CASH_BALANCE+"+cashbalance+",WIN_BALANCE=WIN_BALANCE+"+winbalance+" where ACCOUNT_NUMBER="+AccId+"";
				dbase2.executeCommand(userQuery);			
			}
			else
			{
				userQuery="insert into accounts_master(ACCOUNT_NUMBER,TOTAL_POINTS,CASH_BALANCE,WIN_BALANCE,ACCOUNT_STATUS)values("+AccId+",0,"+cashbalance+","+winbalance+" ,1)";
				dbase2.executeCommand(userQuery);
			}
			insertMoneyTransaction(Integer.parseInt(AccId),"in",cashbalance,winbalance,"0");		
			return "1";
			}
			catch (Exception e)
			{
				insertMoneyTransaction(Integer.parseInt(AccId),"in",cashbalance,winbalance,"1");
				return "0";
			}
			// userQuery="update accounts_master  set  win_balance="+winbalance+" where account_number="+id+"";
			// dbase2.executeCommand(userQuery);
		}
		public boolean setMsg(String rname,String welMsg,String Announce)
		{
			String userQuery="update star_room_master set WELCOME_MESSAGE='"+welMsg+"',ANNOUNCEMENT='"+Announce+"' WHERE NAME='"+rname+"'";
		   	return dbase2.executeCommand(userQuery);
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

		
	 
	 public Object handleInternalRequest(Object obj)
		{
			   
			    try{
			    	    HashMap objMap=(HashMap)obj;
					    String str="0";
			           if(objMap.get(0).equals("fromAdmin"))
	    		        {
	    			    return Moderator.handleModeratorRequest((String)objMap.get(1));	
	    		        }
	    		      else
	    		       {
			             dbase2=(DbManager)(objMap.get(0));
	    		        }
			         return "1";
			    }
			    catch (Exception e)
			    {
			    	
					// TODO: handle exception
			    	return "0";
			    	
				}
		}
	 
	 public void handleRequest(String cmd, ActionscriptObject ao, User u,int fromRoom)
	{
		 
	}
	 public void setBalance(int id,double cashbalance,double winbalance)
	 {
			String userQuery="update accounts_master  set  CASH_BALANCE="+cashbalance+",WIN_BALANCE="+winbalance+" where ACCOUNT_NUMBER="+id+"";
			dbase2.executeCommand(userQuery);		
	 }
	 public boolean setFailedBalance(int AccId,Double cashbalance,Double winbalance)
	{
				 String userQuery="insert into star_failed_account_master(ACCOUNT_NUMBER,CASH_BALANCE,WIN_BALANCE,TIME_OF_TRANSACTION)values("+AccId+","+cashbalance+","+winbalance+",SYSDATE())";
				  return dbase2.executeCommand(userQuery);
    }
	  public void sendMoneyOut(User u,Double amount)
      {
	    	 int flag=0;
	    	 double cashB=0.0;
	    	 double winB=0.0;
	    	 Double CashBalance =Double.valueOf(u.getVariable("cashB").getValue().trim()).doubleValue();
			 Double winBalance =Double.valueOf(u.getVariable("winB").getValue().trim()).doubleValue();
			// trace("CashBalance+winBalance"+CashBalance+winBalance+amount);
	    	 if(winBalance<amount)
		 		{
	    		 //trace("CashBalance+winBalance"+CashBalance+winBalance);
	    		    winB=winBalance;
	    		    amount=amount-winBalance;
	    		    winBalance=0.0;
	    		   // trace("now amount"+amount);
		 			if(CashBalance>=amount)
		 			{
		 				 
		 				CashBalance-=amount;
		 				cashB=amount;
		 				flag=1;
		 				//amount=0.0;
		 				// trace("now amount in core+cashBalance"+amount+CashBalance+flag);
		 			}
		 
		 		}
		 	else
		 	{  
		 		   winB=amount;
		 		   winBalance-=amount;
		 		   flag=1;
		 	}
	    	 if(flag==0)
	    	 {
	    		 sendResponseToUser(124,"-1", u);
	    		return; 
	    	 }
	    	 int id=u.getVariable("id").getIntValue();
		     double totalAmount=cashB*100+winB*100;
		     //http://v2.myglobalgames.com//nl/transferout
		     String url=_GURLC.getOutUrl();
		     String data="url="+_URLstring+"/TransferOutRequest&client_session_id=7967858765675&timestamp=123&account_id="+u.getVariable("id").getValue()+"&amount="+totalAmount+"&transaction_id=123456&licensee_reverse_password=123456&deposit_pot="+cashB*100+"&winning_pot="+winB*100;
		     String str="1";
		      str=_rhttp.SendRequest(url,data);
		         if(str.equals("0"))
				 {
					 insertMoneyTransaction(id,"out",cashB, winB,"0");
					 sendResponseToUser(124,Double.toString(winBalance+CashBalance), u);
			         u.setVariable("cashB",Double.toString(CashBalance),UserVariable.TYPE_STRING);
				     u.setVariable("winB",Double.toString(winBalance),UserVariable.TYPE_STRING);
					 setBalance(id, CashBalance, winBalance);   
					 sendResponseToUser(21,Double.toString(CashBalance)+","+Double.toString(winBalance), u);
				 }
				 else
				 {
					// trace("problem is here");
					 sendResponseToUser(124,"-1", u);
					 insertMoneyTransaction(id,"out",cashB, winB,"1"); 
				 }
		        
	  }
	 
	 public void handleRequest(String cmd, String[] params, User u, int fromRoom)
		{
			String type =u.getVariable("type").getValue();
			String str1="";
			int cmdValue = Integer.parseInt(params[0]);
			    if(cmdValue==123)
			   {
			      sendInRequest(u, params[1], params[2]);
			   }
			    if(cmdValue==124)
			    {
			    	   // sendMoneyOut(User u,Double amount)
				      sendMoneyOut(u, Double.parseDouble(params[1]));
			     } 
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
	    void sendResponseToUser(int cmd,String obj,User u)
		{
			//trace("jai hind");
			String aobj[]={Integer.toString(cmd),obj};
			LinkedList<SocketChannel> list=new LinkedList<SocketChannel>();
			list.add(u.getChannel());
			sendResponse(aobj, u.getRoom(),null, list);
			//trace("response sent.....................to the client");
		}
	     public String sendOutRequest(User u,Double cashB,Double winB)
	     {
	    	  int id=u.getVariable("id").getIntValue();
	    	 // str="1";
			      double totalAmount=cashB*100+winB*100;
			      
			      String url=_GURLC.getOutUrl();
			       String data="url="+_URLstring+"/TransferOutRequest&client_session_id=7967858765675&gameid="+getOwnerZone()+"&timestamp=123&account_id="+u.getVariable("id").getValue()+"&amount="+totalAmount+"&transaction_id=123456&licensee_reverse_password=123456&deposit_pot="+cashB*100+"&winning_pot="+winB*100;
			       String str=_rhttp.SendRequest(url,data);
				 if(str.equals("0"))
				 {
					 insertMoneyTransaction(id,"out",cashB, winB,"0");
				 }
				 else
				 {
					 insertMoneyTransaction(id,"out",cashB, winB,"1"); 
				 }
					
					// System.out.print("this is  out result"+str+"this is  out result");
			        return str;
		 }
		public void sendInRequest(User u,String pwd,String Amount)
		{
			_cch.sendInRequest(u, pwd,Amount);
			//trace("+++++++++++++finding in request+++++++++++++");
			/*
			int i=u.getVariable("id").getIntValue();
			 Double CashBalance =Double.parseDouble(u.getVariable("cashB").getValue().trim());
			 Double winBalance =Double.parseDouble(u.getVariable("winB").getValue().trim());
			 Double amt=Double.parseDouble(Amount)*100;
		     String url=_URLstring+"/TransferInRequest";
		  //http://v2.myglobalgames.com/nl/transferin
		  String data="url="+_URLstring+"/TransferInRequest&client_session_id=550.00&gameid="+getOwnerZone()+"&account_id="+i+"&password="+pwd+"&amount="+amt;
		  String str=_rhttp.SendRequest(_GURLC.getInUrl(),data);
		 // System.out.print("this is  in result"+str+"this is  in result");
		  String []splits = str.split(":");
		  if(splits[0].equals("0"))
		  {
			  double cB=CashBalance+roundOff(Double.parseDouble(splits[1])/100,2);
			  double wB=winBalance+roundOff(Double.parseDouble(splits[2])/100,2);
			  sendResponseToUser(21,cB+","+wB, u);
			  u.setVariable("cashB",Double.toString(cB),UserVariable.TYPE_STRING);
			  u.setVariable("winB",Double.toString(wB),UserVariable.TYPE_STRING);
			  setBalance(i, cB,wB); 
			  String total=Double.toString(roundOff(cB+wB,2));
			  sendResponseToUser(121,total, u); 
			  insertMoneyTransaction(i,"in",0.0,amt/100,"0");
				 
		  }
		  else
		  {
			  sendResponseToUser(121,"-1", u);  
			  insertMoneyTransaction(i,"in",0.0,amt/100,"1");
		  }*/
		 
		
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
				else if (evtname.equals("userLost")||evtname.equals("logOut"))
				{
					int id=juser.getVariable("id").getIntValue();
					juser.setVariable("left","1",UserVariable.TYPE_STRING);
					_cch.userLogout(id,juser.getName());
					/*
					
					Double CashBalance =Double.valueOf(juser.getVariable("cashB").getValue().trim()).doubleValue();
				    Double winBalance =Double.valueOf(juser.getVariable("winB").getValue().trim()).doubleValue(); 
				   // bingoDbm.setBalance(id, CashBalance, winBalance);
				    
				
			    	juser.setVariable("cashB","0.0",UserVariable.TYPE_STRING);
			    	juser.setVariable("winB","0.0",UserVariable.TYPE_STRING);
				   
				    if(!(sendOutRequest(juser,CashBalance,winBalance).equals("0")))
				  {
				    	//trace("++++++++++++this is trace to check failed account balance++++++++++"+getOwnerZone());
						   if(setFailedBalance(id, CashBalance, winBalance))
						   {
							  // trace("++++++++++++in side faoled block++++++++++"+getOwnerZone()); 
							   setBalance(id,0.0,0.0); 
						   }
			      }
				    
				    else
				    {
				    	 setBalance(id,0.0,0.0); 
				    }*/
				    
				   
				}
				else if (evtname.equals("userExit"))
				{
					
				}
		}



}
