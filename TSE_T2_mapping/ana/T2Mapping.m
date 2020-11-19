clc;clear 
%% T2 Mapping Script 
% Gehua Tong
% Modified from Enlin Qian's script, Aug 2020
%% Read in files
addpath(genpath('.'))
load('VTE_t2_mapping_images_final.mat')

TE = 7*(1:23)./1000;
TE = TE(4:end); % Removing the first 3 TE values for better overall fit
TR = 4.5.*ones(size(TE));
size_img = 128;
image_data_final = mat2gray(im(:,:,4:end)); % Removing the first 3 TEs again  
%image_data_final = image_data_final./1000; % for better curve fitting
%% Define mask
imagesc(squeeze(abs(image_data_final(:,:,3))))
addToolbarExplorationButtons(gcf)
axis equal tight
colormap gray
CircleStruc = drawcircle;
mask = createMask(CircleStruc);
close
image_data_final = image_data_final.*mask;
%% curve fitting for each pixel
T2_map = zeros(size_img, size_img);
for n1 = 1:size_img
    for n2 = 1:size_img
       if nnz(image_data_final(n1,n2,:))== 20
            y_data = squeeze(image_data_final(n1, n2, :));
            [fitresult, gof] = createFitT2(TE, y_data);
            T2_map(n1, n2) = fitresult.b;
            disp ((n1-1)*141+n2)
       end
    end
end
%% Display
imagesc(T2_map);colormap hot; axis equal tight;caxis([0, 1.5]);
addToolbarExplorationButtons(gcf);colorbar
title('T2 map')