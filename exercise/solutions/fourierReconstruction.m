function Image = fourierReconstruction(Sinogram, angs, filterTrue)
%This MATLAB-function uses a sinogram and it's corresponding angles to
%resample the k-space of the radon-transformed image 
%   
%   INPUT:
%   ------
%       Sinogram    is an NxM-array contaning a sinogram with M projections
%                   N must be even
%       
%       angs        are the M to the sinogram corresponding angles
%
%       filterTrue  '1' to use RamLak-filter, '0' to use identity
%
%   OUTPUT:
%   -------
%       Image       is an NxN-array containing the resampled k-space

% create an array 'projections' that contains the sinogram
projections = Sinogram;

% get the length and number of the projections
N = size(projections, 1);
M = size(projections, 2);

% define Image to be filled with fourier slices
Image = zeros(N, N);

% define filter function (ramp-filter or identity) for weighing sliecs in 
% k-space
if filterTrue == 1
    filter = (abs(-N/2:N/2-1)/N).';
else
    filter = ones([N 1]);
end

% 1D-fourier-transform the projections
projections = fftshift(fft(ifftshift(projections)));
% use the filter on each fourier-transmormed projection
projections = projections .* repmat(filter, 1, M);

% each loop places one slice into k-space
for kk = 1:numel(angs)

    % using fourierRotate.m to put the transformed projection into the
    % correct pplace in k-space
    slice = fourierRotate(projections(:, kk).', angs(kk));

    % add the fourierSlice into k-space
    Image = Image + slice;

end %for

end %function