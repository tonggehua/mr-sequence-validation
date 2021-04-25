clear; clc 
% Load mat file and reorder k-space
load('meas_MID00828_FID06187_pulseq_irse.mat');
kk = reshape(kspace, 256, 20, 11, 256);
kk = permute(kk,[1,4,3,2]);
for c = 1:20
    for s = 1:11
        im(:,:,s,c) = fftshift(ifft2(kk(:,:,s,c))); 
    end
end
% Sum-of-squares combination 
images = sqrt(sum(square(abs(im)),4)); 
% Reorder slices and re-oriented
load('irse_sl_order.mat')
[A,I] = sort(sl_order(:));
images_ordered = permute(images(:,:,I),[2,1,3]);
images_ordered = images_ordered(:,:,end:-1:1);
% Display
montage(mat2gray(images_ordered))
title('IRSE ACR Slices')
