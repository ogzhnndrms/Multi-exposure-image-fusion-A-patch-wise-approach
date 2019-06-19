% Oguzhan DURMUS - oguzhann.durmus@gmail.com

clear all;

% Parameter Init.
% Patch size
% Emprical value.
N = 11;
% Number of color channels.
C = 3;
% Power for S function.
p = 4;
% For calculating l_hat.
sigma_global = 0.2;
sigma_local = 0.5;
% Moving window size
D = floor(N / 5);

% Load all images in the given directory.
% Also get dimesion information and number of images loaded.
[source_sequence, x, y, z, number_of_images] = load_images('*.png');

[ck_sub, filtered_data, lk] = pre_calculations(source_sequence, x, y, z, number_of_images, N);

ck = sqrt(max(ck_sub, 0));
% ck = ck * sqrt(N^2 * z);
% 0.001 protects from artifacts.
ck = ck * sqrt( N^2 * z ) + 0.001;

% Calculation of c_hat.
max_ck = max(ck, [], 3);

Sk = ck .^ 4;
% Sk = Sk;
% Protects from artifacts.
Sk = Sk + 0.001;
normalizer = sum(Sk,3);
Sk = Sk ./ repmat(normalizer,[1, 1, number_of_images]);

% Variable for sum operations.
temp = zeros(x - N + 1, y - N + 1, z, number_of_images);
for i=1:number_of_images
    for j=1:z
        temp(:, :, j, i) = filtered_data(:, :, j, i) .* Sk(i);
    end
end

% Sum all sk values according to images.
Sk_sum_3d = zeros(x - N + 1, y - N + 1, number_of_images);
for i=1:number_of_images
    Sk_sum_3d(:, :, i) = sum(Sk, 3);
end

for i=1:number_of_images
    for j=1:z
        s_line = temp(:, :, j, i) ./ Sk_sum_3d(i);
    end
end

s_hat = s_line / norm(s_line(:));

% Find global mean.
global_mean = zeros(x - N + 1, y - N + 1, number_of_images);
for i=1:number_of_images
	image = source_sequence(:,:,:,i);
    % Find mean of each image.
	global_mean(:,:,i) = ones(x - N + 1, y - N + 1) * mean(image(:));
end

% l formula calculation.
l_formula = zeros(x - N + 1, y - N + 1, number_of_images);
for i=1:number_of_images
    l_formula(:, :, i) = exp(-((global_mean(:, :, i) - 0.5).^ 2 / (2 * sigma_global ^ 2)) - ((lk(:, :, i) - 0.5).^2 / (2 * sigma_local ^ 2)));
end

normalizer = sum(l_formula, z);
l_formula = l_formula ./ repmat(normalizer,[1, 1, number_of_images]);  

% Now, in the paper stride was chosen 2 that means our loop' s variables
% must be increased 2 by 2.
result = zeros(N, N, z);
result_image = zeros(x, y, z);
number_of_overlaps = zeros(x, y, z);
for i=1:2:x-N+1
    for j=1:2:y-N+1
        result = zeros(N, N, z);
        
        % Now extract patches from image.
        % Get all channels of all images.
        patch2 = source_sequence(i:i+N-1, j:j+N-1, :, :);
        for t=1:number_of_images
            % B�ylece biz bu se�ilen bir patch i�erisinde ki her bir eleman
            % i�in bir ortalama bulup �?karm?? oluyoruz.
            result = result + Sk(i, j, t) * (patch2(:, :, :, t) - lk(i, j, t)) / ck(i, j, t);
        end
        if (norm(result(:))) > 0
            result = (result / norm(result(:))) * max_ck(i, j);
        end
        % We already calculated l formula, now we can calculate
        % l_formula*lk
        result = result + sum(l_formula(i, j, :) .* lk(i, j, :));
        result_image(i:i+N-1, j:j+N-1, :) = result_image(i:i+N-1, j:j+N-1, :) + result;
        % Now we need to take average of the overlapped pixels.
        number_of_overlaps(i:i+N-1, j:j+N-1, :) = number_of_overlaps(i:i+N-1, j:j+N-1, :) + ones(N, N, z);
    end
end

result_image = result_image ./ number_of_overlaps;
result_image(result_image > 1) = 1;
result_image(result_image < 0) = 0;

% Deconvolution for debluring image with a known algorithm and noise type.
% imshow(deconvlucy(result_image, fspecial('gaussian')));
imshow(result_image);
% histogram(histeq(result_image))
% In order to know the statistical behavior of an image we must get the 'Mean' and 'Variance' information. As we know the Gaussian distribution of any random variable indites the maximum probability (aprrox. 94%) of an any value to lie with in the range -(mean+2*standard deviation (sqrt(Variance) ) to +(mean+(2*standard deviation)) . Hence you can analysis the probability of maximum like-hood of a pixel or using this idea you can divide image pixel region.
% However apart from that the Mean and variance of a signal/image mayn't provide you much information about the image. Two image with total different structural similarity may have same mean and variance. Apart from that it totally depends upon the application, you need to elaborate your question.
