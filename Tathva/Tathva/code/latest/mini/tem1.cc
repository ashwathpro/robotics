#include<iostream>
#include<cstdio>
#include<cmath>
using namespace std;

const int m=8,n=8,roiM=7,roiN=7;
int myarena[m][n],arenaTemp[m][n],arenaMap[m][n],righti=1,rightj=0,forwardi=1,forwardj=1;
char ac;
void initNodes()
{
for(int w=0;w<n;w++){
	for(int z=0;z<n;z++){
		myarena[w][z]=((w<roiN && w>0) && (z<roiN && z>0) )?0:-1;
		arenaMap[w][z]=0;
		arenaTemp[w][z]=0;
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

/*int getRight(int i,int j,int dir)
{
	setRightDir(i,j,dir);
	return arenaTemp[righti][rightj];
}
*/
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

/*int getForward(int i,int j,int dir)
{
	setForwardDir(i,j,dir);
	return arenaTemp[forwardi][forwardj];
}
*/
int chDirR(int dir)
{
	//cout<<"\ntaking right turn...\n";
	return (dir!=12)?dir+3:3;
}

int chDirU(int dir)
{
	//cout<<"\ntaking U turn...\n";
	return (dir==12?6:dir==6?12:dir==3?9:dir==9?3:0);
}

void run(int i,int j,int dir)
{
	//cout<<"At node "<<i<<" "<<j<<" Direct :"<<dir<<endl;
	//cin>>ac;
	int currNode,direction=dir;
	currNode=myarena[i][j];		//comment and accept 
	setRightDir(i,j,dir);
	setForwardDir(i,j,dir);
	if(arenaTemp[1][2]>=2)
		return;
	if(currNode!=-1&&myarena[righti][rightj]!=-1)
	{
		arenaMap[i][j]=0;
		arenaTemp[i][j]++;
		setRightDir(i,j,direction);
		setForwardDir(i,j,direction);
		direction=chDirR(dir);
		run(righti,rightj,direction);
	}
	else if(currNode!=-1) 
	{
		arenaMap[i][j]=0;
		arenaMap[righti][rightj]=-1;
		arenaTemp[i][j]++;
		//cout<<"\nostac at right so goin forward...\n";
		run(forwardi,forwardj,direction);
	}
	else 
	{
		arenaMap[i][j]=-1;
		arenaTemp[i][j]=-1;
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
	cout<<arenaTemp[w][z]<<" ";
	}
	cout<<endl;
	}
	cout<<endl;
	cout<<endl;
	
	
	for(int w=0;w<n;w++){
	for(int z=0;z<n;z++){
	arenaMap[w][z]=(arenaMap[w][z]==-1?arenaMap[w][z]=1:0);
	cout<<" "<<arenaMap[w][z]<<" ";
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
int main()
{
	// go forward initially
	//so now at 1,1 and start algo
	initNodes();
	run(1,1,6);	//0,1 is init pos and 6 is down dir
	correctNodes();
	disp();		//also changes for BFS so dont forget to call it
}

