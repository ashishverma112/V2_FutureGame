package games.casino.bingov2.gameImpl;
public class Bingo_Card {
	//hi
	public int fLineCount;
	public int sLineCount;
	public int tLineCount;
	private boolean fLineComplete;
	private boolean sLineComplete;
		public String cs; ////The Card String i.e the numbersvcbvb that are in the cards
	public Bingo_Card(String numberstring)
	{
		if(numberstring.length() == 0)
			return;
		cs = numberstring;
		fLineCount=5;
		sLineCount=5;
		tLineCount=5;
	}
	public int markNum(int lineNum,int forWhichlinewinner)
	{
		int i=0;
		if(lineNum==1)
		{
			fLineCount--;
			if(fLineCount==0)
			{
				i=checkForResponse(forWhichlinewinner);
			}
		}
		else if(lineNum==2)
		{
			sLineCount--;
			if(sLineCount==0)
			{
				i=checkForResponse(forWhichlinewinner);
			}
			
		}
		else if(lineNum==3)
		{
			tLineCount--;
			if(tLineCount==0)
			{
				i=checkForResponse(forWhichlinewinner);
			}
		}
		
		return i;
	}
	public void setlineComplete()
	{
		if(fLineComplete)
		{
			sLineComplete=true;
		}
		else
		{
			fLineComplete=true;
		}
		
	}
	public int checkForResponse(int forWhichlinewinner)
	{
		int i=0;
		if(forWhichlinewinner==1)
		{
			i=1;
		}
		else if(forWhichlinewinner==2)
		{
			if(fLineComplete)
			{
				i=2;
			}
		}
		else
		{
			if(sLineComplete)
			{
				i=3;
			}
		}
		setlineComplete();
		return i;
	}
}
