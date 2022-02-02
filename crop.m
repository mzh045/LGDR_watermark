function Io=crop(img,Q)
% Cropping image with ratio Q

[len,wid,~]=size(img);
oy=floor(len/2)+1;%
ox=floor(wid/2)+1;

if Q<=1
    new_l=round(len*Q);
    new_w=round(wid*Q);
else
    new_l=Q;
    new_w=Q;
end

if mod(new_l,2)==1
    l1=floor(new_l/2)+1;
    l2=floor(new_l/2);
else
    l1=new_l/2;
    l2=l1;
end

if mod(new_w,2)==1
    w1=floor(new_w/2)+1;
    w2=floor(new_w/2);
else
    w1=new_w/2;
    w2=w1;
end

Io=img(oy-l1+1:oy+l2,ox-w1+1:ox+w2,:);