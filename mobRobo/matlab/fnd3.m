function [j,i,v] = fnd3(F1,F2)

    [eyr,exr,vlr] = fnd(F1,F2,1);
    [eyg,exg,vlg] = fnd(F1,F2,2);
    [eyb,exb,vlb] = fnd(F1,F2,3);

    j = round(1/3*(eyr+eyg+eyb));
    i = round(1/3*(exr+exg+exb));
    v = round(1/3*(vlr+vlg+vlb));

end
