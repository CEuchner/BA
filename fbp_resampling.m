function Image = fbp_resampling(Sinogram, angs, useFilter, usePadding)
% Calculating filtered backprojection with a given Sinogram ans angles
%
%   Input Arguments
%       Sinogram    input Sinogram as 2D-Image
%
%       angs        list of angles of the sinogram
%
%   Output Arguments
%       Image       reconstructed image
%--------------------------------------------------------------------------

projections = Sinogram;

% decicde if sinogram gets padded
if usePadding == true
    N = size(Sinogram, 1);
    projections = padarray(projections, N);
end

% get the number and length of projections
N = size(projections, 1);
M = size(projections, 2);

% in order to rotate around the right center pixels must be added
if mod(N, 2) == 0
    add_f = 0;
else
    add_f = -.5;
end

% define filter function (ramp-filter) for weighing sliecs in k-space
if useFilter == true
    filter = abs(-N/2+add_f:N/2-1+add_f)';
else
    filter = ones([N 1]);
end

% define Image to be filled with backprojections
Image = zeros(N, N);

projections = fftshift(fft(ifftshift(projections)));
projections = projections .* repmat(filter, 1, M);

% each loop is one step of resampling the fourier-space
for kk = 1:numel(angs)

    projection = zeros(N, N);
    
    if add_f == 0
        projection(N/2+1, :) = projections(:, kk);
        projection = fourierRotate(projection, angs(kk));
    else
        projection(N/2-add_f, :) = projections(:, kk);
        projection = imrotate(projection, angs(kk), 'bicubic', 'crop');
    end

    % add backprojection to image
    Image = Image + projection;

end %for

% cut off added pixels
Image = ifftshift(ifft2(fftshift(Image)));

if usePadding == true
    Image = Image(N/3+1:2*N/3, N/3+1:2*N/3);
end

end %function