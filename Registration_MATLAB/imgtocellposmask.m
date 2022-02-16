function posmask = imgtocellposmask(imgpath, resizefactor, imgtype, Rmin, Rmax)
% NolabelPath = grayimgpath;

RGB = imread(imgpath);
Gray = im2double(rgb2gray(RGB));

% Gray = im2double(rgb2gray(imgpath));
% nolabelGrayMed = medfilt2(nolabelGray,[10,10],'symmetric');
grayresize = imresize(Gray, resizefactor);
[centers, radii, ~] = imfindcircles(grayresize,[Rmin Rmax], 'Sensitivity',0.95 ,...
'ObjectPolarity','dark', 'Method','TwoStage');
% figure;imshow(nolabelGrayMed);
% viscircles(centers, radii,'EdgeColor','b');
% radii
[centers, radii] = choosecir(grayresize, centers,radii,imgtype);
% figure;imshow(grayresize);
% viscircles(centers, radii,'EdgeColor','b');
posmask = obtainmaskofcir(grayresize, centers, radii);

% figure; imshowpair(grayresize,posmask,'falsecolor');