#include<iostream>
#include <cv.h>
#include <highgui.h>
#include<cstdio>
#include<cmath>
#include<algorithm>
#include<limits.h>
#include<ctime>
#include<vector>

#include "imcircle.cc"
#include "getCircles.cc"
#include "rgb2bw.cc"
#include "roboCordi.cc"


using namespace std;

int main()
{
	CvCapture *capture=cvCaptureFromCAM(0);
	if(!cvGrabFrame(capture)){ // capture a frame
		printf("Could not grab a frame\n\7");
		exit(0); }
	//cout<<"cam ok...\n";
	
	IplImage *src=0;
	src=cvRetrieveFrame(capture);
	
	double tolcirc=0.2;
	
	int srcStep=src->widthStep,height=src->height,width=src->width,srcChannel=src->nChannels;
	
	unsigned char *srcData=(uchar*)(src->imageData);
	
	//cvNamedWindow( "bin img", 1 );
	cvNamedWindow("src",1);
	
	/*
	CvFont font;
	CvPoint pt;
	CvScalar colour;
	CvSize text_size;
	colour = CV_RGB(255, 0, 0);
	//cvPutText( image, "Hello", pt, &font, colour);
	cvInitFont( &font, CV_FONT_HERSHEY_SIMPLEX, 0.5, 0.5, 0, 8 );
	*/
	RoboCordinates myBot;
	
	Circle *tem;
	CvPoint c;
	NoCircleInfo imgCircles;
	Circle tem1;
	//while(cvWaitKey(4)!=27);
	int n;
	cin>>n;
	//clock_t start_tick( clock() );
	int i=0;
	/*
	while(cvWaitKey(4)!=27)
	{
		//start_tick=clock();
		if(!cvGrabFrame(capture)){ // capture a frame
		printf("Could not grab a frame\n\7");
		exit(0); }
		//*
		//cvGrabFrame(capture);
		src=cvRetrieveFrame(capture);
		
		//cvZero(I);
		//I=rgb2bw(src,1);		// 2nd arg is 1 becos blasc circles shud be identified....
		//cvShowImage("bin img" , I);
	
		//printf("got BW image \n");
	
		//myBot=getRoboCordi(I,0);		//	set 1 to detect black circles
	
		//plotting bot cordi.....
		//cvPutText( src, ".", myBot.roboFrontCordi, &font, colour);
		//cvPutText( src, ".", myBot.roboBackCordi, &font, colour);
	
	
		cvShowImage("src",src);
		
		//cvReleaseImage(&I);
		
		//sleep(100);
	//	while ( clock() - start_tick < 1*CLOCKS_PER_SEC );
		//i++;
		//cout<<i;
		//cout<<endl;
		
	}
	
	//while(cvWaitKey(4)!=27);
	//*/
	cvDestroyAllWindows();
	
	
	
	vector<int > a;
	a.push_back(123);
	a.push_back(1234);
	a.push_back(12345);
	a.push_back(123456);
	
	a.erase(a.begin()+2,a.begin()+3);
	
	return 0;
}




