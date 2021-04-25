clear; clc 
% Load mat file and reorder k-space
load('meas_MID00831_FID06190_pulseq_tse.mat');
% Load phase encoding order
load('tse_pe_info.mat')
[A,I] = sort(order(:)); 
kk = reshape(kspace, 256, 20, 4, 11, 64);
kk = permute(kk,[1,2,4,3,5]);
kk = reshape(kk, 256, 20, 11, 256); 
kk = permute(kk(:,:,:,I), [1,4,3,2]);
for c = 1:20
    for s = 1:11
        im(:,:,s,c) = fftshift(ifft2(kk(:,:,s,c))); 
    end
end
% Sum-of-squares combination 
images = sqrt(sum(square(abs(im)),4)); 
% Reorder slices and re-orient
images_ordered = permute(images(:,:,end:-1:1),[2,1,3]);
% Display
montage(mat2gray(images_ordered))
title('TSE ACR Slices')