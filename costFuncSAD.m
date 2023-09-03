% Computes the Sum Absolute Difference (sAD) for the given two blocks
% Input
%       currentBlk : The block for which we are finding the MAD
%       refBlk : the block w.r.t. which the MAD is being computed
%       n : the side of the two square blocks
%
% Output
%       cost : The sAD for the two blocks
% Written by Natalia Molinero Mingorance




function cost = costFuncsAD(currentBlk,refBlk, n)


err = 0;
absolute = abs(refBlk - currentBlk);
err = sum(absolute(:));
 
cost = err;

