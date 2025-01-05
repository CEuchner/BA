function Image = fbp(Sinogram, angs, useFilter, usePadding)
% Calculating filtered backprojection with a given Sinogram
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

if usePadding == true
    N = size(projections, 1);
    projections = padarray(projections, N);
end

% get the number and length of projections

M = size(projections, 2);
N = size(projections, 1);

% in order to rotate around the right center pixels must be added
if mod(N, 2) == 0
    add_f = 0;
else
    add_f = -.5;
end

% define filter function (ramp-filter) for weighing sliecs in k-space
if useFilter == true
    filter = abs(-N/2+add_f:N/2-1+add_f)';
    % filter = fftshift(ifft(ifftshift(RamLak(N/2)))).';
    % filter = real(filter(2:end));
else
    filter = ones([N 1]);
end

% define Image to be filled with backprojections
Image = zeros(N, N);

projections = fftshift(fft(ifftshift(projections)));
projections = projections .* repmat(filter, 1, M);
projections = ifftshift(ifft(fftshift(projections)));

% zeropad sinogram to get projections on sqrt(2) times the size
fac = 0;%N;%ceil(size(projections, 2) * (sqrt(2) - 1) / 2)*1;
% projections = padarray(projections, fac);
N2 = size(projections, 1);

% each loop is a backprojection in one angle
for kk = 1:numel(angs)

    % create backprojection in angele 0,
    % add pixel for it to be centered
    % and rotate it to its actual angle position
    backproj = repmat(projections(:,kk), 1, N2);
    backproj(end, end) = 0;
    backproj = imrotate(backproj, 90+angs(kk), 'bicubic', 'crop');
    % backproj = fourierRotate(backproj, 90+angles(kk));

    % add backprojection to image
    Image = Image + backproj(fac+1:N2-fac, fac+1:N2-fac);

end %for

if usePadding == true
    Image = Image(N/3+1:2*N/3, N/3+1:2*N/3);
end

end %function