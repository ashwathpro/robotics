//incomplete....

#include<iostream>
#include<cstdio>
#include<stdlib.h>#include<cmath>
#include<queue>
#include<vector>
#include<stack>
using namespace std;const int m=8,n=8,roiM=7,roiN=7;	//remember roi is from reference 1,1 to dest pt
char ac;
int arena[m][n],linkNode[(n)*(m)+1][(n)*(m)+1],arenaNode[m+1][n+1],bestPath[2*n];

const int node=n*m,edge=42*2;

int start=0,end=0,X=0,Y=0;
int aq[2*node],par[node],seen[node],link1[node][node],dist[edge+1];





//const int m=8,n=8,roiM=7,roiN=7;
int myarena[m][n],arena[m][n],arenaMap[m][n],righti=1,rightj=0,forwardi=1,forwardj=1;
char ac;
void initNodes()
{
for(int w=0;w<n;w++){
	for(int z=0;z<n;z++){
		myarena[w][z]=((w<roiN && w>0) && (z<roiN && z>0) )?0:-1;
		arenaMap[w][z]=0;
		arena[w][z]=0;
	}
}

myarena[2][2]=-1;
myarena[1][4]=-1;
myarena[2][5]=-1;
myarena[3][1]=-1;
myarena[3][4]=-1;
myarena[4][3]=-1;
myarena[4][6]=-1;
myarena[5][2]=-1;
myarena[6][5]=-1;

}

void setRightDir(int i,int j,int dir)
{
	switch(dir)
	{
		case 3:
		{
			righti=i+1;
			rightj=j;
			break;
		}
		case 6:
		{
			righti=i;
			rightj=j-1;
			break;
		}
		case 9:
		{
			righti=i-1;
			rightj=j;
			break;
		}
		case 12:
		{
			righti=i;
			rightj=j+1;
			break;
		}
		
	}

}

int getRight(int i,int j,int dir)
{
	setRightDir(i,j,dir);
	return arena[righti][rightj];
}

void setForwardDir(int i,int j,int dir)
{
	switch(dir)
	{
		case 3:
		{
			forwardi=i;
			forwardj=j+1;
			break;
		}
		case 6:
		{
			forwardi=i+1;
			forwardj=j;
			break;
		}
		case 9:
		{
			forwardi=i;
			forwardj=j-1;break;
		}
		case 12:
		{
			forwardi=i-1;
			forwardj=j;break;
		}
							
	}

}

int getForward(int i,int j,int dir)
{
	setForwardDir(i,j,dir);
	return arena[forwardi][forwardj];
}

int chDirR(int dir)
{
	cout<<"\ntaking right turn...\n";
	return (dir!=12)?dir+3:3;
}

int chDirU(int dir)
{
	cout<<"\ntaking U turn...\n";
	return (dir==12?6:dir==6?12:dir==3?9:dir==9?3:0);
}

void run(int i,int j,int dir)
{
	cout<<"At node "<<i<<" "<<j<<" Direct :"<<dir<<endl;
	//cin>>ac;
	int currNode=myarena[i][j],direction=dir;
	setRightDir(i,j,dir);
	setForwardDir(i,j,dir);
	if(arena[1][2]>=2)
		return;
	if(currNode!=-1&&myarena[righti][rightj]!=-1)
	{
		arenaMap[i][j]=0;
		arena[i][j]++;
		setRightDir(i,j,direction);
		setForwardDir(i,j,direction);
		direction=chDirR(dir);
		//cout<<"\ntakin right...\n";
		run(righti,rightj,direction);
	}
	else if(currNode!=-1) 
	{
		arenaMap[i][j]=0;
		arenaMap[righti][rightj]=-1;
		arena[i][j]++;
		cout<<"\nostac at right so goin forward...\n";
		run(forwardi,forwardj,direction);
	}
	else 
	{
		arenaMap[i][j]=-1;
		arena[i][j]=-1;
		direction=chDirU(dir);
		setRightDir(i,j,direction);
		setForwardDir(i,j,direction);
		run(forwardi,forwardj,direction);
	}
	
}

void disp()
{
	for(int w=0;w<n;w++){
	for(int z=0;z<n;z++){
	cout<<arena[w][z]<<" ";
	}
	cout<<endl;
	}
	cout<<endl;
	cout<<endl;
	
	
	for(int w=0;w<n;w++){
	for(int z=0;z<n;z++){
	arenaMap[w][z]=(arenaMap[w][z]==-1?arenaMap[w][z]=1:0);
	
	}
	cout<<endl;
	}

}

void correctNodes()
{
	arenaMap[0][0]=-1;
	arenaMap[0][m-1]=-1;
	arenaMap[m-1][0]=-1;
	arenaMap[m-1][m-1]=-1;
	

}
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

void initNodesBFS()
{
for(int w=0;w<n;w++){
	for(int z=0;z<n;z++)
	{	arenaNode[w][z]=w*n+z+1;
		cout<<arenaNode[w][z]<<"  ";
		arena[w][z]=((w<roiN && w>0) && (z<roiN && z>0) )?0:1;
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
initNodesBFS();
cout<<endl<<"Enter nodes (start from 10): ";
for(int i=1;i<=noObst;i++)
{
	cin>>temp;
	initxy(temp);
	arena[X][Y]=1;
}
goto finish;

autoinit:
initNodesBFS();
arena[1+1][1+1]=1;
arena[1+1][3+1]=1;
arena[2+1][0+1]=1;
arena[2+1][4+1]=1;
arena[3+1][3+1]=1;
arena[3+1][4+1]=1;
arena[3+1][5+1]=1;
arena[4+1][0+1]=1;

arena[4+1][2+1]=1;
arena[5+1][4+1]=1;

finish:
int currnode=srcnode,popd[node];


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
	// go forward initially
	//so now at 1,1 and start algo
	int rig,forw;
	//rig=getRight(1,1,6);
	initNodes();
	run(1,1,6);	//0,1 is init pos and 6 is down dir
	correctNodes();
	disp();		//also changes for BFS
	int start=55,destin=10;
	//initNodesBFS();
	X=11;		//comment this line for interactive obstac 
			//st=10 dt=55 m=n=8 roiN=7
	link1ing(start,destin);
	BFS(start,destin);
	return 0;
}
