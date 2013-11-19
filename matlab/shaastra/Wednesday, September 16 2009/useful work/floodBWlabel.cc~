#include<iostream>
#include <stdio.h>
#include <cv.h>
#include <highgui.h>
#include <ctime>
#include <vector>
#include <map>
#include <iostream>
#include <limits.h>

using namespace std;

struct bwLabelInfo
{
	int noLabels;
	IplImage* img;
};

bwLabelInfo BWLabel(IplImage* I )
{
	//*/
	
	if(I->nChannels != 1)
	{
		cout<<"--------input to findCircles should b a BINARY image and not RGB or other format...\n";
		exit(0);
	}
	
	//cout<<"cam ok...\n"<<I->width<<I->height;
	IplImage* labelled_img=cvCreateImage(cvSize(I->width,I->height),8,1);
	int step=I->widthStep,height=I->height,width=I->width;
	
	labelled_img=cvCloneImage(I);
	unsigned char *labData=(uchar*)(labelled_img->imageData);
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
				cvFloodFill(labelled_img,seed,color,cvScalar(15),cvScalar(15),&comp,8,NULL);
				flag=1;
				//break;
			}
		}
		//if(flag)	break;
	}
	
	cout<<"no of labels.... : "<<--labelCnt<<endl;
	
	bwLabelInfo c;
	c.noLabels=labelCnt;
	c.img=labelled_img;
	
	return c;
	
}

int main()
{
	
	CvCapture *capture=cvCaptureFromCAM(0);
	if(!cvGrabFrame(capture)){ // capture a frame
		printf("Could not grab a frame\n\7");
		exit(0); }
	cout<<"cam ok...\n";
	
	IplImage *src=cvRetrieveFrame(capture),*I = cvCreateImage(cvSize(src->width,src->height), 8, 1);
	
	int step=I->widthStep,height=src->height,width=src->width;
	unsigned char *iData=(uchar*)(I->imageData),*srcData=(uchar*)(src->imageData);
	cout<<"bw ok...\n";
	
	
	for(int i=0;i<height;i++)
	{
		for(int j=0;j<width;j++)
		{
			if(srcData[i*src->widthStep + j*3 +0]<=100 && srcData[i*src->widthStep + j*3 +1]<=50
				&& srcData[i*src->widthStep + j*3 +2]<=50)
				iData[i*step + j]=255;
			else	iData[i*step + j]=0;
		}
	}
	
	
	// close black noise...
	cvDilate(I,I,0,3);
	cvErode(I,I,0,3);	//change only last no to another no if wanted
	
	// close white noise...
	cvErode(I,I,0,3);	//change only last no to another no if wanted
	cvDilate(I,I,0,3);
	
	
	//cvSmooth(I, I, CV_GAUSSIAN, 5, 5 );
	
	cout<<"bw ok...\n";
	//cvNamedWindow("src",1);
	//cvShowImage("src",src);
	//while(cvWaitKey(0)!=27);
	
	//cvNamedWindow( "bin img", 1 );
	//cvShowImage( "bin img", I );
	
	bwLabelInfo c;
	
	c=BWLabel(I);
	//cout<<"no labels... "<<c.noLabels<<endl"
	IplImage* labelled_img=c.img;
	
	//cvNamedWindow( "bin img", 1 );
	//cvShowImage( "bin img", I );
	//cvSaveImage("labelledImage.jpg",labelled_img);
	//cvNamedWindow( "lab img", 1 );
	//cvShowImage( "lab img", labelled_img );
	
	while(cvWaitKey(0)!=27);
	
	//cvDestroyAllWindows();

	return 0;
}

