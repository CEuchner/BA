function Image = filteredBackprojection(Sinogram, angs)
%This MATLAB-function uses a sinogram and it's corresponding angles to
%compute the filtered backprojection and gives the reconstructed image as
%output.
%   
%   INPUT:
%   ------
%       Sinogram    is an NxM-array contaning a sinogram with M projections
%                   N must be even
%       
%       angs        are the M to the sinogram corresponding angles
%
%   OUTPUT:
%   -------
%       Image       is an NxN-array containing the reconstructed image

projections = Sinogram;

% get the length and number of the projections
N = size(Sinogram, 1);
M = size(Sinogram, 2);

% define Image to be filled with backprojections
Image = zeros(N, N);

% define filter (ramp-filter) for weighing sliecs in k-space
filter = (abs(-N/2:N/2-1)/N).';

% 1D-fourier-transform the projections
% use the filter on each fourier-transmormed projection
% and 1D-inverse-fourier-transform the filtered and transformed projections
projections = fft(projections);
projections = circshift(projections, N/2, 1);
projections = projections .* repmat(filter, 1, M);
projections = circshift(projections, -int16(N/2), 1);
projections = ifft(projections);

% each loop is a backprojection in one angle
for kk = 1:numel(angs)

    % Choose projection with projectiona angle number kk
    % create backprojection in angele 0,
    % and rotate it to its actual angle
    backprojection = repmat(projections(:,kk), 1, N);
    backprojection = imrotate(backprojection, 90+angs(kk), 'bicubic', 'crop');

    % add backprojection to image
    Image = Image + backprojection;%(fac+1:N-fac, fac+1:N-fac);

end %for

end %function