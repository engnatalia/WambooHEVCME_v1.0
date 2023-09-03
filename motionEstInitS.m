% Computes motion vectors using Three Step Search method
%
% Input
%   Y : The image for which we want to find motion vectors
%   ref_Y : The reference image
%   puSize : Size of the prediction unit
%   p : Search parameter  
%
% Ouput
%   TSScomputations: The average nupuer of points searched for a prediction unit
%   min: minimum cost based on SAD function
%   x, y: coordinates of best match PU
%   tSADInit: times spent in SAD computations
%
% Written by Aroh Barjatya work, adapted by Natalia Molinero Mingorance


function [tSADInit,TSScomputations, min, x, y] = motionEstInitS(Y, ref_Y, puSize, p)

[row, col] = size(ref_Y);

vectors = zeros(2,row*col/puSize^2);
costs = ones(3, 3) * 65537;
tSADInit=0;
computations = 0;

% we now take effectively log to the base 2 of p
% this will give us the nupuer of steps required

L = floor(log10(p+1)/log10(2));   
stepMax = 2^(L-1);

% we start off from the top left of the image
% we will walk in steps of puSize
% for every prediction unit that we look at we will look for
% a close match p pixels on the left, right, top and bottom of it

puCount = 1;
for i = 1 : puSize : row-puSize+1
    for j = 1 : puSize : col-puSize+1
        
        % the three step search starts
        % we will evaluate 9 elements at every step
        % read the literature to find out what the pattern is
        % my variables have been named aptly to reflect their significance

        x = j;
        y = i;
        
        % In order to avoid calculating the center point of the search
        % again and again we always store the value for it from the
        % previous run. For the first iteration we store this value outside
        % the for loop, but for subsequent iterations we store the cost at
        % the point where we are going to shift our root.
%         tic
        costs(2,2) = costFuncSAD(Y(i:i+puSize-1,j:j+puSize-1), ...
                                    ref_Y(i:i+puSize-1,j:j+puSize-1),puSize);
%         tSADInit(computations + 1) = toc;
        computations = computations + 1;
        
        stepSize = stepMax;               

        while(stepSize >= 1)  

            % m is row(vertical) index
            % n is col(horizontal) index
            % this means we are scanning in raster order
            for m = -stepSize : stepSize : stepSize        
                for n = -stepSize : stepSize : stepSize
                    refBlkVer = y + m;   % row/Vert co-ordinate for ref block
                    refBlkHor = x + n;   % col/Horizontal co-ordinate
                    if ( refBlkVer < 1 || refBlkVer+puSize-1 > row ...
                        || refBlkHor < 1 || refBlkHor+puSize-1 > col) %%for the borders of the blocks; i.e., we don't compare 9 points because we will be out of the search area
                        continue;  
                    end


                    costRow = m/stepSize + 2;
                    costCol = n/stepSize + 2;
                    if (costRow == 2 && costCol == 2)
                        continue
                    end
                    tic
                    costs(costRow, costCol ) = costFuncSAD(Y(i:i+puSize-1,j:j+puSize-1), ...
                        ref_Y(refBlkVer:refBlkVer+puSize-1, refBlkHor:refBlkHor+puSize-1), puSize);
                    tSADInit=tSADInit+toc;
                    computations = computations + 1;
                end
            end
        
            % Now we find the vector where the cost is minimum
            % and store it ... this is what will be passed back.
        
            [dx, dy, min] = minCost(costs);      % finds which prediction unit in ref_Y gave us min Cost
            
            
            
            % shift the root for search window to new minima point

            x = x + (dx-2)*stepSize;
            y = y + (dy-2)*stepSize;
            
            % Arohs thought: At this point we can check and see if the
            % shifted co-ordinates are exactly the same as the root
            % co-ordinates of the last step, then we check them against a
            % preset threshold, and ifthe cost is less then that, than we
            % can exit from teh loop right here. This way we can save more
            % computations. However, as this is not implemented in the
            % paper I am modeling, I am not incorporating this test. 
            % May be later...as my own addition to the algorithm
            
            stepSize = stepSize / 2;
            costs(2,2) = costs(dy,dx);
            
        end
        vectors(1,puCount) = y - i;    % row co-ordinate for the vector
        vectors(2,puCount) = x - j;    % col co-ordinate for the vector            
        puCount = puCount + 1;
        costs = ones(3,3) * 65537;
    end
end
% motionVect = vectors;
% TSScomputations = computations/(puCount - 1);
TSScomputations = computations;                    