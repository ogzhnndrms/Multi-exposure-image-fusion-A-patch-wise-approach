function [ck_sub, filtered_data, lk] = pre_calculations(source_sequence, x, y, z, number_of_images, N)

    % Initialize window for moving window operation. It is correlation
    % operation. This window will be iterated over image.
    patch = ones(N);
    % Then turn window to unit length vector type. Its summation is 1.
    % Normalization operation.
    patch = patch / sum(patch(:));

    % To keep sub operation values.
    % Subtraction for padding. +1 for indexing with color channels and number
    % of images.
    filtered_data = zeros(x - N + 1, y - N + 1, z, number_of_images);
    % Local mean intensity.
    lk = zeros(x - N + 1, y - N + 1, number_of_images);
    signal_strength = zeros(x - N + 1, y - N + 1, z);
    sk = zeros(x - N + 1, y - N + 1, number_of_images);
    ck_sub = zeros(x - N + 1, y - N + 1, number_of_images);

    % In the papaer a patch can be decomposed to 3 different composed.
    % 1) Signal strength
    % 2) Signal structure
    % 3) Mean value.

    for i=1:number_of_images
        % Loop RGB times(3 channels). The paper proposed a solution that includes all
        % channel colors to same calculation.
        for j=1:z
            % 'valid' keyword means Return only parts of the convolution that 
            % are computed without zero-padded edges  results.
            % I used convolution because of we need to iterate. If we dont
            % iterate over the image some 
            filtered_data(:, :, j, i) = conv2(source_sequence(:, :, j, i), patch, 'valid');
        end

        % Mean of the current image.
        % Actually local mean of the image.
        % Local = (R + G + B) / 3
        lk(:, :, i) = mean(filtered_data(:, :, :, i), z);

        % Find ck
        % Variance formula.
        % If I use filtered_data it will give 3rd dimension 0.
        for j=1:z
            signal_strength(:, :, j) = conv2(source_sequence(:, :, j, i) .* source_sequence(:, :, j, i), patch, 'valid')...
                - lk(:, :, i) .* lk(:, :, i);
        end
        % Set negative numbers to 0.
        % Calculation of sk.
        % z is 3 for RGB image.
        % Sum of x square divided by N - local mean square.
        ck_sub(:,:,i) = mean(signal_strength, 3);

        % 'mean' value gives the contribution of individual pixel intensity for the entire image & 
        % variance is normally used to find how each pixel varies from the neighbouring pixel 
        % (or centre pixel) and is used in classify into different regions.
    end


end