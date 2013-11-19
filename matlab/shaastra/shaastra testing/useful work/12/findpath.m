
% Initiating values for PSO

pop_size = 10;

max = size(ss,1) * size(ss,1);

node_max = 50;

LB = repmat(1,1, distance_max);
UB = repmat(max,1, distance_max); 

bounds = repmat([1 max],node_max,1);

functname   = 'distance'; %name of the function
D           = node_max;  % No of Independent varibles
gen         = 2000;
mv          = repmat(max / 2,1,node_max);  %Maximum Velocity
VarRange    = bounds; % lower and upper bounds
minmax      = 0; % 0- minimize, 1- maximize

plotfcn     = 'goplotpso';

PSOseedValue=repmat(1,1, distance_max);
for n=1:pop_size
    PSOseedValue = [PSOseedValue; round(random('unif',LB, UB))];
end
PSOseedValue = [PSOseedValue; repmat(max,1, distance_max)];


PSOparams   = [0 gen pop_size+2 2 2 0.9 0.4 1500 0 250 NaN 0 1];

[out]=pso(functname,D,mv,VarRange,minmax,PSOparams,plotfcn,PSOseedValue);