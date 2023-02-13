function [be_Q,com,w_data1]=w_FD(I,If,w_size)
% Find watermark units from the map If and seperate them from I
% and decode them
% be_Q is the bit error quantity list
% com is the found watermark units in If
% w_data1 is the decoded data

if mod(w_size,2)==1
    w_size=w_size+1;
end
If=double(If);

% load the embedded data
load parameters data

% The filter for locating watermark unit
h_size=2*w_size;
h=zeros(h_size);
hf=floor(h_size/2)+1;
% The circle filter, works well under rotation
omega=0.1;%0.1
for i=1:h_size
    for j=1:h_size
        if (i-hf)^2+(j-hf)^2>w_size^2/2*(1-omega)&&(i-hf)^2+(j-hf)^2<w_size^2/2*(1+omega)
            h(i,j)=1;
        end
    end
end
% The dots filter, more accurate
% h(hf-w_size/2+1,hf-w_size/2+1)=1;
% h(hf-w_size/2+1,hf+w_size/2)=1;
% h(hf+w_size/2,hf-w_size/2+1)=1;
% h(hf+w_size/2,hf+w_size/2)=1;
% cp_r=round(3*min(scale_Q,1));
% cp_size=2*cp_r+1;
% cp=zeros(cp_size);
% for i=1:cp_size
%     for j=1:cp_size
%         if (i-(cp_r+1))^2+(j-(cp_r+1))^2<=cp_r^2
%             cp(i,j)=1;
%         end
%     end
% end
% h=imfilter(h,cp);

Ifh=imfilter(If,h);
wf=(Ifh==4);
% figure,imshow(wf)

com=zeros(size(If,1),size(If,2),3);
com(:,:,1)=If+wf;
com(:,:,2)=If;
com(:,:,3)=If;
% figure,imshow(com)

wf_C=regionprops(wf,'PixelList');%x,y
% wf_C=cat(1,wf_C.PixelList);
% wf_C=wf_C(:,1:2);
Ifp=zeros(size(If)+2*w_size);
Ifp(w_size+1:end-w_size,w_size+1:end-w_size)=If;
if isempty(wf_C)
    be_Q=[32,32];
    w_data1=-1;
else
    C=zeros(4,2,length(wf_C));
    for i=1:length(wf_C)
        %temp=If(wf_C(i).PixelList(1,2)-w_size+1:wf_C(i).PixelList(1,2)+w_size,wf_C(i).PixelList(1,1)-w_size+1:wf_C(i).PixelList(1,1)+w_size);%
        temp=Ifp(wf_C(i).PixelList(1,2)+1:wf_C(i).PixelList(1,2)+w_size*2,wf_C(i).PixelList(1,1)+1:wf_C(i).PixelList(1,1)+w_size*2);
        temp1=temp.*h;
        tempc=regionprops(temp1,'PixelList');
        tempc=cat(1,tempc.PixelList);
        C(:,:,i)=repmat(wf_C(i).PixelList(1,:)-[w_size,w_size],[4,1])+tempc;%[32,32]
    end
    
    if w_size<32%%%%%%%%%%%%%%%
        w_size=32;
    end
    w3=zeros(w_size);
    be_Q=[];
    XY=zeros(size(C(:,:,1)));
    error_num3=32;
    for i=1:size(C,3)
        temp=C(:,:,i);
        center=repmat(mean(temp,1),[4,1]);
        vector=temp-center;
        angles=zeros(4,1);
        u=vector(1,:);
        for vidx=2:4
            v=vector(vidx,:);
            c=cross([u,0],[v,0]);
            if sign(c(3))==0
                asign=1;
            else
                asign=sign(c(3));
            end
            angles(vidx)=acos(dot(v,u)/(norm(v)*norm(u)))*asign;
        end
        [~,idxs]=sort(angles);
        XY(idxs,:)=temp;
        X=XY(:,1);Y=XY(:,2);
        
        %X(1)=X(1)+1;X(4)=X(4)+1;Y(1)=Y(1)+1;Y(2)=Y(2)+1;
        w1=Projective_trans(I,X,Y,w_size*2,w_size*2,0); % Projective transformation
        w1=imresize(w1(1:end,1:end),0.5);
        [~,delta,w_data,w_s]=w_decode(w1,w_size);
        error_num1=sum(sum(data~=w_data));%Number of error bits extracted by this watermark unit
        if delta>0.02  % Take the watermark unit whose delta greater than threshold into the extraction process
            w3=w3+w_s;%*delta; % w3 is the accumulation of w_s
            [~,~,w_data,~]=w_decode(w3,w_size);
            error_num3=sum(sum(data~=w_data)); % Number of error bits extracted by the accumulated watermark unit
            w_data1=w_data;
        end
        be_Q=[be_Q;error_num1,error_num3];
        if min(be_Q(:))==0
            break
        end
    end
end
