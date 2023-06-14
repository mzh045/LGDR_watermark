function output=Projective_trans(input,X,Y,m,n,Full)
% projective transformation 
% is needed when watermarked images are under random bending attacks
len=m;%32;
wid=n;%32;
x=[1;wid;wid;1];
y=[1;1;len;len];

A=zeros(8,8);
A(1,:)=[X(1),Y(1),1,0,0,0,-1*X(1)*x(1),-1*Y(1)*x(1)];
A(2,:)=[0,0,0,X(1),Y(1),1,-1*X(1)*y(1),-1*Y(1)*y(1)];
A(3,:)=[X(2),Y(2),1,0,0,0,-1*X(2)*x(2),-1*Y(2)*x(2)];
A(4,:)=[0,0,0,X(2),Y(2),1,-1*X(2)*y(2),-1*Y(2)*y(2)];
A(5,:)=[X(3),Y(3),1,0,0,0,-1*X(3)*x(3),-1*Y(3)*x(3)];
A(6,:)=[0,0,0,X(3),Y(3),1,-1*X(3)*y(3),-1*Y(3)*y(3)];
A(7,:)=[X(4),Y(4),1,0,0,0,-1*X(4)*x(4),-1*Y(4)*x(4)];
A(8,:)=[0,0,0,X(4),Y(4),1,-1*X(4)*y(4),-1*Y(4)*y(4)];

v=[x(1);y(1);x(2);y(2);x(3);y(3);x(4);y(4)];
u=A\v;
U=reshape([u;1],3,3)';
% test yangxi
test = 0;
test = test*100;
tform=projective2d(U');

R=imref2d([m,n]);%,[1,512]-32,[1,512]-64);
if Full==1
    output=imwarp(input,tform);%,'OutputView',R);
else
    output=imwarp(input,tform,'OutputView',R);
end
