//#include "getCircles.cc"
//#include "rgb2bw.cc"

struct RoboCordinates
{
	CvPoint roboFrontCordi,roboBackCordi;
};

RoboCordinates getRoboCordi(IplImage *input , int status);


RoboCordinates getRoboCordi(IplImage *input , int status)
{
	if(input->nChannels != 1)
	{
		cout<<"--------input to getRoboCordi should b a BINARY image and not RGB or other format...\n";
		exit(0);
	}
	
	int roboCircleDist=80;
	
	int foundCordi=0;
	float dist=0;
	
	Circle *tem;
	CvPoint c;
	NoCircleInfo imgCircles;
	Circle tem1;
	
	
	RoboCordinates ret;
	
	float tolcirc=0.2;
	
	imgCircles=findCircle(input,tolcirc ,10,80);
	
	tem=imgCircles.theCircles;
	printf("dist : %f \t cnt : %d \n",dist,imgCircles.cntCircles);
	
	if(imgCircles.cntCircles == 2)
	{
		dist=sqrt( pow(tem[1].center.x - tem[2].center.x , 2) + pow(tem[1].center.y - tem[2].center.y , 2) );
		if(dist>0 && dist <= roboCircleDist)
		{
			foundCordi=1;
			printf("found da bot...\n");
			ret.roboFrontCordi = (tem[1].diameter < tem[2].diameter)?tem[1].center:tem[2].center;
			ret.roboBackCordi = (tem[1].diameter > tem[2].diameter)?tem[1].center:tem[2].center;
		}
		return ret;
	}
	
	for(int i=1;(i<=imgCircles.cntCircles && foundCordi!=1);i++)
	{
		for(int j=i;(j<=imgCircles.cntCircles && foundCordi!=1);j++)
		{
			dist=sqrt( pow(tem[i].center.x - tem[j].center.x , 2) + pow(tem[i].center.y - tem[j].center.y , 2) );
			
			//printf("dist : %f \n",dist);
			if(dist>0 && dist<=roboCircleDist)
			{
				foundCordi=1;
				ret.roboFrontCordi = (tem[i].diameter < tem[j].diameter)?tem[i].center:tem[j].center;
				ret.roboBackCordi = (tem[i].diameter > tem[j].diameter)?tem[i].center:tem[j].center;
				printf("found da bot... \n");
				return ret;
			}
		}
	}
	
	
	
	
	return ret;
}


/*
int main (int argc, char const* argv[])
{
	
	CvCapture *capture=cvCaptureFromCAM(0);
	if(!cvGrabFrame(capture)){ // capture a frame
		printf("Could not grab a frame\n\7");
		exit(0); }
	//cout<<"cam ok...\n";
	//cout<<minRed<<endl;
	
	CvFont font;
	CvPoint pt;
	CvScalar colour;
	CvSize text_size;
	colour = CV_RGB(255, 0, 0);
	//cvPutText( image, "Hello", pt, &font, colour);
	cvInitFont( &font, CV_FONT_HERSHEY_SIMPLEX, 0.5, 0.5, 0, 8 );
	
	
	
	IplImage *src=cvRetrieveFrame(capture),*I = cvCreateImage(cvSize(src->width,src->height), 8, 1);
	double tolcirc=0.2;
	
	int step=I->widthStep,height=src->height,width=src->width,channel=src->nChannels;
	unsigned char *iData=(uchar*)(I->imageData),*srcData=(uchar*)(src->imageData);
	//cvNamedWindow( "bin img", 1 );
	//cvNamedWindow("src",1);
	Circle *tem;
	CvPoint c;
	NoCircleInfo imgCircles;
	Circle tem1;
		
	//cout<<"bw ok...\n";
	
	//printf("main :--width : %d , height : %d \n",width,height);
	//while(1)
	//{
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
			if(srcData[i*src->widthStep + j*channel +0]<=maxBlue && srcData[i*src->widthStep + j*3 +1]<=maxGreen
				&& srcData[i*src->widthStep + j*3 +2]<=maxRed)
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

	//cvShowImage( "bin img", I );
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
		cvPutText( src, "X", c, &font, colour);
		printf("Circle : %d , centreX : %d , centreY : %d , diameter : %d \n",i+1,c.x,c.y,tem1.diameter);
	}

	///
	//cvShowImage("src", src);
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
	//break;
	//}
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
	
	
	
	
	
	
	return 0;
}


*/

