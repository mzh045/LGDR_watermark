function [w_status,delta,w_data,w_s]=w_decode(w,w_size)
% Decoding w, outputs are:
% the current watermark unit state w_status
% and the confidence of this judgement delta,
% the decoded watermark data w_data, and the watermark unit w_s, which is
% rotated/flipped to the original state
load parameters K
w_size0=size(K,1);
w_size1=w_size;
if w_size0 > w_size %  
    w_size=w_size0;
    w=imresize(w,[w_size,w_size]);
else
    scale_Q=ceil(w_size/w_size0);
    w_size=w_size0*scale_Q;
    K=imresize(K,[w_size,w_size]);
    w=imresize(w,[w_size,w_size]);
end
M1=0;M2=0; % Scoring of the most likely state M1 and the next most likely state M2.
for alpha=0:90:270 % For all possible state, including rotation ...
    w2=imrotate(w,alpha);
    for lr=0:1% ... and flipping.
        if lr==1
            if mod(alpha/90,2)==1
                w2=w2(end:-1:1,:);
            else
                w2=w2(:,end:-1:1);
            end
        end
        w=w2.*K;
        load parameters w0 m_num
        d=m_num;
        b_size=round(w_size/d); % The block size
        w0=imresize(w0,[b_size,b_size]);
        w=imresize(w,[b_size*d,b_size*d]);
        raw_data=zeros(d,d);
        for i=1:d
            for j=1:d
                temp=w((i-1)*b_size+1:i*b_size,(j-1)*b_size+1:j*b_size);
                mju=mean2(temp);
                sigma=std2(temp);
                if sigma~=0
                    temp=(temp-mju)/sigma;
                else
                    endy=1;% How to handle the case of sigma=0?
                end
                raw_data(i,j)=sum(sum(w0.*temp));
            end
        end
        % Simplified state determination process
        if M1<mean2(abs(raw_data))%
            M2=M1;
            M1=mean2(abs(raw_data));
            w_s=w2;
            data_temp=raw_data;
            w_status=ceil(alpha/90)*2+lr+1;
        elseif M2<mean2(abs(raw_data))
            M2=mean2(abs(raw_data));
        end
        
    end
end

delta=(M1-M2)/M2; % Ratio of the two scores, considered as the confidence for the state M1

w_data=ones(size(raw_data));
w_data(data_temp>0)=0;
w_s=imresize(w_s,[w_size1,w_size1]);
