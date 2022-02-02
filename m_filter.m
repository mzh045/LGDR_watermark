function w_est=m_filter(img,nhood,noi)
% Watermark estimation from img based on Eq.(23)
% I=m_filter(img, [3,3]);
if size(nhood)==1
    nhood=[nhood,nhood];
end
localMean=filter2(ones(nhood),img)/prod(nhood);
localVar=filter2(ones(nhood),img.^2)/prod(nhood)-localMean.^2;
if nargin<3
    noi=mean2(localVar);
end

localVar=max(localVar, noi);
w_est=(img-localMean)*noi./localVar;