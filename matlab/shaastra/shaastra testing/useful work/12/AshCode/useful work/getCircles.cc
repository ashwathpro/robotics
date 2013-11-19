#include<iostream>
#include <stdio.h>
#include <cv.h>
#include <highgui.h>
//#include <ctime>
//#include <vector>
#include <limits.h>
#include<algorithm>

//#include "imcircle.cc"		// just b careful if editing da structure of dis prog.....
using namespace std;
class Circle 
{
	public:
	int diameter;
	CvPoint center;
	double area;
	Circle()
	{
		this->diameter=0;
		this->center = cvPoint(0,0);
		this->area=0;
	}
	Circle(int d,CvPoint p)
	{
		this->diameter=d;
		this->center = p;
		this->area=0;
	}
};

class NoCircleInfo
{
	public:
		Circle theCircles[20];
		int cntCircles;
	
	//~NoCircleInfo()
	//{	theCircles.clear();}
};

struct BwLabelInfo
{
	int noLabels;
	IplImage* img;
};

BwLabelInfo BWLabel(IplImage* I );

//NoCircleInfo findCircle(IplImage* input,double tolcirc,int lowerDia,int upperDia);

NoCircleInfo findCircle(IplImage* input,double tolcirc,int lowerDia=0,int upperDia=100)		//will return only circles in this range....
{
	/*
	SPECIFIC PURPOSE: To identify features in a binary image, to locate circles among the
        features, their centers and the distance between the first two.

	DESCRIPTION: Features are assumed to be made up of ones, against a background of zeros.
	
	tolSizeDia=Tolerance for rejecting small features (diameters). 
	
	*/
	
	
	if(input->nChannels != 1)
	{
		cout<<"--------input to findCircles should b a BINARY image and not RGB or other format...\n";
		exit(0);
	}
	
	int tolSizeDia=4,noLabels=0,cntCircle=0;
	
	NoCircleInfo allCirclesInfo;
	//Circle a(10,cvPoint(10,10)),b(10,cvPoint(10,12));
	//allCirclesInfo.push_back(a);
	//allCirclesInfo.push_back(b);
	
	
	IplImage *labelledImg;
	
	allCirclesInfo.theCircles[0]=(Circle(-1,cvPoint(-1,-1)));		//	let da 0 index contain a non accessible value...
	
	BwLabelInfo temp=BWLabel(input);
	
	noLabels=temp.noLabels;
	labelledImg=cvCloneImage(temp.img);
	
	unsigned char *labData=(uchar*)(labelledImg->imageData);
	int step=labelledImg->widthStep,height=labelledImg->height,width=labelledImg->width;
	
	//printf("findCirc :-- width : %d , height : %d \n",width,height);
	
	//vector<int> rows;
	//vector<int> columns;//I,J
	
	bool *allRows=(bool*)(malloc(height)),*allColumns=(bool*)(malloc(width));
	
	bool **testItem,**testCircle;
	
	int minI=INT_MAX,minJ=INT_MAX,maxI=INT_MIN,maxJ=INT_MIN,lenRow=0,lenCol=0,tempR,tempC,dia=0,misMatchCnt=0;
	
	unsigned int startRow=0,endRow=0,startCol=0,endCol=0;
	
	size_t sr,sc;
	
	for(int labelNo=1;labelNo<=noLabels;labelNo++)
	{
		//	put main code here.....
		minI=INT_MAX;minJ=INT_MAX;maxI=INT_MIN;maxJ=INT_MIN;
		dia=0;
		lenRow=0;lenCol=0;
		misMatchCnt=0;
		tempR=0;tempC=0;
		startRow=0;endRow=0;startCol=0;endCol=0;
		//I.clear();
		//if(!rows.empty())	rows.clear();
		//J.clear();
		//if(!columns.empty())	columns.clear();
		
		for(int i=0;i<height;i++)
		{
			for(int j=0;j<width;j++)
			{
				if(labData[i*step + j] == labelNo)
				{
					//I.push_back(i);
					//J.push_back(j);
					
					minI=min(minI,i);minJ=min(minJ,j);
					maxI=max(maxI,i);maxJ=max(maxJ,j);
				}
				
			}
		}
		
		tempR=round(min(height, minI + max( (maxI-minI) , (maxJ-minJ))));
		tempC=round(min(width, minJ + max( (maxI-minI) , (maxJ-minJ))));
		
		//printf("minI : %d ,minJ : %d ,maxI : %d ,maxJ : %d ,tempR : %d ,tempC : %d ,max : %d\n",minI,minJ,maxI,maxJ,tempR,tempC,max( (maxI-minI) , (maxJ-minJ)));
		/*
		for(int i=minI,j=minJ;(i<tempR || j<tempC);)
		{
			if(i<tempR)	rows.push_back(i);
			if(j<tempC)	columns.push_back(j);
			i++;j++;
		}
		*/
		sr=(tempR-minI)*sizeof(int);sc=(tempC-minJ)*sizeof(int);
		
		//rows.reserve(sr);
		
		startRow=minI;endRow=tempR;
		
		startCol=minJ;endCol=tempC;
		
		for(int i=startRow;i<endRow;i++)
			allRows[i]=true;
		
		
		//cout<<"passd rows...\n";
		//columns.reserve(sc);
		
		//cout<<"cols capacity...: "<<columns.capacity()<<endl;
		for(int j1=startCol;j1<endCol;j1++)
		{
			allColumns[j1]=true;
			//cout<<" "<<j1;
		}
		
		//cout<<"passd col...\n";
		/*
		if(!(rows.empty()))	lenRow=rows.size();
		else	lenRow=0;
		//cout<<"passd row empty...\n";
		if(!(columns.empty()))	lenCol=columns.size();
		else	lenCol=0;
		//cout<<"passd col empty...\n";
		//*/
		
		lenRow=endRow-startRow-1;lenCol=endCol-startCol-1;
		
		dia=max(lenRow,lenCol);
		if(dia <= tolSizeDia)	continue;
		//cout<<"passd dia...\n";
		
		if(!(lowerDia<=dia && upperDia>=dia ))
		{
			//printf("this Circle of dia %d is not in range %d to %d \n",dia,lowerDia,upperDia);
			continue;
		}
		
		//	one of conditions for circles.....
		if(!( ((lenRow/lenCol) >= 0.5) && ( (lenRow/lenCol) <= 2 )))	continue;
		//cout<<"passd ratio condtion...\n";
		
		testItem=bool2dArr(lenRow,lenCol);
		//cout<<"passd 2dArr...\n";
		
		//printf("rowlen : %d ,collen : %d ,dia : %d \n",lenRow,lenCol,dia);
		for(int i=0;i<lenRow;i++)
		{
			for(int j=0;j<lenCol;j++)
			{
				if(allRows[startRow + i] && allColumns[startCol + j] && labData[ (startRow + i) * step + (startCol + j) ] != 0)
					testItem[i][j]=true;
				else	testItem[i][j]=false;
				
				//if(testItem[i][j])	cout<<"1";
				//else	cout<<" ";
			}
			//cout<<endl;
		}
		
		//cout<<"passd testItem ...\n";
		testCircle=imcircle(dia);
		
		for(int i=0;i<lenRow;i++)
		{
			for(int j=0;j<lenCol;j++)
			{
				if(testCircle[i+1][j+1] ^ testItem[i][j] )	misMatchCnt++;
			}
		}
		//cout<<"passd comparing ...\n";
		
		
		//	Circle counter
		
		if((misMatchCnt < round(tolcirc*dia*dia)) )
		{
			int centreX,centreY;
			cntCircle++;
			centreY=round(startRow+dia/2);
			centreX=round(startCol+dia/2);
			//for(int i=rows[0];i<rows[0]+dia-1;i++)	
			CvPoint a=cvPoint(centreX,centreY);
			//cout<<"no of circles now is... : "<<cntCircle<<endl;
			//printf("Circle : %d , centreX : %d , centreY : %d , diameter : %d \n",cntCircle,centreX,centreY,dia);
		
			allCirclesInfo.theCircles[cntCircle]=(Circle(dia,a));
			
		}
		
		//cout<<"passd filters ...\n";
		
		for(int i=0,j=0;(i<height || j<width);i++,j++)
		{
			if(i<height)	allRows[i]=false;
			if(j<width)	allColumns[j]=false;
			
		}
		//cout<<"passd clear ...\n";
		
		//rows.clear();
		//columns.clear();
	
		
		//if(labelNo==2)	break;
		
	}
	
	//exit(0);
	//cvReleaseImage(&labelledImg);
	
	//allCirclesInfo.push_back(Circle(10,cvPoint(10,10)));
	printf("final no of circles is... : ",cntCircle);
	allCirclesInfo.cntCircles=cntCircle;
	
	//cout<<"going out findCircles......."<<endl;
	
	return allCirclesInfo;
}









