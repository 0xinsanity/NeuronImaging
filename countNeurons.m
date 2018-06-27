%
%   What the input attributes represent:
%   
% img = image reference in String
% 
% min_neuron_size = smallest pixel connected object that is not a neuron
% (used to remove small white spots)
%
% image_viewing_type = the way you want to view your final image
%
% sensitivity = image sensitivity
%
function countNeurons(img, min_neuron_size, image_viewing_type, sensitivity)
    image = imread(img);

    bw_file = rgb2gray(image);

    % get background approximation of surface (lighting and stuff)
    background = imopen(bw_file,strel('disk',15));

    %imshow(background)

    % Display the Background Approximation as a Surface
    %surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
    ax = gca;
    ax.YDir = 'reverse';

    % Remove Background Approximation and increase contrast
    bw2 = bw_file - background;

    % threshold image
    binarizedImage = imbinarize(bw2,'adaptive', 'Sensitivity', sensitivity);

    % remove smaller white objects
    binarizedImageFINAL = bwareaopen(binarizedImage, min_neuron_size);
    
    % count remaining white objects
    cc = bwconncomp(binarizedImageFINAL, 8);
    
    % split into 3 color dimenstions, convert white to different color
    mask = binarizedImageFINAL; % Make a copy of binarizedImageFINAL and save it in mask
    
    % Mask the image using bsxfun() function
    maskedRgbImage = bsxfun(@times, image, cast(mask, 'like', image));
    %imshow(maskedRgbImage)
    
    % display image and text
    imgText = ['Number of Neurons: ' num2str(cc.NumObjects)];
    if strcmp(image_viewing_type, 'diff')
        imshowpair(mask, image, image_viewing_type)
    else 
        imshowpair(maskedRgbImage, image, image_viewing_type)
    end
    %imshow(binarizedImage)
    title(imgText);
end