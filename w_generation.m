function W=w_generation(m_num,len,wid,data)

p_size=2;%2,3,4
w_size=m_num*p_size;

% simplest R generation
w0=ones(p_size);
for i=1:p_size
    for j=1:p_size
        if mod(i+j,2)==0
            w0(i,j)=-1;
        end
    end
end

% the original watermark unit
b_size=m_num;%block size/ bit size
if nargin<4
    rng(0)
    data=randi([0,1],b_size,b_size);
end
w=zeros(w_size);
for i=1:b_size
    for j=1:b_size
        if data(i,j)==0
            w((i-1)*p_size+1:i*p_size,(j-1)*p_size+1:j*p_size)=w0;
        else
            w((i-1)*p_size+1:i*p_size,(j-1)*p_size+1:j*p_size)=-w0;
        end
    end
end

% mask matrix K
rng(0)
K=randi([0,1],w_size,w_size)*2-1;
w_k=w.*K;

% doubly upsampled
w_k=imresize(w_k,2,'nearest'); %w_k is the watermark unit
% flipping
wUD=w_k(end:-1:1,:);
wLR=w_k(:,end:-1:1);
wUDLR=w_k(end:-1:1,end:-1:1);
macro=[w_k,wLR;wUD,wUDLR]; 
% W generation
macro_size=size(macro,1);
Lnum=ceil(len/macro_size);
Wnum=ceil(wid/macro_size);
W=zeros(Lnum*macro_size,Wnum*macro_size);
for i=1:Lnum
    for j=1:Wnum
        W((i-1)*macro_size+1:i*macro_size,(j-1)*macro_size+1:j*macro_size)=macro;
    end
end
W=W(1:len,1:wid);

w0=imresize(w0,2,'nearest');
K=imresize(K,2,'nearest');
% save the parameters needed in watermark extraction
save parameters w0 K data m_num








