% This script computes the Motion Estimation algorithm for TZ Search,
% taking Prediction Units as in HEVC
%it outputs the number of computations in the search algorithms and
%different computation times in the algorithms to evaluate performance
% It then computes the motion compensation and PSNR
% Written by Natalia Molinero Mingorance
clc
close all
clear all
clearAllMemoizedCaches


ref_frame = double(imread('1.jpg'));
target_frame = double(imread('2.jpg'));
ref_frame = ref_frame(1:256, 1:256, :); %%MIRAR CÓMO SE HACE CON EL TAMAÑALO REAL
target_frame = target_frame(1:256, 1:256, :); %%MIRAR CÓMO SE HACE CON EL TAMAÑALO REAL


%%we use only luminance component for current and reference images

R = ref_frame(:,:,1); G = ref_frame(:,:,2); B = ref_frame(:,:,3);
ref_Y=0.288*R+0.587*G+0.114*B;
R = target_frame(:,:,1); G = target_frame(:,:,2); B = target_frame(:,:,3);
Y=0.288*R+0.587*G+0.114*B;
%memUsed
puSize = 32;
p = 128; %parameter for search area: from pu block to border of search area
iRaster = 300;%for refinement search
%iRaster = 4;%for raster search


    % TZ Search
    tStartME = tic; 
    [tSADInit,tSADRas,tSADRef,tEndInit,tEndRas,tEndRef,motionVect,computations ] = motionEstTZS(Y,ref_Y,puSize,p,iRaster);
%     f = @ () motionEstTZS(Y,ref_Y,puSize,p,iRaster);
%     t=timeit(f,8);
    tEndME = toc(tStartME)
    TZScomputations = computations;
    imgComp = motionComp(ref_Y, motionVect, puSize);
    TZSpsnr = imgPSNR(Y, imgComp, 255);
    
%kWh = (watts × hrs) ÷ 1,000
%averaged watts measured during execution: 8.1W
%execution time in hrs:
tEndME=tEndME/3600;
E=14*tEndME/1000;

%operational emissions= E*I
I=275; %carbon intensity in Europe in 2021
O=E*I;
    
% memUsed


save dsplots2 TZSpsnr TZScomputations 