#include<iostream>
#include<cstdio>
#include<stdlib.h>
const int n=10,m=11;
int start=-1,end=-1;
int aq[10000],par[2*n],seen[n],link1[n][n],dist[m+1];



/*void init()
{
for(int w=0;w<10000;w++)
	{
		if(w<n)
			seen[w]=0;
		par[w]=0;
		aq[w]=0;
	}
for(int i=0;i<n;i++)
	for(int j=0;j<n;j++)
		link11[i][j]=0;
}*/


void link1ing()
{
link1[1-1][2-1]=1;
link1[2-1][6-1]=1;
link1[6-1][7-1]=1;
link1[7-1][8-1]=1;
link1[8-1][10-1]=1;
link1[1-1][3-1]=1;
link1[3-1][4-1]=1;
link1[3-1][5-1]=1;
link1[5-1][7-1]=1;
link1[4-1][9-1]=1;
link1[9-1][10-1]=1;
link1[5-1][10-1]=1;


for(int i=0;i<n;i++)
{		for(int j=0;j<n;j++)
{			printf("%d ",link1[i][j]);}
printf("\n");
}
		
	
}


	
void push(int val)
{
	if(start==-1&&end==-1)
	{
		aq[0]=val;
		start++;
		end++;
	}
	else
	{
	if(end<10000)
	{
		end=end+1;
		aq[end]=val;
	}
	else {
		printf("exit as overflow");
		
	}
	}
}



void pop()
{
	/*if(end==-1)
	{
		printf(""exit as underflow";
		exit(0);
	}*/
	if(end==start)
	{
		start=-1;
		end=-1;
	}
	else
	
		start=start+1;
	
}

void BFS(int st,int dt)
{
	par[st]=-1;
	push(st);
//	seen[st]=1;
	while(end!=-1&&seen[dt]!=1)
	{
		for(int w=0;w<n;w++)
		{
			if(link1[aq[start]][w]==1)
			{
				push(w);
				if(par[w]==0)
				par[w]=aq[start];
				seen[w]=1;
				dist[w]=dist[aq[start]]+1;
			}
		}
		  //
		pop();
	}
	printf("\n %d ",dist[dt]);
	for(int w=0;w<2*n;w++)
	{
		printf("%d ",par[w]);
	}
	printf("\n");
}



int main()
{
	int a=5;
	
	//init();
	link1ing();
	BFS(0,9);
	//getch();
	
	return 0;
}
