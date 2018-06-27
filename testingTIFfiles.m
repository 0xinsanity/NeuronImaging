fname = '../tif/B908_BLA_Sec9L_SlideA2_CompositeRGB_flattened_Z20-23_Flattened.tif';
img = imread(fname);

red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel
a = zeros(size(img, 1), size(img, 2));
just_red = cat(3, red, a, a);
just_green = cat(3, a, green, a);
just_blue = cat(3, a, a, blue);
back_to_original_img = cat(3, red, green, blue);
figure, imshow(img), title('Original image')
figure, imshow(just_green), title('Green channel')

bw_file = rgb2gray(just_green);
% get background approximation of surface (lighting and stuff)
background = imopen(bw_file,strel('disk',35));

%imshow(background)

% Display the Background Approximation as a Surface
%surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
ax = gca;
ax.YDir = 'reverse';

% Remove Background Approximation
bw2 = bw_file - background;
figure, imshow(bw2), title('not thresholded')

thresholdbw = imbinarize(bw2, graythresh(bw2)+0.15);

figure, imshow(thresholdbw), title('thresholded')

binarizedImageFINAL = bwareaopen(thresholdbw, 15);
    
% count remaining white objects
cc = bwconncomp(binarizedImageFINAL, 8);
imgText = ['Number of Neurons: ' num2str(cc.NumObjects)];
        
maskedRgbImage = bsxfun(@times, img, cast(binarizedImageFINAL, 'like', img));
imshowpair(maskedRgbImage, img, 'montage')

title(imgText);
