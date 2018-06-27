function countNeuronsTIF(img_name, min_neuron_size, tif_slide_num, color, threshold_adjust, image_viewing_type)
    img = imread(img_name, tif_slide_num);

    green = img(:,:,2); % Green channel
    blue = img(:,:,3); % Blue channel
    a = zeros(size(img, 1), size(img, 2));
    just_green = cat(3, a, green, a);
    just_blue = cat(3, a, a, blue);

    if strcmp(color,'green')
        bw_file = rgb2gray(just_green);
    elseif strcmp(color, 'blue')
        bw_file = rgb2gray(just_blue);
        % adjust contrast
        bw_file = imadjust(bw_file);
    end
    % get background approximation of surface (lighting and stuff)
    background = imopen(bw_file,strel('disk',35));

    % Display the Background Approximation as a Surface
    %surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
    ax = gca;
    ax.YDir = 'reverse';

    % Remove Background Approximation
    bw2 = bw_file - background;
    %figure, imshow(bw2), title('not thresholded')
    thresholdbw = imbinarize(bw2, graythresh(bw2)+threshold_adjust);

    %figure, imshow(thresholdbw), title('thresholded')

    binarizedImageFINAL = bwareaopen(thresholdbw, min_neuron_size);

    % count remaining white objects
    cc = bwconncomp(binarizedImageFINAL, 8);
    imgText = ['Number of ' color ' Neurons: ' num2str(cc.NumObjects)];

    maskedRgbImage = bsxfun(@times, img, cast(binarizedImageFINAL, 'like', img));
    if strcmp(image_viewing_type, 'diff')
        imshowpair(binarizedImageFINAL, img, image_viewing_type)
    else 
        imshowpair(maskedRgbImage, img, image_viewing_type)
    end

    title(imgText);
end
