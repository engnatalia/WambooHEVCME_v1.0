% TZ Search with square seach, raster search and raster refinement search
% Calls montionEstInitS, montionEstRasS, montionEstRefS
% Input
%   Y : The image for which we want to find motion vectors
%   ref_Y : The reference image
%   puSize : Size of the prediction unit
%   p : Search parameter  
%   iRaster : Search parameter  
%
% Ouput
%   motionVect : the motion vectors for each integral prediction unit in Y
%   TZScomputations: The average number of points searched for a prediction
%   unit
%   tSADInit: times spent in SAD computations
%   tSADRas: times spent in SAD computations
%   tSADRef: times spent in SAD computations
%   tEndInit: times spent in Init search
%   tEndRas: times spent in raster scan
%   tEndRef: times spent in Refinement scn
% 
% Written by Natalia Molinero Mingorance
% 


function [tSADInit,tSADRas,tSADRef,tEndInit,tEndRas,tEndRef, motionVect, TZScomputations] = motionEstTZS(Y, ref_Y, puSize, p,iRaster)
tSADInit="";
tSADRas="";
tSADRef="";
tEndInit="";
tEndRas="";
tEndRef="";
tInit = tic; 
[tSADInit, TSScomputations, Bestdistance, x, y] = motionEstInitS(Y, ref_Y, puSize, p); %%%square search step
tEndInit = toc(tInit)
TZScomputations=TSScomputations;

if Bestdistance ~= 0
    if Bestdistance > iRaster
        iRaster = 1;
        tRas = tic; 
        [tSADRas, TRasScomputations, motionVect,Bestdistance, x, y] = montionEstRasS(Y, ref_Y, puSize, x, y, iRaster); %%%raster search step
        tEndRas = toc(tRas)
        TZScomputations=TZScomputations+TRasScomputations;
    elseif 0 < Bestdistance && Bestdistance < iRaster 
        tRef = tic; 
        [tSADRef, TRefScomputations,motionVect, x, y] = motionEstRefS(Y, ref_Y, puSize, p, x, y); %%%raster refinement search step 
        tEndRef = toc(tRef)
        TZScomputations=TZScomputations+TRefScomputations;
    end
end
