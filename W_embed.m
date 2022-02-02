% The demo of paper "Local Geometric Distortions Resilient Watermarking Scheme Based on Symmetry"
% Zehua Ma, Weiming Zhang, Han Fang, Xiaoyi Dong, Linfeng Geng, Nenghai Yu
% Copyright 2020-2022 The CAS Key Lab. of Electromagnetic Space Information, USTC

clear
close all

pic_path='input\';
save_path='output\';

File=dir(fullfile(pic_path,'*.tiff'));%
filename={File.name}';
pic_num=length(filename);
psnr_Q=zeros(pic_num,1);
for p_num=1:pic_num
    pic_name=filename(p_num);
    pfname=strcat(pic_path,pic_name);
    pfname=pfname{1,1};
    alpha=2; %watermark strength, default to 2
    I0=im2double(imread(pfname));
    
    I1=rgb2ycbcr(I0);
    Iy=I1(:,:,1)*255;   % double 0~255
    [len,wid]=size(Iy);
    Iy_s=stdfilt(Iy);
    T=6;    % Threshold
    s=Iy_s(Iy_s>T);
    s_ln=log2(s+1);
    lamda=ones(size(Iy))*alpha;
    lamda(Iy_s>T)=s_ln-min(s_ln(:))+alpha; % The strength matrix
    
    W=w_generation(8,len,wid);% generating watermark with 8*8 bits 
    %If host images are in the same size, the watermark W could be
    %calculated outside the loop to save time.
    Iyw=Iy+lamda.*W;
    I2=I1;
    I2(:,:,1)=Iyw/255;%%
    Iw=ycbcr2rgb(I2);
    
%     figure,imshow([I0,Iw])
%     psnr(I0,Iw)
    % save the embedded image with png format
    pic_name=pic_name{1,1};
    ind=find(pic_name=='.');
    savename=[save_path,pic_name(1:ind(end)-1),'.png'];
    imwrite(Iw,savename);
    psnr_Q(p_num)=psnr(I0,im2double(imread(savename)));
end

open psnr_Q



