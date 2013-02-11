package games.casino.bingov2.gameImpl;
import it.gotoandplay.smartfoxserver.db.DataRow;
import it.gotoandplay.smartfoxserver.db.DbManager;
import it.gotoandplay.smartfoxserver.util.scheduling.Scheduler;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;




public class BingoDbm {
	//static String userName = "root";
	//static String userPassword = "arthah";
	//static String databaseUrl = "jdbc:mysql://localhost:3306/slotmachine";
	//static String userQuery="select * from player_login";
	public int _authentication;
	private static int initted = 0;
	//private static BingoDBM _me = null;
	DbManager dbase2;
	HashMap<String,String> whiteListedIPs=null;
	private Scheduler scheduler;
	private static BingoDbm _DutchMe=null;
	private static BingoDbm _SpanishMe=null;
	private static BingoDbm _GermanMe=null;
	public static ArrayList<DataRow> currentRoomList;
	public static ArrayList<DataRow> currentJackpotRoom;
	public static ArrayList<DataRow> jackInfo;
	public static ArrayList<DataRow> bg;
	public static BingoDbm getBingoDBM(String language)
	{
		if (language.equals("BingoV2_Duch"))
		{	
			if(_DutchMe == null)
			{
				//System.out.print("duch instantiate");
				_DutchMe = new BingoDbm(language);
			}		
			return _DutchMe;
		}
		if (language.equals("BingoV2_Germany"))
		{	
			if(_GermanMe == null)
			{
				//System.out.print("Germany instantiate");
				_GermanMe = new BingoDbm(language);
			}		
			return _GermanMe;
		}
		if (language.equals("BingoV2_Spanish"))
		{	
			if(_SpanishMe == null)
			{
				//System.out.print("spanish instantiate");
				_SpanishMe = new BingoDbm(language);
			}		
			return _SpanishMe;
		}		
		return null;
	}
	public DbManager getDBmanager()
	{
		return dbase2;
	}
	public BingoDbm(String language)
	{
		
		String driverName = "org.gjt.mm.mysql.Driver";
		
		String connString = "jdbc:mysql://localhost:3306/"+language;
		//System.out.print("hi db----"+connString+"hi db-------");
		//connString+=ZoneLevelExtension.zoneName;
		String userName = "root";
		String pword = "arthah";
		String connName = language;
		int maxActive = 150;
		int maxIdle = 10;
		String exhaustedAction = "fail";
		int blockTime = 5000;
			   
		dbase2 = new DbManager(   driverName,
			                           connString,
			                           userName,
			                           pword,
			                           connName,
			                           maxActive,
			                           maxIdle,
			                           exhaustedAction,
			                           blockTime
			                        );
		
		
		/*for(int i=0;i< result.size();++i)
		{
			//System.out.println("Name:\t"						+ result.get(i));
			//System.out.println("password:\t"						+ result.getString("password"));	
			System.out.println("");
		}*/
		
			   
	}
	public HashMap getUserDetails(String username)
	{
		String sql = "select user_master.USER_ID, user_master.USER_TYPE, user_master.USER_NAME, user_master.EMAIL, user_master.STATUS, user_master.REGISTRATION_DATE, user_master.LAST_LOGIN, user_master.AKEY, user_master.CHAT_STATUS, user_master.IGNORED_USERS , accounts_master.TOTAL_POINTS , accounts_master.CASH_BALANCE , accounts_master.WIN_BALANCE , accounts_master.WIN_BALANCE, accounts_master.ACCOUNT_STATUS from user_master inner join accounts_master on user_master.USER_NAME='"+username+"' AND user_master.USER_ID=accounts_master.ACCOUNT_NUMBER";
	
		ArrayList<DataRow> drows = dbase2.executeQuery(sql);
		if(drows.size()<= 0)
		{
			return null;
		}
		
		HashMap uMap = new HashMap();
		DataRow drow = drows.get(0);
		
		uMap.put("user_id", new String(drow.getItem("USER_ID")));
		uMap.put("user_type", new String(drow.getItem("USER_TYPE")));
		uMap.put("chat_status", new String(drow.getItem("CHAT_STATUS")));
		uMap.put("user_name", new String(drow.getItem("USER_NAME")));
		uMap.put("email", new String(drow.getItem("EMAIL")));
		uMap.put("status", new String(drow.getItem("STATUS")));
		uMap.put("reg_date", new String(drow.getItem("REGISTRATION_DATE")));
		uMap.put("akey", new String(drow.getItem("AKEY")));

		if(drow.getItem("LAST_LOGIN") != null)
			uMap.put("last_login", new String(drow.getItem("LAST_LOGIN")));
		else
			uMap.put("last_login", new String(""));

		if(drow.getItem("IGNORED_USERS") != null)
			uMap.put("ignoredUsers", new String(drow.getItem("IGNORED_USERS")));
		else
			uMap.put("ignoredUsers", new String(""));

		uMap.put("points", new String(drow.getItem("TOTAL_POINTS")));
		uMap.put("cash", new String(drow.getItem("CASH_BALANCE"))); //This is the amount which user has recharged uptil now
		uMap.put("winb", new String(drow.getItem("WIN_BALANCE"))); //This is the balance which user has won till now
		uMap.put("astatus", Integer.parseInt(drow.getItem("ACCOUNT_STATUS")));
		
		return uMap;
		
	}

