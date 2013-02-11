package bingoV1.gameScreen 
{
	import gameCommon.screens.BaseScreen;
	import gameCommon.lib.SoundPlayer;
	/**
	 * ...
	 * @author ...
	 */
	public class GameTimerScreen extends BaseScreen
	{
		
		public function GameTimerScreen() 
		{			
		}
		
		override public function initialize():void
		{
			super.initialize();
			screenUI = new Resources.clockT();
			addChild(screenUI);
			
			//showTimer(5);
		}
		
		public function showTimer(timeValue:int):void
		{
			//trace("gahijkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk",timeValue);
			 var hour:int = timeValue / 3600;
			 var rest:int = timeValue % 3600;
			 var minute:int = rest / 60;
			  var second:int = rest % 60;
			//trace("second ",second ,"minut",minute,"hour",hour);
			//screenUI.watch.gotoAndStop(60 - second);
			//if (hour == 0 && minute == 0 && second <= 20)
					//SoundInitializer.playLastTimerSounds(second);
					var str:String = "";
					if (hour < 10)
					    str += "0" + hour.toString()+":";
					else 
					   str += hour.toString()+":";
					  if (minute < 10)
					   str += "0" + minute.toString()+":";
					  else 
					   str += minute.toString()+":";
					  if (second < 10)
					  {
						 // trace("ky hi h",second)
					   str += "0" + second.toString();
					    if (minute == 0 && hour == 0)
						{
					        SoundInitializer.playLastTimerSounds(second);
						}
					  }
					  else 
					  {
					   str += second.toString();
					   if (minute == 0 && hour == 0 && second==10)
						{
					        SoundInitializer.playLastTimerSounds(second);
						}
					  }
					   //trace("hi timer", str);
					   screenUI.timertxt.clock.text = str;
			 
		/*	   if (minute < 10)
			   {
				   var str1:String = "male" + second;
				   var str2:String = "female" + second;
					if(SoundScreen._femaleSounDClicked)
						SoundPlayer.playSound(str2);
					else
						SoundPlayer.playSound(str1);
			   	
						if (second < 10)
                       screenUI.clock.text = hour+ ":0" + minute + ":0" + second;
                    else
				       screenUI.clock.text = hour + ":0" + minute + ":"+ second;
				  if (hour == 0 && minute == 0)
				  {
					//SoundInitializer.playLastTimerSounds(second);
				  }
			   }
			   else
			   {
				  // 	trace(" else second ",second );
				   	if (second < 10)
                       screenUI.clock.text = hour + ":" + minute + ":0" + second;
                    else
				       screenUI.clock.text = hour + ":" + minute+ ":"+ second;
				   
			   }*/
			
		}
		public function setResize(hsf:Number,vsf:Number):void
		{
		  // screenUI.scaleX = hsf;
		  //screenUI.scaleY = vsf;
		 // screenUI.clock.scaleX = hsf;
		 // screenUI.clock.scaleY = vsf;
		  
			
		}
	}
}