function acf=ac_function(I,s)
% auto correlation or auto convolution function
% calculating the ACF or ACNF of image I
if nargin==1
    s='conv';
end

[len,wid]=size(I);
S=zeros([2*len-1,2*wid-1]);

if s=='conv'
    I1=S;I1(1:len,1:wid)=I;
    I2=S;I2(1:len,1:wid)=I;
    fftI1=fft2(I1);
    fftI2=fft2(I2);
    A=real(ifft2(fftI1.*fftI2));%/(std2(I)*std2(I));
elseif s=='corr'
    I1=S;I1(1:len,1:wid)=I;
    I2=S;I2(end-len+1:end,end-wid+1:end)=I;
    fftI1=fft2(I1);
    fftI2=fft2(I2);
    A=real(ifft2(fftI1.*conj(fftI2)));%/(std2(I)*std2(I));
else
    error('conv or corr or default please');
end

acf=A;

% ACF_none = acf/2;
