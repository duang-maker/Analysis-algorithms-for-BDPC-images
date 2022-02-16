 close all
clear
tic
% NolabelPath = 'F:\DetectWBC\multicell\20_3.bmp';
NolabelPath = 'F:\WBC_classify\supplyment_data\sample2\fuse\input512\'; % 无标记白细胞（模板路径）
savepath = 'F:\WBC_classify\supplyment_data\sample2\fuse\courseoutput512\';
SaveWholeColor = 0; % 1 代表存储标记图像原图，否则存贮相应最大处小图
% txtpath = [savepath, 'Nolabel_lable.txt'];
% file_id=fopen(txtpath,'a+');
if exist(savepath)==0
    mkdir(savepath)
end
% resizefactor = 1/4;
resizefactor = 1/4;
%% 

Path = 'F:\WBC_classify\supplyment_data\sample2\fuse\reponscolor\'; % 染色图像路径
labelfile = dir([Path,'*.bmp']);
labelnum = length(labelfile);
labelname = {labelfile.name};
%% 
nolabelfile = dir([NolabelPath,'*.bmp']);
nolabelnum = length(nolabelfile);
nolabelname = {nolabelfile.name};
startime = toc;
for t = 1: nolabelnum
%     if strcmp(nolabelname{t},'685_1.bmp')
    
    nolabel = [NolabelPath,nolabelname{t}];
    posmask = imgtocellposmask(nolabel, resizefactor,'nolabel', 6, 12);
    % figure; imshow()
    posmaskresize = imresize(posmask, 0.5);
    % [HT, WT] = 
    tic
    dis = zeros(labelnum,6);
    dis(:,1)=1:labelnum;
    for i = 1: labelnum
%         i
        medtime = toc;
%         if strcmp(labelname{i},'6_20_2.bmp')
        disp(['the',num2str(t),'WBC is processing:',num2str(i),'/',num2str(labelnum),'using time:'...
            ,num2str(medtime - startime)]);
        labelPath = [Path,labelname{i}];
        labelposmask = imgtocellposmask(labelPath, resizefactor,'label', 6, 12);
        labelposmaskresize = imresize(labelposmask , 0.5);
        % label = imread(labelPath);
        [rec,value] = MatchSAD(labelposmaskresize,posmaskresize,0);
%         [I_SSD,I_NCC]=template_matching(posmaskresize,labelposmaskresize);
    %   % Find maximum correspondence in I_SDD image
%         value= min(I_SSD(:));
%         [x,y]=find(I_SSD== value);
        dis(i,2)=value;
        dis(i,3:6) = rec;
%         end
    end
    toc
    %% 直接找最小
    ImgIndex = find(dis(:,2) == min(min(dis(:,2))));
    ImgName = labelname{ImgIndex};
    Label = imread([Path,ImgName]);
    wbcchars = strsplit(nolabelname{t},'.');
    wbc = wbcchars{1};
%     labelchars = strsplit(labelname{ImgIndex},'.');
%     label = labelchars{1};
% %     subpath = [savepath, wbc,'\'] ;
% %     if exist(subpath) ==0
% %         mkdir(subpath)
% %     end
    if SaveWholeColor ==1
        imwrite(Label,[savepath, wbc,'.bmp']);
    else
%         rec : xywh(左上角)
        [H,W,C] = size(Label);
        rec = dis(ImgIndex,3:6)*8;
%         cropwidth = rec(5)*12;
%         cropheight = rec(6)*12;
%         xmin = min(rec(1), W-cropwidth-1);
        target = imcrop( Label,rec);
        imwrite(target,[savepath, wbc,'.bmp']);
    end
%     figure;imshow(target);
    %% 
    
%      Dis = sortrows(dis,-2 );
%      Dis = sortrows(dis,2, 'ascend' );
    %     save([savepath,'SAD320.mat'],'Dis');
    %% 
% top = 1;
%     for i = 1: top
%         ImgIndex = Dis(i, 1);
%         ImgIndex = 6915;
%         ImgName = labelname{ImgIndex};
%         Label = imread([Path,ImgName]);
%         rec = Dis(i,3:6)*8;
%         target = imcrop( Label,rec);
%         figure;imshow(target);
%         chars = strsplit(nolabelname{t},'.');
%         imwrite(uint8(target),[savepath,'tar_',chars{1},'.bmp']);
%         imwrite(uint8(target),[savepath, chars{1},'_',num2str(i),'.bmp']);

%     end
    
end
% end
%% test 
% Labelfreepath = 'F:\WBC_classify\Rename_nolabel_520_0918\000438.bmp';
% Labelpath = 'F:\test\Labelfree\';
% savepath = 'F:\test\Labelfree\posmask\1\';
% if exist(savepath)==0
%     mkdir(savepath)
% end
% type = '*.bmp';
% files = dir([Labelpath,type]);
% filename = {files.name};
% filenum = length(files);
% for i = 1:filenum
%     imgpath = [Labelpath,filename{i}];
%     labelposmask = imgtocellposmask(imgpath, 1/4,'nolabel', 6, 12);
%      imwrite(uint8(labelposmask),[savepath, num2str(i),'.bmp']);
% %     figure; imshow(labelposmask);
% %     pause(3);
% end
% % posmask = imgtocellposmask(Labelfreepath, 1/4,'nolabel', 6, 12);
% % % figure; imshow(posmask);
% posmaskresize = imresize(posmask, 0.5);
% labelposmask = imgtocellposmask(Labelpath, 1/4,'label', 6, 12);
% labelposmaskresize = imresize(labelposmask , 0.5);
%         % label = imread(labelPath);
% [rec,value] = MatchSAD(labelposmaskresize,posmaskresize,1);




