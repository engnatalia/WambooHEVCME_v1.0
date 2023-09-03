% Computes motion vectors using Raster Scan Search method
%
% Input
%   Y : The image for which we want to find motion vectors
%   ref_Y : The reference image
%   puSize : Size of the prediction unit
%   x, y: coordinates of previous best match PU
%   iRaster : Search parameter  
%
% Ouput
%   TRasScomputations: The average nupuer of points searched for a prediction unit
%   motionVect : the motion vectors for each integral prediction unit in Y
%   min: minimum cost based on SAD function
%   x, y: coordinates of best match PU
%   tSADRas: times spent in SAD computations
%
% Written by Aroh Barjatya work, adapted by Natalia Molinero Mingorance

function [tSADRas,TRasScomputations,motionVect, min, x, y] = montionEstRasS(Y, ref_Y, puSize, x, y,iRaster)

[row col] = size(ref_Y);
tSADRas=0;

vectors = zeros(2,row*col/puSize^2);
p=iRaster;
costs = ones(2*p + 1, 2*p +1) * 65537;
computations = 0;

% we start off from the top left of the image
% we will walk in steps of puSize
% for every prediction unit that we look at we will look for
% a close match p pixels on the left, right, top and bottom of it

puCount = 1;
for i = 1 : puSize : row-puSize+1
    for j = 1 : puSize : col-puSize+1
        
        % the exhaustive search starts here
        % we will evaluate cost for  (2p + 1) blocks vertically
        % and (2p + 1) blocks horizontaly
        % m is row(vertical) index
        % n is col(horizontal) index
        % this means we are scanning in raster order
        
        for m = -p : p        
            for n = -p : p
                refBlkVer = i + m;   % row/Vert co-ordinate for ref block
                refBlkHor = j + n;   % col/Horizontal co-ordinate
                if ( refBlkVer < 1 || refBlkVer+puSize-1 > row ...
                        || refBlkHor < 1 || refBlkHor+puSize-1 > col)
                    continue;
                end
                tic; 
                costs(m+p+1,n+p+1) = costFuncSAD(Y(i:i+puSize-1,j:j+puSize-1), ...
                     ref_Y(refBlkVer:refBlkVer+puSize-1, refBlkHor:refBlkHor+puSize-1), puSize);
                tSADRas=tSADRas+toc;
                computations = computations + 1;
                
            end
        end
        
        % Now we find the vector where the cost is minimum
        % and store it ... this is what will be passed back.
        
        [dx, dy, min] = minCost(costs); % finds which prediction unit in ref_Y gave us min Cost
        vectors(1,puCount) = dy-p-1;    % row co-ordinate for the vector
        vectors(2,puCount) = dx-p-1;    % col co-ordinate for the vector
        puCount = puCount + 1;
        costs = ones(2*p + 1, 2*p +1) * 65537;
    end
end

motionVect = vectors;
% TRasScomputations = computations/(puCount - 1);
  TRasScomputations = computations;     