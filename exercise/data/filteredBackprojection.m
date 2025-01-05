function Image = filteredBackprojection(Sinogram, angs)
%##########################################################################
%Add a description of the function here
%##########################################################################
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

% #########################################################################
% add a comment here
% #########################################################################
filter = (abs(-N/2:N/2-1)/N).';

% #########################################################################
% add a comment here
% #########################################################################
projections = fft(projections);
projections = circshift(projections, N/2, 1);
projections = projections .* repmat(filter, 1, M);
projections = circshift(projections, -int16(N/2), 1);
projections = ifft(projections);

% each loop is a backprojection of a filtered projection with projections a
% specific projection angle
for kk = 1:numel(angs)

    % #########################################################################
    % add a comment here
    % #########################################################################
    backprojection = repmat(projections(:,kk), 1, N);
    backprojection = imrotate(backprojection, 90+angs(kk), 'bicubic', 'crop');

    % #########################################################################
    % add a comment here
    % #########################################################################
    Image = Image + backprojection;%(pad_nmbr+1:N-pad_nmbr, pad_nmbr+1:N-pad_nmbr);

end %for

end %function