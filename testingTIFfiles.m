fname = 'Data/tif/B908_BLA_Sec9L_SlideA2_CompositeRGB_flattened_Z20-23_Flattened.tif';
info = imfinfo(fname);
num_images = numel(info);
for x = 1:num_images
    img = imread(fname,x);
    figure
    imshow(img)
end