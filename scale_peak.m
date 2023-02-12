function If_s=scale_peak(If,d)
% Scale the peaks map wiht ratio d
% d is usually 2 because the symmetry matrix is twice 
% the size of the input image
Iz=zeros(round(size(If)/d));
imLabel=logical(If);
stats=regionprops(imLabel,'Centroid');
loc=cat(1,stats.Centroid);%x,y
loc_z=round(loc/d);
for i=1:size(loc_z,1)
    Iz(loc_z(i,2),loc_z(i,1))=1;
end

If_s=Iz;
