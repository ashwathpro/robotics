function ret=recursionTest(a)
    if(a<0)
        error('factorial must b positive ....');
    end
    if(a==0) 
        ret=1;
    else ret=a*recursionTest(decrease(a));
    end

    function d=decrease(a)
        d=a-1;
        
    end

end
%%
% function d=decrease(a)
%     d=a-1;
%     a1=logical(5);
% end

