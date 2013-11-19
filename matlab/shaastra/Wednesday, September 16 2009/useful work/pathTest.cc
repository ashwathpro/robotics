#include<iostream>
#include <cv.h>
#include <highgui.h>
#include<cstdio>
#include<cmath>
#include<algorithm>
#include<limits.h>
#include<ctime>


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
	
	IplImage *src=cvLoadImage("iitmArena.jpeg"),*I = cvCreateImage(cvSize(src->width,src->height), 8, 1);
	//cvZero(I);
	IplImage *target=cvLoadImage("targets.jpeg");
	int srcStep=src->widthStep,height=src->height,width=src->width,srcChannel=src->nChannels;
	int tarStep=target->widthStep,tarHeight=target->height,tarWidth=target->width,tarChannel=target->nChannels;
	
	unsigned char *srcData=(uchar*)(src->imageData),*tarData=(uchar*)(target->imageData);
	
	CvFont font;
	CvPoint pt;
	CvScalar colour;
	CvSize text_size;
	colour = CV_RGB(255, 0, 0);
	//cvPutText( image, "Hello", pt, &font, colour);
	cvInitFont( &font, CV_FONT_HERSHEY_SIMPLEX, 0.5, 0.5, 0, 8 );
	
	RoboCordinates myBot;
	
	Circle *tem;
	CvPoint c;
	NoCircleInfo imgCircles;
	Circle tem1;
	
	clock_t start_tick( clock() );
	
	//
	//while(1)	
	//{
		//start_tick=clock();
		if(!cvGrabFrame(capture)){ // capture a frame
		printf("Could not grab a frame\n\7");
		exit(0); }
		
		src=cvRetrieveFrame(capture);
		
		//cvZero(I);
		I=rgb2bw(src,1);		// 2nd arg is 1 becos blasc circles shud be identified....
		//cvShowImage("bin img" , I);
	
		//printf("got BW image \n");
	
		myBot=getRoboCordi(I,0);		//	set 1 to detect black circles
	
		//plotting bot cordi.....
		//cvPutText( src, ".", myBot.roboFrontCordi, &font, colour);
		//cvPutText( src, ".", myBot.roboBackCordi, &font, colour);
	
	
		cvShowImage("src",src);
		
		//cvReleaseImage(&I);
		
		//sleep(100);
	//	while ( clock() - start_tick < 1*CLOCKS_PER_SEC );
		
	//}
	
	while(cvWaitKey(4)!=27);
	
	//cvDestroyAllWindows();

	//*/
	
	
	
	
	
	
	return 0;
}
