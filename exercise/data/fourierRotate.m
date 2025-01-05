function Iamge = fourierRotate(fourierSlice, ang)
%This function takes a slice (1xN-array), puts it centered into the "empty"
%fourier-space and finally rotates it by an given angle, making sure it is
%rotated around the correct center.
%Centered in this case means centered according to the center of
%fourier-space, which is at N/2+1 for a even N and at (N+1)/2 for an odd N.
%   
%   INPUT:
%   ------
%       fourierSlice    is a 1xN-array
%       
%       ang             is an angle in degrees
%
%   OUTPUT:
%   -------
%       Image           is an NxN-array containing fourierSlice rotate by
%                       the given angle

% get the length of fourierSlice
N = length(fourierSlice);

% create an empty array to be filled with fourierSlice
Image = zeros(N);

% decide wether N is even or odd
if mod(N, 2) == 0 % describes a rotation around N/2+1
    % put fourierSlice in the 
    Image(end/2+1, :) = fourierSlice;
    % add an extra pixel in each dimension
    Image(end+1, end+1) = 0;
    % rotate Image by ang
    Image = imrotate(Image, ang, 'bicubic', 'crop');
    % subtract the added pixels
    Iamge = Image(1:end-1, 1:end-1);
else % describes a rotation around (N+1)/2
    % put fourierSlice in the 
    Image(end/2+1/2, :) = fourierSlice;
    % rotate Image by ang
    Image = imrotate(Image, ang, 'bicubic', 'crop');
end

end