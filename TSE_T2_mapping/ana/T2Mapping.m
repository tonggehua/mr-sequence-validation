clc; clear 

%% Read in files
addpath(genpath('.'))
%load('t2_mapping_images.mat')
load('data/T1T2_mapping_images_filtered.mat','t2_images')
TE = 7*(1:23)./1000;
TR = 4.5.*ones(size(TE));
size_img = 128;
image_data_final = mat2gray(t2_images); 
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
% Only use TE # m - 23 
TE_fin = TE(4:end);
for n1 = 1:size_img
    for n2 = 1:size_img
       if nnz(image_data_final(n1,n2,:))== 23
            y_data = squeeze(image_data_final(n1, n2, :));
            y_data = y_data(4:end);
            [fitresult, gof] = createFitT2(TE_fin, y_data); 
            T2_map(n1, n2) = fitresult.b;
            disp ((n1-1)*141+n2)
       end
    end
end
%% Display
imagesc(T2_map);colormap hot; axis equal tight;caxis([0 3]);addToolbarExplorationButtons(gcf);colorbar
title('T2 map'); axis off