	public void saveBonusDetails(long gameid, long bonusid)
	{
		String sql = "update game_records set BONUSID="+bonusid + " where GAME_ID="+gameid;
		dbase2.executeCommand(sql);
	}
	public void banUserChat(String username)
	{
		String sql ="update user_master set CHAT_STATUS=0 where user_name='"+username+"'";
		dbase2.executeCommand(sql);
	}
	public String getLobbyWelcomeMessage()
	{
		//System.out.print("(((((((((((()))))))))))))");
		String userQuery = "select * from LOBBY_MASTER";
		ArrayList<DataRow> arr=new ArrayList<DataRow>();
    	arr=dbase2.executeQuery(userQuery);
    	//System.out.print("reboot_______"+arr.get(0).getItem("REBOOT")+"reboot_______");
    	if(arr.size()>0)
    	{
    		//System.out.print(arr.get(0).getItem("WELCOME_MEASAGE")+"(((((((((((()))))))))))))");
    	   return arr.get(0).getItem("WELCOME_MEASAGE");
    	}
    	return "no message";
		
	}
	public int getRebootStatus(int roomid)
	{
		String userQuery = "select REBOOT  from v2_room_master where number="+roomid+"";
		ArrayList<DataRow> arr=new ArrayList<DataRow>();
    	arr=dbase2.executeQuery(userQuery);
    	//System.out.print("reboot_______"+arr.get(0).getItem("REBOOT")+"reboot_______");
    	 return Integer.parseInt(arr.get(0).getItem("REBOOT"));
		
	}
	public int getmaxgameid(int roomId)
	{
		//v2_eachUserInfo
		String newQuery = "select * from star_game_records where ROOM_ID="+roomId+" order by ID desc limit 1";
		ArrayList<DataRow> result= dbase2.executeQuery(newQuery);
		//System.out.println(" result size " +result.size());
		DataRow dr=result.get(0);
		//System.out.println(" result size "+dr.g);
		int gameId = Integer.parseInt(dr.getItem("ID"));
		return gameId;
	}
	public int getmaxidfromEachuserinfo(int roundid,String nm,int gameid)
	{
		//
		String newQuery = "select * from v2_eachUserInfo where game_id="+gameid+" and round_id="+roundid+" and username='"+nm+"' order by ID desc limit 1 ";
		ArrayList<DataRow> result= dbase2.executeQuery(newQuery);
		//System.out.println(" result size " +result.size());
		DataRow dr=result.get(0);
		//System.out.println(" result size "+dr.g);
		int gameId = Integer.parseInt(dr.getItem("ID"));
		return gameId;
	}
	public void setRebootStatus(int roomid)
	{
		String sql ="update star_room_master set REBOOT=0 where NUMBER="+roomid+"";
		//System.out.println(sql + " this is the sql");
		System.out.println(dbase2.executeCommand(sql) + " result of the query");
	}
	
