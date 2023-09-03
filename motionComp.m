% Computes motion compensated image using the given motion vectors
%
% Input
%   ref_Y : The reference image (luma component)
%   motionVect : The motion vectors
%   puSize : Size of the prediction unit
%
% Ouput
%   imgComp : The motion compensated image
%
% Written by Aroh Barjatya work, adapted by Natalia Molinero Mingorance

function imgComp = motionComp(ref_Y, motionVect, puSize)

[row col] = size(ref_Y);


% we start off from the top left of the image
% we will walk in steps of puSize
% for every marcoblock that we look at we will read the motion vector
% and put that prediction unit from refernce image in the compensated image

puCount = 1;
for i = 1:puSize:row-puSize+1
    for j = 1:puSize:col-puSize+1
        
        % dy is row(vertical) index
        % dx is col(horizontal) index
        % this means we are scanning in order
        
        dy = motionVect(1,puCount);
        dx = motionVect(2,puCount);
        refBlkVer = i + dy;
        refBlkHor = j + dx;
  
        imageComp(i:i+puSize-1,j:j+puSize-1) = ref_Y(refBlkVer:refBlkVer+puSize-1, refBlkHor:refBlkHor+puSize-1);
    
        puCount = puCount + 1;
    end
end

imgComp = imageComp;