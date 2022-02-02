function peaks=peaks_fl(I,d,m,n,beta)%
% filter symmetrical peaks from symmetry matrix
% P=peaks_fl(S,100,40,40,beta);
% 1/d area of image edge would not be calculated
% Expect to detect m*n peaks
% beta is the threshold used in Eq.(30)

[len,wid]=size(I);
l_edge=floor(len/d);
w_edge=floor(wid/d);
I1=I(l_edge+1:end-l_edge,w_edge+1:end-w_edge);

[l,w]=size(I1);
l_step=floor(l/m);
w_step=floor(w/n);
I2=zeros(size(I));
I3=zeros(size(I));
for i=l_step+1:l_step:l
    for j=w_step+1:w_step:w
        I1_temp=I1(i-l_step:i,j-w_step:j);
        mju=mean2(I1_temp);
        sigma=std2(I1_temp);
        I2_temp=zeros(size(I1_temp));
        I2_temp(I1_temp>mju+beta*sigma)=1;
        if sum(I2_temp(:))>1
            mI1t=max(I1_temp(:));
            I2_temp=zeros(size(I1_temp));
            I2_temp(I1_temp==mI1t)=1;
        end
        I2(i-l_step+l_edge:i+l_edge,j-w_step+w_edge:j+w_edge)=I2_temp;
    end
end

for i=l_step+floor(l_step/2):l_step:l
    for j=w_step+floor(w_step/2):w_step:w
        I1_temp=I1(i-l_step:i,j-w_step:j);
        mju=mean2(I1_temp);
        sigma=std2(I1_temp);
        I3_temp=zeros(size(I1_temp));
        I3_temp(I1_temp>mju+beta*sigma)=1;
        if sum(I3_temp(:))>1
            mI1t=max(I1_temp(:));
            I3_temp=zeros(size(I1_temp));
            I3_temp(I1_temp==mI1t)=1;
        end
        I3(i-l_step+l_edge:i+l_edge,j-w_step+w_edge:j+w_edge)=I3_temp;
    end
end

peaks=I2&I3;
%
%I_output=I_output(l_edge+1:end-l_edge,w_edge+1:end-w_edge);