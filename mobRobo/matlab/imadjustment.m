function I = imadjustment(handles)

I = imadjust(handles.I,[handles.s2 handles.s3],[handles.s4 handles.s5]);
red = ((I(:,:,1)>handles.rl-1) & (I(:,:,1)<handles.rh+1))*1;
grn = ((I(:,:,2)>handles.gl-1) & (I(:,:,2)<handles.gh+1))*1;
blu=((I(:,:,1)>handles.bl-1) & (I(:,:,1)<handles.bh+1))*1;
I(:,:,1) = uint8(red).*I(:,:,1);
I(:,:,2) = uint8(grn).*I(:,:,2);
I(:,:,3) = uint8(blu).*I(:,:,3);
if handles.gray==1
    Ig=rgb2gray(I);
    clear I;
    I(:,:,1) = Ig;
    I=((I(:,:,1)>handles.lg) & (I(:,:,1)<handles.hg))*1;
end

