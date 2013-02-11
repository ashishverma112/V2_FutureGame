 package games.casino.bingov2.gameImpl;

import java.util.Arrays;
import java.util.Vector;

//import starbingo90.bingo.Bingo_Main;
import games.casino.bingov2.gameImpl.Bingo_Card;


//Card page collection of 6 Cards
public class CardPage {
	
	public Vector <Bingo_Card> cardVector;
	public String pageString;
	public Boolean cardString;	
	public String curWinCardString;
	public int numByIndex[]=new int[91];
	public static 	int threeD[][][] = {{{0,5,6,8,11,13,14,16,18,20,24,26},{3,5,6,7,9,10,15,16,18,19,20,26},{1,3,4,6,9,10,13,17,21,23,24,26},{2,3,4,7,10,12,14,17,18,20,22,24},{0,1,3,7,10,11,13,15,18,21,23,25},{0,1,3,7,11,13,14,16,20,22,23,26}},
		{{0,1,3,7,11,13,14,16,20,22,23,26},{0,5,6,8,11,13,14,16,18,20,24,26},{1,3,4,6,9,10,13,17,21,23,24,26},{2,3,4,7,10,12,14,17,18,20,22,24},{0,1,3,7,10,11,13,15,18,21,23,25},{3,5,6,7,9,10,15,16,18,19,20,26}},
		{{3,5,6,7,9,10,15,16,18,19,20,26},{0,1,3,7,11,13,14,16,20,22,23,26},{1,3,4,6,9,10,13,17,21,23,24,26},{0,1,3,7,10,11,13,15,18,21,23,25},{0,5,6,8,11,13,14,16,18,20,24,26},{2,3,4,7,10,12,14,17,18,20,22,24}},
		{{0,1,6,8,12,13,15,16,18,20,22,26},{0,1,4,7,13,14,15,16,18,19,23,24},{2,3,5,6,9,11,13,17,19,21,23,24},{1,2,6,7,9,11,12,17,19,21,22,25},{0,2,3,7,10,11,14,16,18,21,23,26},{0,2,3,8,13,14,15,17,19,22,23,25}},
		{{2,3,5,6,9,11,13,17,19,21,23,24},{0,2,3,8,13,14,15,17,19,22,23,25},{0,1,4,7,13,14,15,16,18,19,23,24},{0,1,6,8,12,13,15,16,18,20,22,26},{1,2,6,7,9,11,12,17,19,21,22,25},{0,2,3,7,10,11,14,16,18,21,23,26}},
		{{0,2,3,7,10,11,14,16,18,21,23,26},{0,2,3,8,13,14,15,17,19,22,23,25},{0,1,6,8,12,13,15,16,18,20,22,26},{0,1,4,7,13,14,15,16,18,19,23,24},{2,3,5,6,9,11,13,17,19,21,23,24},{1,2,6,7,9,11,12,17,19,21,22,25}},
		{{1,2,3,6,10,12,13,17,18,20,22,24,},{1,3,5,6,9,12,14,16,18,19,22,26},{0,4,5,6,11,13,14,17,19,20,21,25},{0,3,5,8,10,11,15,16,18,20,23,25},{1,2,6,7,10,13,15,17,18,22,23,25},{0,6,7,8,9,12,13,17,20,21,23,25}},
		{{1,2,6,7,10,13,15,17,18,22,23,25},{0,6,7,8,9,12,13,17,20,21,23,25},{1,2,3,6,10,12,13,17,18,20,22,24,},{1,3,5,6,9,12,14,16,18,19,22,26},{0,3,5,8,10,11,15,16,18,20,23,25},{0,4,5,6,11,13,14,17,19,20,21,25}},
		{{0,6,7,8,9,12,13,17,20,21,23,25},{1,3,5,6,9,12,14,16,18,19,22,26},{1,2,3,6,10,12,13,17,18,20,22,24,},{0,4,5,6,11,13,14,17,19,20,21,25},{1,2,6,7,10,13,15,17,18,22,23,25},{0,3,5,8,10,11,15,16,18,20,23,25}},
		{{0,5,6,7,9,10,12,17,19,20,23,26},{1,2,3,7,13,14,15,17,18,20,23,26},{1,4,5,8,12,15,16,17,19,20,22,25},{3,5,6,7,9,10,13,17,18,19,21,24},{2,4,5,6,9,11,12,16,18,19,22,25},{0,2,3,6,11,12,13,16,18,22,23,24}},
		{{2,4,5,6,9,11,12,16,18,19,22,25},{0,2,3,6,11,12,13,16,18,22,23,24},{1,2,3,7,13,14,15,17,18,20,23,26},{1,4,5,8,12,15,16,17,19,20,22,25},{3,5,6,7,9,10,13,17,18,19,21,24},{0,5,6,7,9,10,12,17,19,20,23,26}},
		{{1,2,3,7,13,14,15,17,18,20,23,26},{3,5,6,7,9,10,13,17,18,19,21,24},{0,2,3,6,11,12,13,16,18,22,23,24},{0,5,6,7,9,10,12,17,19,20,23,26},{1,4,5,8,12,15,16,17,19,20,22,25},{2,4,5,6,9,11,12,16,18,19,22,25}},
		{{0,2,6,7,9,10,15,17,20,21,23,25},{0,2,3,8,9,10,14,15,21,22,23,25},{1,4,6,7,10,12,13,17,21,23,24,26},{1,4,6,7,9,11,14,17,19,21,22,26},{0,2,4,7,9,13,14,16,19,20,23,26},{1,2,3,6,9,11,14,16,18,21,22,24}},
		{{0,2,3,8,9,10,14,15,21,22,23,25},{1,4,6,7,9,11,14,17,19,21,22,26},{1,2,3,6,9,11,14,16,18,21,22,24},{0,2,6,7,9,10,15,17,20,21,23,25},{1,4,6,7,10,12,13,17,21,23,24,26},{0,2,4,7,9,13,14,16,19,20,23,26}},
		{{0,2,4,7,9,13,14,16,19,20,23,26},{1,2,3,6,9,11,14,16,18,21,22,24},{0,2,3,8,9,10,14,15,21,22,23,25},{1,4,6,7,10,12,13,17,21,23,24,26},{0,2,6,7,9,10,15,17,20,21,23,25},{1,4,6,7,9,11,14,17,19,21,22,26}}
		};
	
