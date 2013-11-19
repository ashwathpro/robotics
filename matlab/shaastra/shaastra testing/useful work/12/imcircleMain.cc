#include<iostream>
#include<cstdio>
#include<cmath>
#include<algorithm>
#include<string>
#include<limits.h>
//#include<ctype>
using namespace std;

int** int2dArr(int m,int n)
{
	int **a=(int**)malloc(m*sizeof(int*));
	for(int i=0;i<=m;i++)
	{
		a[i]=(int*)malloc(n*sizeof(int));
	}
	return a;
}
bool** bool2dArr(int m,int n)
{
	bool **a=(bool**)malloc(m*sizeof(bool*));
	for(int i=0;i<=m;i++)
	{
		a[i]=(bool*)malloc(n*sizeof(bool));
	}
	return a;
}
/*
double round(double a)
{
 	   double x=a-(int)a;
 	   if(x >= 0.5)	return (1+(int)a);
 	   else	return ((int)a);
}

*/

bool** imcircle(int n)
{
	/*
	
	da funct draws a circle of radius=n/2 or dia=n
	inside a square of side n
		
	*/
	
	if(n < 4)	// rest r trivial cases....
	{ 
 		cout<<"n must be atleast 4\n";
 		exit(0);
  	} 
		
	else if(n%2 == 0)
	{
		double DIA=n,RAD=DIA/2,dia=n-1,rad=dia/2;
		double height_45=round(rad/sqrt(2)),opp=0,sin=0,cos=0;
		int *width=(int*)malloc((int)(RAD)*sizeof(int)),*arr=(int*)malloc((int)(height_45)*sizeof(int));
		int *widthLr1=(int*)malloc(n*sizeof(int));
		
		bool **semicircle=bool2dArr(DIA,RAD),**semicircleLr1=bool2dArr(DIA,DIA);
		//cout<<"declare...\nhieght_45 "<<height_45<<endl;
		int maxArr=0,minArr=1,maxJInd=0,minWidth;
		for(int i=1;i<=height_45;i++)
		{
			opp=i-0.5;
			sin=opp/rad;
			cos=sqrt(1-sin*sin);
			width[i]=ceil(rad*cos);
		//	array = width(1:height_45)-height_45
			arr[i]=width[i]-height_45;
			
			if(maxArr < arr[i])	maxArr=arr[i];
			//if(minArr > arr[i])	minArr=arr[i];
			
		}
		minArr=arr[1];
		for(int i=1;i<=height_45;i++)
		{
			if(minArr > arr[i])	minArr=arr[i];
		}
		
		//cout<<"max and min Arr "<<maxArr<<" and"<<minArr<<endl;
		
		for(int j=maxArr;j>=minArr;j--)
		{
			for(int i=height_45;i>=1;i--)
			{
				if(arr[i] == j && i >= maxJInd)
					maxJInd=i;
			}
			
			width[(int)height_45 + j]=maxJInd;
			
			maxJInd=1;
		}
		
		//if(min(width == 0)) then put tat as mean of its 2.. l & r neighbours...
		
		for(int i=RAD;i>=1;i--)
		{
			if(width[i]==0 && i>0 && i<RAD)
				width[i]=(int)(width[i+1]+width[i-1])/2;
			
			//if(width[i]==0 && (i==0 || i==RAD))	width[i]=1;
			if(width[i]==0 && (i==RAD))	width[i]=1;
		}
		/*/
		cout<<"width...\n";
		for(int i=1;i<=n/2;i++)
		{
			cout<<width[i]<<" ";
		}
		cout<<"width...\n";
		//*/
		
		// flipping width
		
		//for(int i=0;i<=n;i++)	widthLr1[i]=(i<=RAD)?width[i]:width[n-i];
		for(int i=1;i<=n/2;i++)
			widthLr1[n/2-i+1]=widthLr1[n/2+i]=width[i];
		
		/*/
		cout<<"widthLr1...\n";
		for(int i=1;i<=n;i++)
		{
			cout<<widthLr1[i]<<" ";
		}
		cout<<"widthLr1...\n";
		//*/
		
		
		//	drawing a semicircle and flipping simultaneously to complete da circle ...
		for(int i=1;i<=DIA;i++)
		{
			//cout<<"declare...in \n";
			for(int j=1;j<=RAD;j++)
			{
				if(j <= widthLr1[i])
					semicircle[i][j]=true;
				else	semicircle[i][j]=false;
				
				if(semicircle[i][j])
				{
					semicircleLr1[i][(int)RAD-j+1]=true;
					semicircleLr1[i][(int)RAD+j]=true;
				}
				else
				{
					semicircleLr1[i][(int)RAD-j+1]=false;
					semicircleLr1[i][(int)RAD+j]=false;
				}
				
			}
		}
		
		/*/completeing remaining half of circle
		for(int i=1;i<=DIA;i++)
		{
			//cout<<"declare...in \n";
			for(int j=1;j<=RAD;j++)
			{
				if(semicircle[i][j])
					semicircleLr1[i][(int)RAD+j]=true;
				else	semicircleLr1[i][(int)RAD+j]=false;
			}
		}
		//*/
		
		return semicircleLr1;
		
	}
	
	else
	{
		double DIA=n,RAD=DIA/2,dia=n-1,rad=dia/2;
		double height_45=round(rad/sqrt(2)-0.5),opp=0,sin=0,cos=0;
		int *width=(int*)malloc((int)(RAD)*sizeof(int)),*arr=(int*)malloc((int)(height_45)*sizeof(int));
		int *widthLr1=(int*)malloc(n*sizeof(int));
		
		bool **semicircle=bool2dArr(DIA,RAD),**semicircleLr1=bool2dArr(DIA,DIA);
		cout<<"declare...\nhieght_45 "<<height_45<<endl;
		int maxArr=0,minArr=1,maxJInd=0,maxWidth=0;
		
		
		for(int i=1;i<=height_45;i++)
		{
			opp = i;
			sin=opp/rad;
			cos=sqrt(1-sin*sin);
			width[i]=ceil(rad*cos-0.5);
		//	array = width(1:height_45)-height_45
			arr[i]=width[i]-height_45;
			
			if(maxArr < arr[i])	maxArr=arr[i];
			//if(minArr > arr[i])	minArr=arr[i];
			
		}
		
		minArr=arr[1];
		for(int i=1;i<=height_45;i++)
		{
			if(minArr > arr[i])	minArr=arr[i];
		}
		
		cout<<"max and min Arr "<<maxArr<<" and"<<minArr<<endl;
		
		for(int j=maxArr;j>=minArr;j--)
		{
			for(int i=height_45;i>=1;i--)
			{
				if(arr[i] == j && i >= maxJInd)
					maxJInd=i;
			}
			
			width[(int)height_45 + j]=maxJInd;
			
			maxJInd=1;
		}
		
		for(int i=RAD;i>=1;i--)
		{
			if(width[i] > maxWidth)	maxWidth=width[i];
			
			if(width[i]==0 && i>0 && i<RAD)
				width[i]=(int)(width[i+1]+width[i-1])/2;
			
			if(width[i]==0 && (i==RAD))	width[i]=1;
		}
		/*/
		cout<<"width...\n";
		for(int i=1;i<=n/2;i++)
		{
			cout<<width[i]<<" ";
		}
		cout<<"width...\n";
		//*/
		
		// flipping width
		//width = [fliplr(width) max(width) width];
		for(int i=1;i<=n/2;i++)
			widthLr1[n/2-i+1]=widthLr1[n/2+i+1]=width[i];
		
		widthLr1[n/2+1]=maxWidth;
		
		//flipping width over...
		
		/*/
		cout<<"widthLr1...\n";
		for(int i=1;i<=n;i++)
		{
			cout<<widthLr1[i]<<" ";
		}
		cout<<"widthLr1...\n";
		//*/
		
		//	drawing a semicircle and flipping simultaneously to complete da circle ...
		for(int i=1;i<=n;i++)
		{
			//cout<<"declare...in \n";
			for(int j=1;j<=n/2;j++)
			{
				if(j <= widthLr1[i])
					semicircle[i][j]=true;
				else	semicircle[i][j]=false;
				
				if(semicircle[i][j])
				{
					semicircleLr1[i][(int)(n/2)-j+1]=true;
					semicircleLr1[i][(int)(n/2)+j+1]=true;
				}
				else
				{
					semicircleLr1[i][(int)(n/2)-j+1]=false;
					semicircleLr1[i][(int)(n/2)+j+1]=false;
				}
				
			}
		}
		
		for(int i=1;i<=n;i++)
			semicircleLr1[i][(int)(n/2)+1]=true;
		//circle complete...
		
		return semicircleLr1;
		
		
	}
	
	
}


int main()
{
	int n=30,p=0;
	cout<<"enter da DIA of circle to b drawn... ";
	cin>>n;
	bool ***circle=(bool***)malloc(20*sizeof(bool**));
	
	circle[p]=imcircle(n);

	for(int i=1;i<=n;i++)
	{
		for(int j=1;j<=n;j++)
		{
			if(circle[p][i][j])
			cout<<"a";
			else cout<<" ";
		}
		cout<<endl;
	}
	

	return 0;
}
