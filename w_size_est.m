function w_size=w_size_est(If_s)
% Estimate the size of watermark unit,
% for the case the watermarked image is scaled
theta_size=16;
theta_step=0.1;
%Iz=imfilter(If_s,ones(3));
Iz=If_s;
[len,wid]=size(Iz);
[H1,theta1,rho1]=hough(Iz,'Theta',[90-theta_size:theta_step:90-theta_step,-90:theta_step:-90+theta_size]);%-90:theta_step:90-theta_step%-15:theta_step:15
peaks1=houghpeaks(H1,7,'Threshold',0.5*max(H1(:)));
lines1=houghlines(Iz,theta1,rho1,peaks1,'MinLength',20,'FillGap',wid/2);%200,500

[H2,theta2,rho2]=hough(Iz,'Theta',-theta_size:theta_step:theta_size);%-90:theta_step:90-theta_step%
peaks2=houghpeaks(H2,7,'Threshold',0.5*max(H2(:)));
lines2=houghlines(Iz,theta2,rho2,peaks2,'MinLength',20,'FillGap',len/2);

lines1_num=length(lines1);
lines2_num=length(lines2);
lines_num=lines1_num+lines2_num;
a=zeros(lines_num,1);
b=zeros(lines_num,1);
c=zeros(lines_num,1);
for i=1:lines1_num
    a(i)=cos(lines1(i).theta*pi/180);
    b(i)=sin(lines1(i).theta*pi/180);
    c(i)=lines1(i).rho;
end
for i=lines1_num+1:lines_num
    a(i)=cos(lines2(i-lines1_num).theta*pi/180);
    b(i)=sin(lines2(i-lines1_num).theta*pi/180);
    c(i)=lines2(i-lines1_num).rho;
end

% figure,imshow(If_s),hold on
% for i=1:length(lines1)
%     xy=[lines1(i).point1;lines1(i).point2];
%     plot(xy(:,1),xy(:,2),'LineWidth',1);
% end
% for i=1:length(lines2)
%     xy=[lines2(i).point1;lines2(i).point2];
%     plot(xy(:,1),xy(:,2),'LineWidth',1);
% end
% hold off

w_size=w_size_pt(If_s,a,b,c,3);% Obtain the w_size with kmeans clustering.

w_size=round(w_size);

