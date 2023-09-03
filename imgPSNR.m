% Computes motion compensated image's PSNR
%
% Input
%   Y : The original image (luma component)
%   imgComp : The compensated image
%   n : the peak value possible of any pixel in the images
%
% Ouput
%   psnr : The motion compensated image's PSNR
%
% Written by Aroh Barjatya work, adapted by Natalia Molinero Mingorance

function psnr = imgPSNR(Y, imgComp, n)

[row col] = size(Y);

err = 0;

for i = 1:row
    for j = 1:col
        err = err + (Y(i,j) - imgComp(i,j))^2;
    end
end
mse = err / (row*col);

psnr = 10*log10(n*n/mse);