BwLabelInfo BWLabel(IplImage* I )
{
	//*/
	
	if(I->nChannels != 1)
	{
		cout<<"--------input to findCircles should b a BINARY image and not RGB or other format...\n";
		exit(0);
	}
	
	//cout<<"cam ok...\n"<<I->width<<I->height;
	IplImage* labelledImg=cvCreateImage(cvSize(I->width,I->height),8,1);
	int step=I->widthStep,height=I->height,width=I->width;
	
	labelledImg=cvCloneImage(I);
	unsigned char *labData=(uchar*)(labelledImg->imageData);
	CvScalar color=cvScalar(140);
	CvConnectedComp comp;
	CvPoint seed=cvPoint(60,60);
	int flag=0,labelCnt=1;;
	
	for(int i=0;i<height;i++)
	{
		for(int j=0;j<width;j++)
		{
			if(labData[i*step + j]==255)
			{
				//printf("i %d ,j %d \n",i,j);
				seed=cvPoint(j,i);
				//color=cvScalar((10*labelCnt++)%255);
				color=cvScalar((labelCnt++));
				cvFloodFill(labelledImg,seed,color,cvScalar(15),cvScalar(15),&comp,8,NULL);
				flag=1;
				//break;
			}
		}
		//if(flag)	break;
	}
	
	cout<<"no of labels.... : "<<(--labelCnt)<<endl;
	
	BwLabelInfo c;
	c.noLabels=labelCnt;
	c.img=labelledImg;
	//cvReleaseImage(&labelledImg);
	
	
	return c;
	
}

