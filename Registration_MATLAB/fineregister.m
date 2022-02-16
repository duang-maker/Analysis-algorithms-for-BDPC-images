clear;
clc;

% path1 = 'E:\data\TemplateMatch\100_20\100_20.bmp';
% path2 = 'E:\data\TemplateMatch\100_20\100_20_1.bmp';
% path_dir = 'D:\duan\matchWBC\corsematch\';
LabelFreePath = 'F:\WBC_classify\supplyment_data\sample2\fuse\input512\';
LabelPath = 'F:\WBC_classify\supplyment_data\sample2\fuse\courseoutput512\';
Labelsave_path = 'F:\WBC_classify\supplyment_data\sample2\fuse\FineRegis\output\';
LabelFreesave_path = 'F:\WBC_classify\supplyment_data\sample2\fuse\FineRegis\input\';
if exist(Labelsave_path)==0
    mkdir(Labelsave_path)
end
if exist(LabelFreesave_path)==0
    mkdir(LabelFreesave_path)
end
list = dir([LabelFreePath, '*.bmp']);
LabelFreeName = {list.name};
num = length(LabelFreeName);
%% 
close all
for i = 1: num % 对无标记数据进行循环
    i
    imgname = LabelFreeName{i};
    LabelFreergb = imread([LabelFreePath, imgname]);
    Labelrgb = imread([LabelPath , imgname]);
    LabelFreeGray = rgb2gray(LabelFreergb);
    LabelGray = rgb2gray(Labelrgb);
    MedSize = 5;
    LabelFreeGrayMed = medfilt2(LabelFreeGray,[MedSize,MedSize]);
    LabelGrayMed = medfilt2(LabelGray,[MedSize,MedSize]);

    %% 
    
    fixed  = LabelFreeGrayMed;
    moving = LabelGrayMed;

    try
    [optimizer,metric] = imregconfig('multimodal');    

    optimizer.MaximumIterations = 100; % default 100
    [movingRegisteredDefault, ~, tform ]= imregister(moving, fixed,'rigid',optimizer,metric);
%     [movingRegisteredDefault, ~, tform ]= imregister(moving, fixed,'rigid',optimizer,metric, 'InitialTransformation',tform);
   
%     figure; imshowpair(movingRegisteredDefault,fixed, 'montage');
%     title('多模态配准');
    % 计算重合面积
    AreaThresh = 0.75; 
    nonzero =( movingRegisteredDefault~=0);
    nonzeronum = sum(nonzero(:));
    [r,c] = size(movingRegisteredDefault);
    con = nonzeronum/(r*c);
    %计算旋转角度
    theta1 = acos(tform.T(1,1));
    theta2 = asin(tform.T(1,2));
    meantheta  = (theta1 +theta2)/2;
    if (con > AreaThresh) && meantheta  < 0.18
        %截取配准区域图像
        Rfixed = imref2d(size(fixed ));
        Rmoving = imref2d(size(moving));
        result = zeros(size(fixed ));
        movDis = sqrt(tform.T(3,1)^2 + tform.T(3,2)^2 );
    %     if (movDis < 50) 
        for j = 1:3
            [movingReg,Rreg] = imwarp(Labelrgb(:,:,j),Rmoving,tform,'OutputView',Rfixed, 'SmoothEdges', true);
            result(:,:,j) = movingReg;
        %     figure; imshow( movingReg );
        end
        wbcnum = split(imgname,'.');
        
        imwrite(uint8(result),[Labelsave_path,wbcnum{1},'.bmp']);
        imwrite(uint8(LabelFreergb),[LabelFreesave_path,wbcnum{1},'.bmp']);
%         figure; 
%         subplot(1,3,1);
%         imshow(Labelrgb);
%         subplot(1,3,2);
%         imshow(LabelFreergb);
%         subplot(1,3,3);
%         imshow(uint8(result));
    end
    catch ME
        ME
        
    end
    
    
    
%     figure; imshowpair(uint8(result),   LabelFreergb, 'diff');
%     imshowpair(uint8(result),   LabelFreergb, 'montage');
%     
%         imwrite(uint8(save_img), [save_path, 'input\', list(i).name, '.bmp'])
%         imwrite(image2_rgb, [save_path, 'output\', list(i).name, '.bmp'])
%     
end
