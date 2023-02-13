% Watermark extraction
clear
close all

save_path='output\';
load parameters m_num K data
d=5; % The filter size of watermark estimation

File=dir(fullfile(save_path,'*.png'));
filename={File.name}';
pic_num=length(filename);
for p_num=1:pic_num
    pic_name=filename(p_num);
    pfname=strcat(save_path,pic_name);
    pfname=pfname{1,1};
    
    Iw=im2double(imread(pfname));
    I2=rgb2ycbcr(Iw);
    Iy=I2(:,:,1);
    I=m_filter(Iy,[d,d]); % The estimated watermark I
    
    S=ac_function(I,'conv');% The symmetry matrix S of I
    beta=3.7; % Threshold to filter the symmetrical peaks map
    If=peaks_fl(S,100,40,40,beta);
    M=scale_peak(If,2);% The watermark unit map
    figure,imshow(M)
    
    % If the watermarked image is scaled, w_size need to be estimated first.
    % Need kmeans() of Statistics and Machine Learning Toolbox in Matlab
    % If there is no geometric distortion or estimation failed, extract watermark directly
    try
        w_size=w_size_est(M);
    catch
        w_size=round(size(K,1));
    end
    % w_size=size(K,1);
    w_s=space_add_w(I,w_size);
    [~,~,w_data,~]=w_decode(w_s,w_size);
    be=sum(sum(w_data~=data));
    % If geometric distortions exist, find the watermark unit in map M and decode them
    [be_Q,com,w_data]=w_FD(I,M,w_size);
    if w_data==-1
        disp('Detection failure!')
    else
        disp(['Accuracy: ',num2str(round((1-min(min(be_Q(:)),be)/m_num/m_num)*100,2)),'%'])
    end
end
