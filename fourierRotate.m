function J = fourierRotate(I, ang)
%This function rotates a quadratic fourier-space around its correct center
%
%   Input Arguments
%       I       quadratic 2D input gray scale image
%
%       ang     rotation angle
%       
% 
%   Output Arguments
%       J       rotated image
%--------------------------------------------------------------------------

Image = I;

% decide on where rotation center is and rotate
if mod(length(Image), 2) == 0
    Image(end+1, end+1) = 0;
    Image = imrotate(Image, ang, 'bicubic', 'crop');
    J = Image(1:end-1, 1:end-1);
else
    Image = imrotate(Image, ang, 'bicubic', 'crop');
    J = Image;
end %if

end %function