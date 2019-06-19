function [images, x, y, z, number_of_images] = load_images(file_type)

% Image folder path.
% Open a folder picker to pick folder.
directory_name = uigetdir('C:\');

% Get files with given type and folder.
S = dir(fullfile(directory_name, file_type));

% Get number of images.
[number_of_images, ~] = size(S);

% Read first image and then get size information of the image.
first_image_path = fullfile(directory_name,S(1).name);
image = imread(first_image_path);

% Read all images and put them to a matrix.
% Get size of the image.
[x, y, z] = size(image);

% Create an array to return it.
images = double(zeros(x, y, z, number_of_images));

% Load all images to return array.
for i=1:number_of_images
    image_path = fullfile(directory_name,S(i).name);
    image = im2double(imread(image_path));
    images(:, :, :, i) = double(image);
end
