#include<iostream>
#include<cstdio>//#include<conio.h>
/*#include<limits.h>
#include<dos.h>
#include<stdlib.h>
*/
//#include<cstdio>
const int n=10,m=11;
int start=-1,end=-1;
int aq[10000],par[2*n],seen[n],link[n][n],dist[m+1];
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
		link[i][j]=0;
}*/

void linking()
{

	/*for(int i=0;i<3;w++)
	{
		for(int j=0;j<3;w++)
		{
	*/
link[1-1][2-1]=1;
link[2-1][6-1]=1;
link[6-1][7-1]=1;
link[7-1][8-1]=1;
link[8-1][10-1]=1;
link[1-1][3-1]=1;
link[3-1][4-1]=1;
link[3-1][5-1]=1;
link[5-1][7-1]=1;
link[4-1][9-1]=1;
link[9-1][10-1]=1;
link[5-1][10-1]=1;
for(int i=0;i<n;i++)
{		for(int j=0;j<n;j++)
{			cout<<" "<<link[i][j];}
cout<<"\n";
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
		cout<<"exit as overflow";
		//exit(0);
	}
	}
}



void pop()
{
	/*if(end==-1)
	{
		cout<<"exit as underflow";
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
			if(link[aq[start]][w]==1)
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
	cout<<"\n"<<dist[dt]<<"\n";
	for(int w=0;w<2*n;w++)
	{
		cout<<" "<<par[w];
	}
	cout<<"\n";
}



int main()
{
	//init();
	linking();
	BFS(0,9);
	//getch();
	return 0;
}
