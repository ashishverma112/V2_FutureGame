package games.casino.bingov2.gameImpl;

import it.gotoandplay.smartfoxserver.data.Room;
import it.gotoandplay.smartfoxserver.data.RoomVariable;
import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.data.UserVariable;
import it.gotoandplay.smartfoxserver.data.Zone;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.extensions.ISmartFoxExtension;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;

import java.nio.channels.SocketChannel;
import java.util.HashMap;
import java.util.LinkedList;

public class ModeratorRequest {
	
	CashHandler _ZE;
	ModeratorRequest(CashHandler ZE)
	{
		_ZE=ZE;
	}
	
	void sendResponseToUser(int cmd,String obj,User u)
	{
		//trace("jai hind");
		String aobj[]={Integer.toString(cmd),obj};
		LinkedList<SocketChannel> list=new LinkedList<SocketChannel>();
		list.add(u.getChannel());
		_ZE.sendResponse(aobj, u.getRoom(),null, list);
		//trace("response sent.....................to the client");
	}
	
	void sendResponsetochannel(int cmd,String obj,LinkedList<SocketChannel> list) 
	{
		//trace("jai hind");
		String aobj[]={Integer.toString(cmd),obj};
		_ZE.sendResponse(aobj,-1,null, list);
		//trace("response sent.....................to the client");
	}
	public Object handleModeratorRequest(String msgRcv)
	{
				//trace("Moderator Command : "+msgRcv);
         String result="0";
		if(msgRcv.length() <= 1 )
		{
			return "0";
		}

		String []splits = msgRcv.split(":");
		Zone z =_ZE.currentZone;
		User u = null;
		Room gameRoom = null;
		ActionscriptObject aobj = null;
		RoomVariable var = null;
		HashMap variables = null;

		switch(Integer.valueOf(splits[0]))
		{
			case 1: //Recharge user account
				if(Integer.valueOf(splits[1])>0&&Double.valueOf(splits[2])>0.0)
				{
				  result= _ZE.updateBalance(Integer.valueOf(splits[1]),Double.valueOf(splits[2]));
				 
				}
				else
				{
					return "0";
				}
				break;
			case 2: // change Room Active Status
				
				if((splits[1] == null) || (splits[1].length() <= 0) || (splits[2] == null) || (splits[2].length() <= 0))
					return "0"; 
			     result= _ZE.setActiveStatus(splits[1],splits[2]);
				break;
			case 3: // Banning User
				
				String uname = splits[1];
				u = z.getUserByName(uname);

				_ZE.helper.kickUser(u, 0, "");
				break;

			case 4: // Dynamic bonus announcement from admin 
				break;
				
			case 5:
				//Ban the user from chat
				
				u = z.getUserByName(splits[1]);

				//_ZE.banUserChat(splits[1]);
                _ZE._cch.banUserChat(splits[1],"0");
				if(u!=null)
				{

					sendResponseToUser(101,splits[2], u);
					u.setVariable("chatS",splits[2],UserVariable.TYPE_STRING);
				}
				else
				{
					//trace("Banning User from chat but User Object could not be found");
				}

				break;
			case 6:
				////to destroy the room+++++++++++++++++++++++++++
				
				//trace("splits[1]+++++++++++++++"+splits[1]);
				gameRoom = z.getRoomByName(splits[1]);
				//z.activeRoomSet.remove(gameRoom.getVariable("rid").getIntValue());
				ISmartFoxExtension iext1 = gameRoom.getExtManager().get("gameExt");
				AbstractExtension ext1 = (AbstractExtension)iext1;
				HashMap robj1=new HashMap();
				robj1.put(0,"6");
				//robj1.put(1,splits[2]);
				ext1.handleInternalRequest(robj1);
             	break;

			case 7:
				//Personal message from admin to user
				
				u = z.getUserByName(splits[1]);
				if(u!=null)
				{
					sendResponseToUser(103,splits[2], u);
				}
				else
				{
					//trace("Sending personal message to user but User Object could not be found");
				}

				break;
			case 8: //This is used in Star Bingo. Not in 75 Ball Bingo
				break;
		    case 9:
			  // _ZE.checkForRoomCreation();
			  break;
		    case 10:
				//System.out.print("php is called here(((((((((()))))))))))"+msgRcv);
				if(splits.length>=8)
				{
				  _ZE._cch.setBalanceOnadminReq(splits);
				  // result=_ZE.setBalanceOnadminReq(splits[1],Double.parseDouble(splits[2]),Double.parseDouble(splits[3]),splits[4],splits[5],splits[6],splits[7]);
				}
				break;
			case 11:
				if(splits.length>=4)
				{
				     Room rm=_ZE.currentZone.getRoomByName(splits[1]);
				     HashMap<String,RoomVariable> roomVarMap=new HashMap<String,RoomVariable>(); 
					 RoomVariable bWinRv = new RoomVariable(splits[2],"s",null,true,true);
					 RoomVariable pWinRv = new RoomVariable(splits[3],"s",null,true,true);
					 roomVarMap.put("wMsg", bWinRv);
					 roomVarMap.put("announcement", pWinRv);
					 _ZE.setMsg(splits[1],splits[2],splits[3]);
				//	System.out.print("value of the variables in the room...."+cardValue+amountInGame+bingoP+patternP);
					_ZE.helper.setRoomVariables(rm, null,roomVarMap, true, true);
				}
					break;
			case 12:
				//oooooooooooooooooo
				
				_ZE.sendMsgToAllRoom(splits[1]);
				break;
			case 13:
				_ZE.sendInfoToZone("13","checkforRoomCreation");
				break;
			case 14:
				if(splits.length>=3)
				{
				//System.out.print("14 no command"+splits[1]+"hi"+splits[2]);
				_ZE.sendInfoToMain("14",splits[2],splits[1]);
				
				}
					
				break;
			case 501:
				//System.out.print("this dsfdsfdfgdgfdgfdgfdg"+_ZE.currentZone.getUserCount());
			    return Integer.toString(_ZE.currentZone.getUserCount());
					
				
			
			  
			}
		return result;
	}


}
