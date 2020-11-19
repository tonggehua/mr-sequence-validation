clc
clear 

%% Read in files
addpath(genpath('.'))
load('CU_T2_GS_3T_2_29_2020.mat')
TE = [15; 25; 30; 40; 45; 50; 60; 75; 80; 100; 120; 160];
TE = TE./1000; % convert TI to s to allow better curve fitting performance
TR = 5.*ones(size(TE));
size_img = 256;
image_data_final = zeros(size_img, size_img, length(TE));
image_data_final(:,:,1) = TE_15;
image_data_final(:,:,2) = TE_25;
image_data_final(:,:,3) = TE_30;
image_data_final(:,:,4) = TE_40;
image_data_final(:,:,5) = TE_45;
image_data_final(:,:,6) = TE_50;
image_data_final(:,:,7) = TE_60;
image_data_final(:,:,8) = TE_75;
image_data_final(:,:,9) = TE_80;
image_data_final(:,:,10) = TE_100;
image_data_final(:,:,11) = TE_120;
image_data_final(:,:,12) = TE_160;
clear TE_15 TE_25 TE_30 TE_40 TE_45 TE_50 TE_60 TE_75 TE_80 TE_100 TE_120 TE_160
image_data_final = image_data_final./1000; % for better curve fitting

%% Define mask
imagesc(squeeze(abs(image_data_final(:,:,1))))
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
        if sum(squeeze(image_data_final(n1,n2,:))) ~= 0
            y_data = squeeze(image_data_final(n1, n2, :));
            [fitresult, gof] = createFitT2(TE, y_data); %convert TI to s to allow better curve fitting performance
            T2_map(n1, n2) = fitresult.b;
            disp ((n1-1)*141+n2)
        end
    end
end

imagesc(T2_map);colormap hot; axis equal tight;caxis([0 3]);addToolbarExplorationButtons(gcf);axis off;colorbar;