	public CardPage()
	{
		cardVector = new Vector <Bingo_Card>();
		cardString = false;
		generateCards();
	}
	
	public int markNumberInCards(int number,int pstate)
	{
		int index=numByIndex[number];
		int cardindex=(index-1)/27;
		int lineIndex=((index-1)%27)/9+1;
		Bingo_Card bc=cardVector.get(cardindex);
		int result=bc.markNum(lineIndex,pstate);
		//System.out.print("trace for number"+number+"cardnumber"+cardindex+"line number"+lineIndex);
		if(result!=0)
		{
			curWinCardString =bc.cs;
		}
	    return result;
		
	}
	
	
	//generate cards in a particular page
	public void generateCards()
	{
		cardVector.clear();
		cardString = true;
		String newPageString = createCardNumbers();
		String cardsplit[] = newPageString.split(";");
		//System.out.print("total no in card++++++++++++++++++++++++++++++++++++++++++++++"+newPageString);
		//System.out.print("numbers of card++++++++++++++++++++++++++++++++++++++++++++++"+cardsplit[0]);
		for (int i = 0; i < cardsplit.length ;i++)
		{	
			Bingo_Card newcard = new Bingo_Card(cardsplit[i]);
			cardVector.add(newcard);
			String cardnumArray[]=cardsplit[i].split(",");
			for(int j=0;j<cardnumArray.length;j++)
			{
				int num=Integer.parseInt(cardnumArray[j]);
				if(num!=0)
				{
					
					//System.out.print("number"+num+"index"+(i*27+(j+1)));
					numByIndex[num]=i*27+(j+1);
				}
			}
		}
		
		pageString = newPageString;		
	}
	
	
	//Returns string which represents a card page.
	//String set of "set of numbers separated by comma " separated by semicolon
	//individual set corresponds to a particular card
	//0 represents empty space and number a number
	private static String createCardNumbers()
	{
		Vector<Vector> numArray = new Vector<Vector>();
		String result = "";	
		Vector<Integer> tmpArr1;	
		int i,j,k,n =0,m, aindex1, aindex2=0;
		Integer rnumber =0;
		for(m=0;m<9;++m)
		{
			tmpArr1 = new Vector<Integer>();			
			if(m==0)
			{
				for ( k = 1; k <=  9; ++k) 
				{
					tmpArr1.add(k);
				}
			}
			if(m==8)
			{
				for ( k = 80; k <= 90; ++k) 
				{
					tmpArr1.add(k);
				}
			}
			if((m>0)&&(m<8))
			{
				for ( k = 10*m; k <= (10*m + 9); ++k) 
				{
					tmpArr1.add(k);
				}
			}
		//	trace ("Column "+m+ " numStrings... " + tmpArr1.toString());
			numArray.add(tmpArr1);
		}
		aindex1 = (int) Math.floor(Math.random()*threeD.length);
		
		
		for ( i = 0,m =0 ; i < 6 ; ++i, ++m) 
		{	
			for( j = 0,k = 0; j < 27 ; ++j,++k)
			{
				if(k >= 9)
					k = 0;		
				n = Arrays.binarySearch(threeD[aindex1][i], j);
				//trace("n: " + n + " k: " +k);
				if(n>=0)
					rnumber = 0;
				else
				{									
					aindex2 = (int) Math.floor(Math.random() * (numArray.get(k)).size());
					rnumber = (Integer) (numArray.get(k)).remove(aindex2);
				}
				
		
				if(j==0)
					result = result + rnumber;
				else
					result = result + "," + rnumber;
			}	
			
			if(i<5)
				result = result + ";";
		}
		return result;
		
	}

}
