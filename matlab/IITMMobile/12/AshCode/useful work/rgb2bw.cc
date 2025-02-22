#include<iostream>
#include <stdio.h>
#include <cv.h>
#include <highgui.h>
//#include <ctime>
//#include <vector>
#include <limits.h>
#include<algorithm>
using namespace std;

int minBlue=90,blueOverGreen=20,blueOverRed=20,maxGreen=100,maxRed=100;
	
int minGreen=90,greenOverBlue=20,greenOverRed=20,maxBlue=100;
//int minRed=90,redOverBlue=20,redOverRed=20,maxRed=80;
int minRed=90,redOverGreen=20,redOverBlue=20;
	

IplImage* rgb2bw(IplImage* input,int neg=0)

{
	if(input->nChannels == 1)
	{
		cout<<"--------input is already in BINARY format...\n";
		return input;
	}
	
	int step=input->widthStep,height=input->height,width=input->width,channel=input->nChannels;
	
	IplImage* output=cvCreateImage(cvSize(width,height),8,1);
	cvZero(output);
	unsigned char *iData=(uchar*)(input->imageData),*oData=(uchar*)(output->imageData);
	
	int col=(neg==0)?0:255;
	
	
	for(int i=0;i<height;i++)
	{
		for(int j=0;j<width;j++)
		{
			if(iData[i*step + j*channel +0]<=maxBlue && iData[i*step + j*3 +1]<=maxGreen
				&& iData[i*step + j*3 +2]<=maxRed)
				oData[i*output->widthStep + j]= col;	
			else	oData[i*output->widthStep + j]=255-col;		
		}
	}


	// close black noise...
	cvDilate(output,output,0,3);
	cvErode(output,output,0,3);	//change only last no to another no if wanted

	// close white noise...
	cvErode(output,output,0,3);	//change only last no to another no if wanted
	cvDilate(output,output,0,3);


	//cvSmooth(input, input, CV_GAUSSIAN, 5, 5 );

	//cout<<"bw ok...\n";
	//cvShowImage("input",input);
	//while(cvWaitKey(0)!=27);

	//cvNamedWindow( "bin img", 1 );
	//cvShowImage( "bin img", input );
	
	return output;
}

/*
int main (int argc, char const* argv[])
{
	CvCapture *capture=cvCaptureFromCAM(0);
	if(!cvGrabFrame(capture)){ // capture a frame
		printf("Could not grab a frame\n\7");
		exit(0); }
	IplImage *src=cvRetrieveFrame(capture),*I = cvCreateImage(cvSize(src->width,src->height), 8, 1);
	I=rgb2bw(src,1);
	//cvNamedWindow( "bin img", 1 );
	//cvShowImage("bin img",I);
	//cvNamedWindow( "src", 1 );
	//cvShowImage("src",src);
	while(cvWaitKey(0)!=27);
	
	return 0;
}

//*/
