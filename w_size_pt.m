function [w_size,Cen]=w_size_pt(If,a,b,c,num)
% Estimate the size of watermark unit according to
% the lines calculated by hough transformation
dist=@(p1,p2)sqrt((p1(1)-p2(1))*(p1(1)-p2(1))+(p1(2)-p2(2))*(p1(2)-p2(2)));
imLabel=logical(If);
stats=regionprops(imLabel,'Centroid');
loc=cat(1,stats.Centroid);

L=length(loc);
D=[];

line_num=length(a);
for i=1:line_num
    loc_t=[];
    for j=1:L
        if abs(a(i)*loc(j,1)+b(i)*loc(j,2)-c(i))<5%abs(c(i))/50
            loc_t=[loc_t;loc(j,:)];
        end
    end
    if i==3||i==4
        [~,index]=sort(loc_t(:,2));
    else
        [~,index]=sort(loc_t(:,1));
    end
    loc_t=loc_t(index,:);
    for k=1:length(loc_t)-1
        D=[D;dist(loc_t(k,:),loc_t(k+1,:))];
    end
end

[idx,Cen]=kmeans(D,num,'EmptyAction','drop');%,'EmptyAction','drop'
w_size=Cen(mode(idx));


