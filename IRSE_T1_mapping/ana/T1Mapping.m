clc; clear
%% T1 Mapping Script 
% Gehua Tong
% Modified from Enlin Qian's script, Aug 2020
%% Read in files
addpath(genpath('.'))
load('VTI_t1_mapping_images_final.mat');
TI = TI./1000; % convert TI to s to allow better curve fitting performance
TR = (4.5).*ones(size(TI));
size_img = 128;
%image_data_final = squeeze(sqrt(sum((abs(imspace).^2),3)));

im_min = min(image_data_final(:)); 
im_max = max(image_data_final(:));
image_data_final = (image_data_final - im_min)./(im_max-im_min);
%image_data_final = image_data_final./1000; % for better curve fitting
size(image_data_final)
%% Define circular mask manually to cover NIST slice 
imagesc(squeeze(abs(image_data_final(:,:,3))))
addToolbarExplorationButtons(gcf)
axis equal tight
colormap gray
CircleStruc = drawcircle;
mask = createMask(CircleStruc);
close
image_data_final = image_data_final.*mask;

%% curve fitting for each pixel
T1_map = zeros(size_img, size_img);
tic
for n1 = 1:size_img
    for n2 = 1:size_img
        if sum(squeeze(image_data_final(n1,n2,:))) ~= 0
            y_data = squeeze(image_data_final(n1, n2, :));
            [Val, Loc] = min(y_data);
            n3 = 1;
            y_data_opt1 = y_data;
            y_data_opt2 = y_data;
            
            n3 = 1;
            while n3<=Loc
                y_data_opt1(n3) = -y_data_opt1(n3); %to fix the abs value problem
                n3 = n3 + 1;
            end
            
            n3 = 1;
            while n3<Loc
                y_data_opt2(n3) = -y_data_opt2(n3);
                n3 = n3 + 1;
            end
            
            [fitresult1, gof1] = createFitT1(TI, TR, y_data_opt1);
            [fitresult2, gof2] = createFitT1(TI, TR, y_data_opt2);
            if gof1.sse < gof2.sse
                T1_map(n1, n2) = fitresult1.b;
            else
                T1_map(n1, n2) = fitresult2.b;
            end
                
            disp ((n1-1)*size_img+n2)
        end
    end
end
elapsedTime = toc;
disp("Elapsed time: ")
disp(toc)
%% Visualize map
imagesc(T1_map);
colormap hot; axis equal tight;
caxis([0 6]);addToolbarExplorationButtons(gcf);