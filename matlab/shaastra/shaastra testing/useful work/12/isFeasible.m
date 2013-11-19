function feasible = isFeasible(X,lb,ub)
%isTrialFeasible Checks if X is feasible w.r.t. linear constraints. 
% 	%   Copyright 2003-2007 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2007/11/09 20:09:26 $

feasibleIneq = true;

% Upper bounds
argub = ~eq(ub,inf);
% X(argub)
% ub(argub)
% all(X(argub) <= ub(argub))
if any(argub) && ~isempty(argub)
    feasibleIneq = feasibleIneq && all(X(argub) <= ub(argub));
end
% Lower bounds
arglb = ~eq(lb,-inf);
if any(arglb) && ~isempty(arglb)
    feasibleIneq = feasibleIneq && all(X(arglb) >= lb(arglb));
end
feasible = feasibleIneq;
return