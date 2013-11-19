function timeOutSubRoutine(typeOfError)

global dio1;
global size_input_colored_image
global g_stopAll
%
global g_moveBack
%flap motor
global g_openFlap
global g_minFlap
%speed setting of robot
global g_maxSpeed
global g_minResponce
global g_minMov


centerOfArena = [size_input_colored_image(2) size_input_colored_image(1)];

switch(typeOfError)
    case 1
        fprintf('\n$$$$ Intimer Sub routine $$$$\n')
        %open mouth
         for j=1:g_minFlap
            putvalue(dio1.Line(1:4),g_openFlap);
         end
         putvalue(dio1.Line(1:4),g_stopAll);
         
         %move back
         for i=1:g_minResponce
            putvalue(dio1.Line(1:4),g_maxSpeed),
         end
        
        for i=1:3*g_minMov
            putvalue(dio1.Line(1:4),g_moveBack);
        end
        putvalue(dio1.Line(1:4),g_stopAll);

end
