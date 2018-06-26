%
%   What the input attributes represent:
%   
% img = image reference in String
% 
% min_neuron_size = smallest pixel connected object that is not a neuron
% (used to remove small white spots)
% 
%type_showing = how you would like to see the data presented. 'montage' =>
% images side by side, 'diff' => on top of each other
%
function countNeurons(img, min_neuron_size, type_showing)
    image = imread(img);

    bw_file = rgb2gray(image);

    % get background approximation of surface (lighting and stuff)
    background = imopen(bw_file,strel('disk',15));

    %imshow(background)

    % Display the Background Approximation as a Surface
    %surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
    ax = gca;
    ax.YDir = 'reverse'

    % Remove Background Approximation and increase contrast
    bw2 = bw_file - background;
    bw3 = imadjust(bw2);

    % threshold image
    binarizedImage = imbinarize(bw2,'adaptive', 'Sensitivity', 0.01);
    
    % binarize image
    binarizedImage2 = bwareaopen(binarizedImage, 100);

    % remove smaller white objects
    binarizedImageFINAL = bwareaopen(binarizedImage2, min_neuron_size);
    
    % count remaining white objects
    cc = bwconncomp(binarizedImageFINAL, 8);

    % display image and text
    imgText = ['Number of Neurons: ' num2str(cc.NumObjects)];
    imshowpair(binarizedImageFINAL, image, type_showing)
    title(imgText);
end