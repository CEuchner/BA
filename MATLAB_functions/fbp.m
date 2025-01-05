function Image = fbp(Sinogram, angs, useFilter, usePadding)
% Calculating filtered backprojection with a given Sinogram and angles
%
%   Input Arguments
%       Sinogram    input Sinogram as 2D-Image
%
%       angs        list of angles of the sinogram
%       
%       useFilter   'true' to use ramp-filter, 'false' to use no filter
% 
%       usePadding  'true' to pad projections of sinogram to three times
%                       the size, 'false' to not pad the sinogram
%
%   Output Arguments
%       Image       reconstructed image
%--------------------------------------------------------------------------

projections = Sinogram;

% decicde if sinogram gets padded
if usePadding == true
    N = size(projections, 1);
    projections = padarray(projections, N);
end

% get the number and length of projections
M = size(projections, 2);
N = size(projections, 1);

% in order to create the correct RamLak-filter get a pixel shift for odd 
% projection lengths 
if mod(N, 2) == 0
    add_f = 0;
else
    add_f = .5;
end

% define filter function (ramp-filter) for weighing sliecs in k-space
if useFilter == true
    filter = abs(-N/2+add_f:N/2-1+add_f)';
else
    filter = ones([N 1]);
end

% define Image to be filled with backprojections
Image = zeros(N, N);

% 1D-fourier-transform the projections
% use the filter on each fourier-transmormed projection
% and 1D-inverse-fourier-transform the filtered and transformed projections
projections = fft(projections);
projections = circshift(projections, N/2+add_f, 1);
projections = projections .* repmat(filter, 1, M);
projections = circshift(projections, -int16(N/2+add_f), 1);
projections = ifft(projections);

% each loop is a backprojection in one angle
for kk = 1:numel(angs)

    % create backprojection in angele 0,
    % add pixel for it to be centered
    % and rotate it to its actual angle position
    backproj = repmat(projections(:,kk), 1, N);
    backproj = imrotate(backproj, 90+angs(kk), 'bicubic', 'crop');

    % add backprojection to image
    Image = Image + backproj;

end %for

if usePadding == true
    Image = Image(N/3+1:2*N/3, N/3+1:2*N/3);
end

end %function