%% General values
clc, close all, clear all;

%% Task 1

% Load object.mat
load('sinogram.mat')


%% Filtered Backprojection
%% Task 2

% compute reconstruction of k-space without filter
img = fourierReconstruction(sino, angs, 0);

% show the resampled k-space
figure;
imshow(log(abs(img)), []);

% do an inverse fourier transform
img = ifftshift(ifft2(fftshift(img)));

% show the reconstructed, unfiltered object
figure;
imshow(abs(img), []);

% #########################################################################
% Answer:
% -------
% The Theorem used is called the "Fourier Slice Theorem". It says that each
% fourier transform of a projection is the same as a central slice of the
% fourier transform of the object under the same angle to the horizontal
% axis as the projection angle.
% So it's used to give the fourier transformed projections which are taken
% from the sinogram their place in k-space.
% #########################################################################

%% Task 3

% #########################################################################
% Answer:
% -------
% For a sharp image the projections must be filtered, because the point
% density after resamling the k-space is a lot denser in the middle than in
% the outer part. To give each point it's correct weight a RamLak-filter is
% used after fourier transforming the projections.
% #########################################################################

% compute reconstruction of k-space with filter
img = fourierReconstruction(sino, angs, 1);

% show the resampled k-space
figure;
imshow(log(abs(img)), []);

% do an inverse fourier transform
img = ifftshift(ifft2(fftshift(img)));

% show the reconstructed object
figure;
imshow(abs(img), []);

%% Task 4

% Compute the filtered backprojection
img = filteredBackprojection(sino, angs);

% show filtered backprojection
figure;
imshow(img, []);

% #########################################################################
% Answer:
% -------
% In reconstructing the image using resampling of the fourier space appear
% more artefacts than reconstructing the image using the filtered
% backprojection algorithem. This happens due to numerical error which is
% worse intermpolating in k-space than interpolating in image space.
% Zeropadding helps creating a finder resolution fourier-transforming data.
% This leads to less artefacts after an inverse transformation.
% #########################################################################

%% Task 5

% load data with sinograms
load('data.mat')

% define empty array to be filled with reconstructed images
img_data = zeros(size(data, 1), size(data, 1), size(data, 3));

% each loop describes one reconstruction counting through all sinograms
for ii = 1:size(data, 3)
    % get sinogram number ii
    sino_data = data(:, :, ii);
    
    % compute the filtered backprojection and put in place ii of img
    img_data(:, :, ii) = filteredBackprojection(sino_data, 1:179);
end

volumeViewer(abs(img_data))
    
% #########################################################################
% Answer:
% -------
% The volume contains a hand from its wrist to the middle hand.
% #########################################################################