function Sinogram = sinogram(Image, angs)
% This function creates a sinogram in form of a figure from an input image
% with an input array of angles
%
%   Input Arguments
%       Image       2D input gray scale image
%       
%       angs        array of set of angles for the sinogram
%
%   Output Arguments
%       Sinogram    sinogram of the input image
%--------------------------------------------------------------------------

% calculate diffence of number of rows and columns
im_size = size(Image);
diff = im_size(1) - im_size(2);

% check if Image is square and zerofill it otherwise
if diff < 0  % more columns than rows
    % add 'missing' rows, half at one side and the other side
    Image = padarray(Image,[floor(abs(diff)/2) 0],'pre');
    Image = padarray(Image,[ceil(abs(diff)/2) 0],'post');
elseif diff > 0 % more rows than columns
     % add 'missing' columns, half at one side and the other side
    Image = padarray(Image,[0 floor(abs(diff)/2)],'pre');
    Image = padarray(Image,[0 ceil(abs(diff)/2)],'post');
else
    % Image is square
end %if

% predefine Output for sinogram to be filled
Sinogram = zeros(size(Image,1), numel(angs));

for ll=1:numel(angs)
    
    % rotated image by calculated angle
    Image_rotated = imrotate(Image, -angs(ll), 'bicubic', 'crop');

    % calculate projection and add to Sinogram
    Sinogram(:,ll) = sum(Image_rotated, 1);
end %for
% Sinogram = padarray(Sinogram, [1 0], 'post');
end %function