/*

int main(){
	//*
	CvCapture *capture=cvCaptureFromCAM(0);
	if(!cvGrabFrame(capture)){ // capture a frame
		printf("Could not grab a frame\n\7");
		exit(0); }
	//cout<<"cam ok...\n";
	
	IplImage *src=cvRetrieveFrame(capture),*I = cvCreateImage(cvSize(src->width,src->height), 8, 1);
	double tolcirc=0.2;
	
	int step=I->widthStep,height=src->height,width=src->width,channel=src->nChannels;
	unsigned char *iData=(uchar*)(I->imageData),*srcData=(uchar*)(src->imageData);
	cvNamedWindow( "bin img", 1 );
	//cvNamedWindow("src",1);
	Circle *tem;
	CvPoint c;
	NoCircleInfo imgCircles;
	Circle tem1;
		
	//cout<<"bw ok...\n";
	
	//printf("main :--width : %d , height : %d \n",width,height);
	while(1)
	{
		//capture=cvCaptureFromCAM(0);
		if(!cvGrabFrame(capture)){ // capture a frame
		printf("Could not grab a frame\n\7");
		exit(0); }
		src=cvRetrieveFrame(capture);
		cvZero(I);
		for(int i=0;i<height;i++)
		{
			for(int j=0;j<width;j++)
			{
				if(srcData[i*src->widthStep + j*channel +0]<=100 && srcData[i*src->widthStep + j*3 +1]<=90
					&& srcData[i*src->widthStep + j*3 +2]<=90)
					iData[i*step + j]=255;		//******* SET WITHER ITS WHITE CIRCLE TO B DETECTD OR BLACK ONES (SET 255 FOR BLACK)
				else	iData[i*step + j]=0;		//******* SET WITHER ITS WHITE CIRCLE TO B DETECTD OR BLACK ONES (SET 0 FOR BLACK)
			}
		}
	
	
		// close black noise...
		cvDilate(I,I,0,3);
		cvErode(I,I,0,3);	//change only last no to another no if wanted
	
		// close white noise...
		cvErode(I,I,0,3);	//change only last no to another no if wanted
		cvDilate(I,I,0,3);
	
	
		//cvSmooth(I, I, CV_GAUSSIAN, 5, 5 );
	
		//cout<<"bw ok...\n";
		//cvShowImage("src",src);
		//while(cvWaitKey(0)!=27);
	
		//cvNamedWindow( "bin img", 1 );
		//cvShowImage( "bin img", I );
	
		//BwLabelInfo c;
	
		//c=BWLabel(I);
	
	
		//cout<<"no labels... "<<c.noLabels<<endl;
		//IplImage* labelledImg=cvCloneImage(c.img);
	
		imgCircles=findCircle(I,tolcirc ,0,70);
	
		//cout<<"findCircles sucess........\n";
	
		cvShowImage( "bin img", I );
		//cvSaveImage("labelledImage.jpg",labelledImg);
	
		//cvNamedWindow( "lab img", 1 );
		//cvShowImage( "lab img", labelledImg );
	
		//bool **circleItem=imcircle(30);
	
		//cout<<"imcircle sucess........\n";
		tem=imgCircles.theCircles;
		//cout<<"displaying circles info...\n";
		//*
		for(int i=1;i<=imgCircles.cntCircles;i++)
		{
			tem1=tem[i];
			c=tem1.center;
			printf("Circle : %d , centreX : %d , centreY : %d , diameter : %d \n",i+1,c.x,c.y,tem1.diameter);
		}
	
		///
	
		//	this part is wid da finding robot cordi....
	
	
		tem=NULL;
	
	
		//cvWaitKey(0);
		//cvWaitKey(0);
		//cvWaitKey(0);
		//while(cvWaitKey(0)!=27);
		//char z;
		//cin>>z;
	
		//cvDestroyAllWindows();
		//cvReleaseImage(&src);
		//cvReleaseImage(&labelledImg);
		//if(cvWaitKey(0)==27)	break;
		break;
	}
	while(cvWaitKey(0)!=27);
	
	//cvReleaseImage(&labelledImg);
	//cvReleaseImage(&I);
	//cvDestroyAllWindows();
	
	
	return 0;
	//
	vector<Circle> circles;
	Circle c;
	c.diameter=10;c.center=cvPoint(90,90);
	circles.push_back(c);
	
	Circle a(10,cvPoint(12,12));
	//CvPoint temp = centers[0];
	///
	
	
	
	
	//return 0;
	
}
*/
