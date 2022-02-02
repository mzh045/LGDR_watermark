function w_size=w_size_est(If_s)
% Estimate the size of watermark unit,
% for the case the watermarked image is scaled
theta_size=8;
theta_step=0.1;
%Iz=imfilter(If_s,ones(3));
Iz=If_s;
[len,wid]=size(Iz);
[H1,theta1,rho1]=hough(Iz,'Theta',[90-theta_size:theta_step:90-theta_step,-90:theta_step:-90+theta_size]);%-90:theta_step:90-theta_step%-15:theta_step:15
peaks1=houghpeaks(H1,7,'Threshold',0.5*max(H1(:)));
lines1=houghlines(Iz,theta1,rho1,peaks1,'MinLength',20,'FillGap',wid/2);%200,500

rho_r=abs(cat(1,lines1.rho));
[~,r_max]=max(rho_r);
[~,r_min]=min(rho_r);

[H2,theta2,rho2]=hough(Iz,'Theta',-theta_size:theta_step:theta_size);%-90:theta_step:90-theta_step%
peaks2=houghpeaks(H2,7,'Threshold',0.5*max(H2(:)));
lines2=houghlines(Iz,theta2,rho2,peaks2,'MinLength',20,'FillGap',len/2);

rho_c=abs(cat(1,lines2.rho));
[~,c_max]=max(rho_c);
[~,c_min]=min(rho_c);

%ax+by=c;
a=[cos(lines1(r_min).theta*pi/180);cos(lines1(r_max).theta*pi/180);cos(lines2(c_min).theta*pi/180);cos(lines2(c_max).theta*pi/180)];%上下左右
b=[sin(lines1(r_min).theta*pi/180);sin(lines1(r_max).theta*pi/180);sin(lines2(c_min).theta*pi/180);sin(lines2(c_max).theta*pi/180)];
c=[lines1(r_min).rho;lines1(r_max).rho;lines2(c_min).rho;lines2(c_max).rho];

w_size=w_size_pt(If_s,a,b,c,3);% Obtain the w_size with kmeans clustering.

w_size=round(w_size);

