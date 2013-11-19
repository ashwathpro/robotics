//linking going on...

#include<iostream>
#include<cstdio>
#include<stdlib.h>#include<cmath>
#include<queue>
#include<vector>
#include<stack>
using namespace std;
const int m=6,n=6;
char ac;
int arena[m][n],linkNode[(n)*(m)+1][(n)*(m)+1],arenaNode[m+1][n+1];

const int node=n*m,edge=42*2;

int start=0,end=0,X=0,Y=0;
int aq[2*node],par[node],seen[node],link1[node][node],dist[edge+1];


void initxy(int a)
{
for(int w=0;w<n;w++)
{
	for(int z=0;z<n;z++)
	{
		if(arenaNode[w][z]==a)
		{
			cout<<"got "<<a<<"      "<<w<<" "<<z<<endl;
			//cin>>ac;
			X=w;		//  X is similar to i
			Y=z;	
			return;	//  Y is similar to j	
		}
	}		
}
}


void link1ing(int srcnode,int dest)
{
for(int w=0;w<n;w++){
	for(int z=0;z<n;z++)
	{	arenaNode[w][z]=w*n+z+1;cout<<arenaNode[w][z]<<"  ";}
cout<<endl;}

arena[1][1]=1;
arena[1][3]=1;
arena[2][0]=1;
arena[2][4]=1;
arena[3][3]=1;
arena[3][4]=1;
arena[3][5]=1;
arena[4][0]=1;

arena[5][2]=1;
arena[4][4]=1;


int currnode=srcnode,popd[node];//,up,down,left,right;


for(int i=0;i<(n);i++)
{
	for(int j=0;j<(n);j++)
	{
		printf("%d ",arena[i][j]);}
	printf("\n");

}	
printf("\n");

for(int i=0;i<=(node);i++)
{
	popd[i]=0;
	for(int j=0;j<=(node);j++)
	{
		if(i==0)
		{
			linkNode[i][j]=j;
			continue;
		}
		if(j==0)
		{
			linkNode[i][j]=i;
			continue;
		}
		linkNode[i][j]=0;
	}
}
queue<int> aque;
aque.push(currnode);
while(currnode!=dest && !aque.empty())
{
	
	currnode=aque.front();
	initxy(currnode);
	if(X+1<n && arena[X+1][Y]!=1 && popd[arenaNode[X+1][Y]]!=1)
	{
		aque.push(arenaNode[X+1][Y]);
		linkNode[currnode][arenaNode[X+1][Y]]=1;
		//cout<<" into up \n";
	}
	
	if(Y-1>=0 && arena[X][Y-1]!=1 && popd[arenaNode[X][Y-1]]!=1)
	{
		aque.push(arenaNode[X][Y-1]);
		linkNode[currnode][arenaNode[X][Y-1]]=1;
		//cout<<" into right \n";
	}
	
	if(X-1>=0 && arena[X-1][Y]!=1 && popd[arenaNode[X-1][Y]]!=1)
	{
		aque.push(arenaNode[X-1][Y]);
		linkNode[currnode][arenaNode[X-1][Y]]=1;
		//cout<<" into down \n";
	}
	
	if(Y+1<n && arena[X][Y+1]!=1 && popd[arenaNode[X][Y+1]]!=1)
	{
		aque.push(arenaNode[X][Y+1]);
		linkNode[currnode][arenaNode[X][Y+1]]=1;
		//cout<<" into left \n";
	}
	if(popd[aque.front()]!=1)
		popd[aque.front()]=1;
	if(aque.empty())
	{
		cout<<"breaking...";
		break;
	}
	aque.pop();	
}
//arenaNode[currnode][dest]=1;
//cout<<"  "<<arenaNode[currnode][dest]<<endl;
//delete &aque;
/*
while(!aque.empty())
{
	aque.pop();
	cout<<" 1 ";
}
cout<<"  "<<currnode<<endl;

//arenaNode[currnode][dest]=1;
	
		
/*
if(aque.empty())
	{
		cout<<"breaking...";
		break;
	}
for(int i=0;i<node;i++)
{		for(int j=0;j<node;j++)
{			printf("%d ",link1[i][j]);}
printf("\n");
}
*/	
printf("\n");
for(int i=0;i<=(n*n);i++)
{
	for(int j=0;j<=(n*n);j++)
	{
		printf(" %d ",linkNode[i][j]);}
	printf("\n");

}
//*/

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
	seen[st]=1;
	while(start!=-1&&seen[dt]!=1)
	{
		for(int w=1;w<node;w++)
		{
			if((linkNode[aq[start]][w]==1)&&(seen[w]!=1))
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
	///*
	int w=dt;
	do
	{
		printf("%d ",par[w]);
		w=par[w];
	}while(par[w]!=-1);
	//*/
	///*
	for(int i=0;i<=36;i++)
		printf("%d ",par[i]);
	printf("\n");
	//*/
}



int main()
{
	//link1ing(1,35);
	//BFS(1,35);
	int a;
	cin>>a;
	cout<<(a==12?12:a==23?23:1);
	//getch();
	return 0;
}
