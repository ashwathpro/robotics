
1.	Type first these commands

global vid
vid = videoinput('winvideo',1,'RGB24_640x480');
preview(vid);

1)snap
1)testing GoalPost
1)select our color
2)testing robot




Tip: If u r not getting preview or it shows some error then
      close MATLAB and plug out camera and plug it again again then again open the MATLAB. 
2.	Take the snap of arena then call the functions
(a)	tesing_red
(b)	tesing_bonus
(c)	tesing_blue
(d)	tesing_orange
(e)	tesing_yellow
(f)	    tesing_green
Check all global values of colors and their max min values
3.	Call  main and it will do…..
(a)	give the figure of all possible color corner path 
(b)	make a table on screen showing no of squares and bonus squares and bonus points
(c)	Also make sure that its shows the max point path is same as actual.
(i)	 If this satisfied, Put robot on arena, then call
 testing_robot   and take snaps at almost all corners and center and change these global variables inside this file.
•	ROBOT_FRONT_DIA
•	ROBOT_BACK_DIA
•	FRONT_DIA_TOL
•	BACK_DIA_TOL
•	Tolcirc
•	Color_min_white
(ii)	If the maximum point path is not coincides then open main.m make some changes for that and then apply the above step for testing_robot.m



Tips for Camera Mounting:
?	Camera almost center of arena
?	Camera sud capture full arena.. its better if u cover more than actual arena.
?	Check for reflection from arena

A=getsnapshot(vid);
figure,imshow(A);

global Corner_array_coordinate
[Corner_array_coordinate(:,1) Corner_array_coordinate(:,2)]=getpts
