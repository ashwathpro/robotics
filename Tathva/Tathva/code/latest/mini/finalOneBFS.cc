#include<iostream>
#include<cstdio>
#include<stdlib.h>#include<cmath>
#include<queue>
#include<vector>
#include<stack>
using namespace std;const int m=8,n=8,roiM=7,roiN=7;	//remember roi is from reference 1,1 to dest pt
char ac;
int arenaMap[m][n],linkNode[(n)*(m)+1][(n)*(m)+1],arenaNode[m+1][n+1],bestPath[2*n];

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
			//cout<<"got "<<a<<"      "<<w<<" "<<z<<endl;
			//cin>>ac;
			X=w;		//  X is similar to i
			Y=z;		//  Y is similar to j	
			return;	
		}
	}		
}
}

void initNodes()
{
for(int w=0;w<n;w++){
	for(int z=0;z<n;z++)
	{	arenaNode[w][z]=w*n+z+1;
		cout<<arenaNode[w][z]<<"  ";
		arenaMap[w][z]=((w<roiN && w>0) && (z<roiN && z>0) )?0:1;
	}
cout<<endl;
}
}

void link1ing(int srcnode,int dest)
{
int noObst=0,temp;
if(X==11)
goto autoinit;

manual:

cout<<"Enter no of obstacles to be placed : ";
cin>>noObst;
initNodes();
cout<<endl<<"Enter nodes (start from 10): ";
for(int i=1;i<=noObst;i++)
{
	cin>>temp;
	initxy(temp);
	arenaMap[X][Y]=1;
}
goto finish;

autoinit:
initNodes();
arenaMap[1+1][1+1]=1;
arenaMap[1+1][3+1]=1;
arenaMap[2+1][0+1]=1;
arenaMap[2+1][4+1]=1;
arenaMap[3+1][3+1]=1;
arenaMap[3+1][4+1]=1;
arenaMap[3+1][5+1]=1;
arenaMap[4+1][0+1]=1;

arenaMap[4+1][2+1]=1;
arenaMap[5+1][4+1]=1;

finish:
int currnode=srcnode,popd[node];


for(int i=0;i<(n);i++)
{
	for(int j=0;j<(n);j++)
	{
		printf("%d ",arenaMap[i][j]);}
	printf("\n");

}	
printf("\n");

for(int i=0;i<=(node);i++)
{
	popd[i]=0;
	for(int j=0;j<=(node);j++)
	{
		linkNode[i][j]=(i==0?j:0);
		linkNode[i][j]=(j==0?i:0);
	}
}
queue<int> aque;
aque.push(currnode);
while(currnode!=dest && !aque.empty())
{
	
	currnode=aque.front();
	initxy(currnode);
	if(X+1<n && arenaMap[X+1][Y]!=1 && popd[arenaNode[X+1][Y]]!=1)
	{
		aque.push(arenaNode[X+1][Y]);
		linkNode[currnode][arenaNode[X+1][Y]]=1;
		//cout<<" into up \n";
	}
	
	if(Y-1>=0 && arenaMap[X][Y-1]!=1 && popd[arenaNode[X][Y-1]]!=1)
	{
		aque.push(arenaNode[X][Y-1]);
		linkNode[currnode][arenaNode[X][Y-1]]=1;
		//cout<<" into right \n";
	}
	
	if(X-1>=0 && arenaMap[X-1][Y]!=1 && popd[arenaNode[X-1][Y]]!=1)
	{
		aque.push(arenaNode[X-1][Y]);
		linkNode[currnode][arenaNode[X-1][Y]]=1;
		//cout<<" into down \n";
	}
	
	if(Y+1<n && arenaMap[X][Y+1]!=1 && popd[arenaNode[X][Y+1]]!=1)
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
//cout<<"  "<<currnode<<endl;
//arenaNode[currnode][dest]=1;
//cout<<"  "<<arenaNode[currnode][dest]<<endl;
/*
while(!aque.empty())
{
	aque.pop();
	cout<<" 1 ";
}
//arenaNode[currnode][dest]=1;	//
///*
printf("\n");
for(int i=0;i<=(n*n);i++)
{
	for(int j=0;j<=(n*n);j++)
	{
		printf("%d ",linkNode[i][j]);}
	printf("\n");
}
//*/
}

void BFS(int st,int dt)
{
	par[st]=-1;
	
	queue<int> que;
	que.push(st);
	seen[st]=1;
	while(!que.empty()&&seen[dt]!=1)
	{
		for(int w=1;w<node;w++)
		{
			if((linkNode[que.front()][w]==1)&&(seen[w]!=1))
			{
				que.push(w);
				if(par[w]==0)
				par[w]=que.front();
				seen[w]=1;
				dist[w]=dist[que.front()]+1;
			}
		}
		que.pop();
	}
	printf("\n legth :%d \n",dist[dt]);
	///*
	int w=dt,p=0;
	bestPath[p]=w;
	cout<<w<<" ";
	do
	{
		bestPath[p]=par[w];
		p++;
		cout<<par[w]<<" ";
		w=par[w];
		
	}while(par[w]!=-1);
	cout<<endl;
	//*/
	/*
	for(int i=0;i<=36;i++)
		printf("%d ",par[i]);
	printf("\n");
	//*/
}int main()
{
	int start=55,destin=10;
	//initNodes();
	X=11;		//comment this line for interactive obstac 
			//st=10 dt=55 for m=n=8 roiN=7
	link1ing(start,destin);
	BFS(start,destin);
	return 0;
}
