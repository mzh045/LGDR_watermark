function w_s=space_add_w(img,w_size)
% If there is no geometric distortion, just accumulate watermark units
% to generate a accumulated watermark unit w_s
[len,wid,~]=size(img);
L_num=floor(len/w_size);
W_num=floor(wid/w_size);
Ip=img(1:w_size*L_num,1:w_size*W_num);
w_s=zeros(w_size);
for i=1:L_num
    for j=1:W_num
        if mod(i,2)==1&&mod(j,2)==1
            Ip_w=Ip((i-1)*w_size+1:i*w_size,(j-1)*w_size+1:j*w_size);
            w_s=w_s+Ip_w;
        elseif mod(i,2)==1&&mod(j,2)==0
            Ip_w=Ip((i-1)*w_size+1:i*w_size,j*w_size:-1:(j-1)*w_size+1);
            w_s=w_s+Ip_w;
        elseif mod(i,2)==0&&mod(j,2)==1
            Ip_w=Ip(i*w_size:-1:(i-1)*w_size+1,(j-1)*w_size+1:j*w_size);
            w_s=w_s+Ip_w;
        else
            Ip_w=Ip(i*w_size:-1:(i-1)*w_size+1,j*w_size:-1:(j-1)*w_size+1);
            w_s=w_s+Ip_w;
        end
    end
end