	public void updateGameRecord(String []info,int GameId)
	{
		String userQuery="insert into v2_game_records(GAME_ID,ROUND_ID,ROOM_ID,START_TIME,FIRSTLINE_AMOUNT,SECONDLINE_AMOUNT,BINGO_AMOUNT,FIRSTLINE_WINNERS,SECONDLINE_WINNERS,BINGO_WINNERS,ALLBALLS,TOTAL_PLAYERS,TOTAL_BOOKS,TOTAL_STAKE)";
	//	String userQuery="update v2_game_records set START_TIME='"+info[1]+"',TOTAL_PLAYERS="+info[3]+",TOTAL_STAKE="+info[4]+",FIRSTLINE_AMOUNT="+info[5]+",SECONDLINE_AMOUNT="+info[6]+",BINGO_AMOUNT="+info[7]+",FIRSTLINE_WINNERS='"+info[8]+"',SECONDLINE_WINNERS='"+info[9]+"',BINGO_WINNERS='"+info[10]+"',ALLBALLS='"+info[11]+"' where ID="+GameId+"";
		userQuery+="values("+GameId+","+info[0]+","+info[1]+",'"+info[2]+"','"+info[3]+"','"+info[4]+"','"+info[5]+"','"+info[6]+"','"+info[7]+"','"+info[8]+"','"+info[9]+"',"+info[10]+","+info[11]+",'"+info[12]+"')";
		dbase2.executeCommand(userQuery);
		//deleteFromIn_btw_crads(info[1]);
	}
	public void initializeGameRecord(String []info,int gameId)
	{
		//System.out.print("++++++++++++++++++game records code is executed++++++++++++++++++++");
		String userQuery="insert into v2_game_records(ID,ROUND_ID,ROOM_ID,START_TIME,FIRSTLINE_AMOUNT,SECONDLINE_AMOUNT,BINGO_AMOUNT,FIRSTLINE_WINNER,SECONDLINE_WINNER,BINGO_WINNER,ALLBALLS,TOTAL_PLAYERS,TOTAL_BOOKS,TOTAL_STAKE)";
		userQuery+="values("+gameId+","+info[0]+",'"+info[1]+"',"+info[2]+","+info[3]+","+info[4]+","+info[5]+","+info[6]+","+info[7]+",'"+info[8]+"','"+info[9]+"','"+info[10]+"','"+info[11]+"')";
		dbase2.executeCommand(userQuery);
	}
	
		
	public ArrayList<DataRow> fetchActiveRoom(int num)
	{
			
		
		//String userQuery="select * from room_master inner join jackpot_settings on room_master.number=jackpot_settings.room_id  where active_status=1 ";
		String userQuery="select ID,NUMBER,NAME,BOOKPRICE1, BOOKPRICE2,BOOKPRICE3,BOOKPRICE4,BOOKPRICE5,BOOKPRICE6,MIN_PLAYERS,MAX_PLAYERS,ANNOUNCEMENT,WELCOME_MESSAGE,REBOOT,GAMEDT,TOTAL_GAME,InBtTime,CHAT from v2_room_master where GAMEDT>SYSDATE() and NUMBER="+num+" order by GAMEDT asc ";
		currentRoomList=new ArrayList<DataRow>();
    	currentRoomList=dbase2.executeQuery(userQuery);
    	return currentRoomList;
    	// System.out.print("backgr??????"+currentRoomList.size()+"?????????background");
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
	
	public String getPrizeByRoomId(int gmid)
	{
		StringBuilder prize1=new StringBuilder();
		StringBuilder prize2=new StringBuilder();
		StringBuilder prize3=new StringBuilder();
		String newQuery = "select PRIZE1,PRIZE2,PRIZE3 from v2_prizes_table where GAME_ID="+gmid+" order by ROUND_ID asc";
		ArrayList<DataRow> result= dbase2.executeQuery(newQuery);
		//System.out.println(" result size " +result.size());
		for(int i=0;i<result.size();i++)
		{
			DataRow dr=result.get(i);
			if(i!=0)
			{
				prize1.append(";");	
				prize2.append(";");	
				prize3.append(";");	
			}
			prize1.append(dr.getItem("PRIZE1"));
			prize2.append(dr.getItem("PRIZE2"));
			prize3.append(dr.getItem("PRIZE3"));
		}
		
		//System.out.println(" result ###################################size "+prize1.toString());
	     return prize1.toString()+":"+prize2.toString()+":"+prize3.toString();
		
	}
	

	public ArrayList<DataRow> authenticateUser(String name,String passWord)
	{
		String userQuery="select USER_ID,IGNORED_USERS,STATUS,BAN_UNTILL - '0000-00-00 00:00:00' as B1,CHAT_STATUS,USER_TYPE from user_master where USER_NAME LIKE binary '"+name+"' and PASSWORD LIKE binary '"+passWord+"'";
		ArrayList<DataRow> result=dbase2.executeQuery(userQuery);
		if(result.size()>0)
		{
	     userQuery="update user_master set LAST_LOGIN =SYSDATE() where USER_NAME='"+name+"'";
	     dbase2.executeCommand(userQuery);
		}
	
		return result;
				
	}
	
	public boolean authenticateIP(String ipadd)
	{
		String userQuery="select IP from ip_blacklist_table where IP='"+ipadd+"'";
		ArrayList<DataRow> result=dbase2.executeQuery(userQuery);
		if(result.size()>0)
		{
			return false;
		}
		else
		{
			 userQuery="select BANNEDDT,BANNED from ip_list where IPADDR='"+ipadd+"'";
			 result=dbase2.executeQuery(userQuery);
			 if(result.size()>0)
			 {
				 DataRow dr=result.get(0);
				 String dt1=dr.getItem("BANNEDDT");
				 Calendar dtcl=Calendar.getInstance();
				 Calendar current=Calendar.getInstance();
				 java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat( "yyyy-MM-dd HH:mm:ss" );  
				// Date dt=new Date();
				 if(dr.getItem("BANNED").equals("1"))
				 {
					 		try
					 		{
					 			Date dt=(Date)sdf.parse(dt1);
					 			dtcl.setTime(dt);
					 		}
					 		catch(ParseException e)
					 		{
					 			// System.out.print("o comparison"+drows.getItem("B1"));
					 		}
				      if(current.compareTo(dtcl)>0)
				      {
				    	  return true;
				      }
				      else
				      {
				    	return false;
				      }
				 }
				 else
				 {
					 return true;  
				 }
				 
				 
			 }
			 else
			 {
				 return true;
			 }
		}
		
		
	}
	public ArrayList<DataRow> getBalance(int id)
	{
     	String userQuery="select CASH_BALANCE,WIN_BALANCE from accounts_master where ACCOUNT_NUMBER="+id+"";
		ArrayList<DataRow> result=dbase2.executeQuery(userQuery);
		return result;
	}
	public String setBalanceOnadminReq(String name,double cashbalance,double winbalance,String pwd,String cht_ban,String AccId,String uType)
	{
		cashbalance=cashbalance/100;
		winbalance=winbalance/100;
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
				
		return "1";
		// userQuery="update accounts_master  set  win_balance="+winbalance+" where account_number="+id+"";
		// dbase2.executeCommand(userQuery);
	}
	
	public void setBalance(int id,double cashbalance,double winbalance)
	{
		//System.out.print("amount of the user"+cashbalance+winbalance);
		String userQuery="update accounts_master  set  cash_balance="+cashbalance+",win_balance="+winbalance+" where account_number="+id+"";
		dbase2.executeCommand(userQuery);
		// userQuery="update accounts_master  set  win_balance="+winbalance+" where account_number="+id+"";
		// dbase2.executeCommand(userQuery);
	}
	public boolean setMsg(String rname,String welMsg,String Announce)
	{
		String userQuery="update star_room_master set WELCOME_MESSAGE='"+welMsg+"',ANNOUNCEMENT='"+Announce+"' WHERE NAME='"+rname+"'";
	   	return dbase2.executeCommand(userQuery);
	}
	public void setBlockedUser(int id,String str)
	{
		String userQuery="update user_master set IGNORED_USERS ='"+str+"' where USER_ID="+id+"";
		dbase2.executeCommand(userQuery);
	}
	public void inserteachUserInfo(String name,int gid,int roundid,int buycard,String cards,int won,String totalp)
	{
		String userQuery="insert into v2_eachUserInfo (username,game_id,round_id,buyed_books,cards,totalpaid,won) values('"+name+"',"+gid+","+roundid+","+buycard+",'"+cards+"','"+totalp+"','"+won+"')";
		dbase2.executeCommand(userQuery);
		//System.out.println("hia userinfo exicuted");
	}
	public void finaleachUserInfo(String name,int gid,int roundid,int buycard,String cards,int won,String totalp,int id)
	{
		//String userQuery="update v2_eachUserInfo set BUYED_BOOKS="+buycard+",CARDS='"+cards+"',TOTAL_PAID='"+totalp+"',WON='"+won+"' where USER_NAME='"+name+"' and GAME_ID="+gid+" and ROUND_ID="+roundid+"";
		String userQuery="update v2_eachUserInfo set buyed_books="+buycard+",cards='"+cards+"',totalpaid='"+totalp+"',won='"+won+"' where ID="+id+"";
		dbase2.executeCommand(userQuery);
		//System.out.println("hia userinfo exicuted");
	}
	public void setFailedBalance(int AccId,Double cashbalance,Double winbalance)
	{
		 String userQuery="insert into star_failed_account_master(ACCOUNT_NUMBER,CASH_BALANCE,WIN_BALANCE)values("+AccId+","+cashbalance+","+winbalance+")";
		dbase2.executeCommand(userQuery);
	} 
	 public void insertMoneyTransaction(int id,String type,double CashB,double WinB,String Status)
     {
			String userQuery="insert into money_transaction_info(AccountID,Type,Date,Cash_Balance,Win_Balance,Status)values("+id+",'"+type+"',SYSDATE(),"+CashB+","+WinB+","+Status+")";
			dbase2.executeCommand(userQuery);
	 }
	
	 public void UpdatenoOfBookBuyed(int Buyedcard,int id)
	 {
		// System.out.print("this is the call for update card no++++++++++"+Buyedcard+"and"+gameid+"nad"+roundId);
		  String userQuery="update v2_eachUserInfo  set buyed_books="+Buyedcard+" where ID="+id+"";
		   dbase2.executeCommand(userQuery);
					
	}
	 public void insertIntoIn_btw_cards(int roomid,int gameid,int userid,int noofcards)
	   {
		  String userQuery="insert into IN_BTW_CARD_INFO_V2(ROOMID,GAMEID,USERID,NO_OF_CARDS,TIME)values("+roomid+",'"+gameid+"',"+userid+","+noofcards+",SYSDATE())";
			dbase2.executeCommand(userQuery); 
	   }
	  public void deleteFromIn_btw_crads(String roomid)
	   {
   		  String userQuery="delete from IN_BTW_CARD_INFO_V2 where ROOMID="+roomid+"";
			dbase2.executeCommand(userQuery); 
	   }
	
	public String updateBalance(int id,double cashbalance)
	{
		//System.out.print("amount of the user"+cashbalance+winbalance);
		String userQuery="update accounts_master  set  cash_balance=cash_balance+"+cashbalance+" where account_number="+id+"";
		if(dbase2.executeCommand(userQuery))
		{
		return "1";
		}
	    else
	    {
		return "0";	
	    }
	
	}
	public String getBookValueAmount(int gameid, String bookprice) {
		
		String userQuery = "select "+bookprice+" from  v2_room_master where ID="+gameid+"";
		
    	 DataRow dr= (DataRow) dbase2.executeQuery(userQuery).get(0);
    	 
		return dr.getItem(bookprice);
	}
	
	

}
