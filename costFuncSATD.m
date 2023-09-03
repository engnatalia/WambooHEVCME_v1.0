% Computes the Sum Absolute Difference (sAD) for the given two blocks
% Input
%       currentBlk : The block for which we are finding the SAD
%       refBlk : the block w.r.t. which the SAD is being computed
%       n : the side of the two square blocks
%
% Output
%       cost : The SAD for the two blocks
%
%Written by Natalia Molinero Mingorance



function cost = costFuncSATD(currentBlk,refBlk)


err = 0;

        absolute = abs(fwht(refBlk) - fwht(currentBlk)); %Walsh-Hadamard Transform
        err = sum(absolute(:));
 
% uncomment next line to check memory space
% whos absolute err
cost = err;



