#include<iostream>
#include<cstdio>
#include<stdlib.h>#include<cmath>//#include<conio>
const int m=6,n=6;
int arena[m][n],linkNode[(n)*(m)][(n)*(m)];

const int node=n*m,edge=42*2;

int start=-1,end=-1;
int aq[2*node],par[edge],seen[node],link1[node][node],dist[edge+1];


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
/*link1[1-1][2-1]=1;
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
link1[5-1][10-1]=1;*/

arena[1][1]=1;
arena[1][3]=1;
arena[2][0]=1;
arena[2][4]=1;
arena[3][3]=1;
arena[3][4]=1;
arena[3][5]=1;
arena[4][0]=1;
arena[4][2]=1;
arena[5][4]=1;

for(int i=0;i<n;i++)
{
	for(int j=0;j<n;j++)
	{
		if(arena[i][j])
			continue;
		if((i+1<n)&&(arena[i+1][j]==0))
			linkNode[i*n+j+1][(i+1)*n+j+1]=1;
		if((j+1<n)&&(arena[i][j+1]==0))
			linkNode[i*n+j+1][i*n+(j+1)+1]=1;
		
	}
}

		
		
		
		
		
/*
for(int i=0;i<node;i++)
{		for(int j=0;j<node;j++)
{			printf("%d ",link1[i][j]);}
printf("\n");
}
*/	

for(int i=0;i<(n);i++)
{
	for(int j=0;j<(n);j++)
	{
		printf("%d ",arena[i][j]);}
	printf("\n");

}	
printf("\n");
printf("\n");
for(int i=0;i<(n*n);i++)
{
	for(int j=0;j<(n*n);j++)
	{
		printf("%d ",linkNode[i][j]);}
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
	if(end<2*node)
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
		for(int w=1;w<node;w++)
		{
			if(linkNode[aq[start]][w]==1)
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
	printf("\n legth :%d \n",dist[dt]);
	int w=dt;
	while(par[w]!=-1)
	{
		printf("%d ",par[w]);
		w=par[w];
	}
	printf("\n");
}



int main()
{
	printf("%d %d \n",m,n);
	link1ing();
	//BFS(0,36);
	//getch();
	return 0;
}
