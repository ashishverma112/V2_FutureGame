package games.casino.bingov2.gameImpl;
import java.util.HashMap;
import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.data.Zone;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.extensions.ExtensionHelper;
import it.gotoandplay.smartfoxserver.extensions.ISmartFoxExtension;
public class CentralCashHandler {
	private static CentralCashHandler _userCashRequestHandler=null;
	private AbstractExtension ext;
	
	public CentralCashHandler(ExtensionHelper helper)
	{
		ISmartFoxExtension iext = helper.getZone("cashHandler").getExtManager().get("accountExt");
	     ext = (AbstractExtension)iext;
		//System.out.print("cxzcxzcxvcxxcvcx"+ext);
		
	}
	public static CentralCashHandler getInstance(ExtensionHelper ass)
	{
		if(_userCashRequestHandler==null)
		{
			_userCashRequestHandler=new CentralCashHandler(ass);	
		}
			return _userCashRequestHandler;
			
	}
	public void sendInRequest(User u,String pwd,String amt)
	{
		HashMap userObj=new HashMap();
	    userObj.put("user",u);
	    userObj.put("pwd",pwd);
	    userObj.put("amt",amt);
	    userObj.put("cmd","inReq");
	    ext.handleInternalRequest(userObj);
	}
	public void addAmount(int id,String username,Double cashB,Double winB )
	{
	     HashMap userObj=new HashMap();
   		    userObj.put("userName", username);
		    userObj.put("id", id);
		    userObj.put("cashB", cashB);
		    userObj.put("winB", winB);
		    userObj.put("cmd","addAmount");
		    ext.handleInternalRequest(userObj);
		  
	}
	public void substractAmount(int id,String username,Double amount)
	{
		    HashMap userObj=new HashMap();
		    userObj.put("userName", username);
		    userObj.put("id", id);
		    userObj.put("amt", amount);
		    userObj.put("cmd","subtractAmount");
		    ext.handleInternalRequest(userObj);
	}
	public String setBalanceOnadminReq(String []arr)
	{
		HashMap userObj=new HashMap();
        userObj.put("userName",arr[1]);
        userObj.put("cashB",arr[2]);
	    userObj.put("winB", arr[3]);
	    userObj.put("pwd", arr[4]);
	    userObj.put("chatBan",arr[5]);
	    userObj.put("accId", arr[6]);
	    userObj.put("uType",arr[7]);
	    userObj.put("cmd","setbalanceonAdminReq");
        return ext.handleInternalRequest(userObj).toString();
		
	}
	public String banUserChat(String uname,String state)
	{
		HashMap userObj=new HashMap();
        userObj.put("userName",uname);
        userObj.put("state",state);
   	    userObj.put("cmd","chatban");
        return ext.handleInternalRequest(userObj).toString();
		
	}
	public void userLogout(int id,String username)
	{
	     HashMap userObj=new HashMap();
   		    userObj.put("userName", username);
		    userObj.put("id", id);
		    userObj.put("cmd","userLogOut");
		    ext.handleInternalRequest(userObj);
		  
	}
	public void cashRequest(int id,String username,String zonename)
	{

		HashMap userObj=new HashMap();
	    userObj.put("userName", username);
	    userObj.put("zoneName", zonename);
	    userObj.put("id", id);
	    userObj.put("cmd","cashReq");
	   ext.handleInternalRequest(userObj);
	}

}
