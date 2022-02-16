% 图像预处理
close all
clear
% LabelPath = 'E:\BloodData\trainData\LabelImg\6_20.bmp';
% TempPath = 'E:\BloodData\trainData\ScanbyHand\640_640\2\template.bmp';

LabelPath = 'E:\BloodData\trainData\LabelImg\';
TempPath = 'E:\BloodData\trainData\ScanbyHand\640_640\2\template.bmp';
savepath = 'E:\BloodData\trainData\ScanbyHand\640_640\2\';
resizefactor = 8;
type = '*.bmp';
files = dir([LabelPath,type]);
LabelName = {files.name};
LabelNum = length(LabelName);
%% 
Graymaskfile = load('D:\matchWBC\Graymatchmask.mat');
Tempmatch = Graymaskfile.Tempmatch;

% template = rgb2gray(imread(TempPath));
% % [ht, wt] = size(template);
% Tempfilter = medfilt2(template,[20,20],'symmetric');
% Tempad=histeq(Tempfilter,Tempmatch);
% figure;imshow(Tempad);title('使用公共模板做调整');
% Tempmatch2 = imhist(Tempad );
% figure; plot(Tempmatch );title('公共灰度模板');figure;
%  plot(Tempmatch2);title('调整后模板');
%% 
% Tempmatch = imhist(Tempfilter );%获取匹配图像直方图
template = rgb2gray(imread(TempPath));
Tempfilter = medfilt2(template,[20,20],'symmetric');
% Tempmatch  = imhist(Tempfilter  );
Tempfilter = histeq(Tempfilter,Tempmatch);

TempAdjust = Tempfilter;
TempAdjust(Tempfilter<128)=0;
TempAdjust(Tempfilter>128 & Tempfilter<140)=135;
TempAdjust(Tempfilter>140) = 0;
    figure; imshow(TempAdjust);
mask = TempAdjust;
[h2, w2, d2]=size(mask);%M行N列  
mask = imresize(mask,[h2/resizefactor,w2/resizefactor]);
[M,N] = size(mask );
%% 
dis = zeros(LabelNum,2);
dis(:,1)=1:LabelNum;
for kk = 1:LabelNum
    
    Label = rgb2gray(imread([LabelPath,LabelName{kk}]));
%     [hl, wl] = size(Label);
    Labelfilter =  medfilt2(Label,[20,20],'symmetric');
    % LabelResize = imresize(Labelfilter, [hl/resizefactor, wl/resizefactor]);  
    % TempResize = imresize(Tempfilter, [ht/resizefactor, wt/resizefactor]);
    % figure; imshow(LabelResize);
    % figure; imshow(TempResize);
%     figure; imshow(Tempfilter);
    %% 基于模板获取灰度变换曲线
    % 将label 图像的灰度映射到相同空间；
%     close all
    Labelout=histeq(Labelfilter,Tempmatch);%直方图匹配
%     figure;imshow(Tempfilter);
%     figure;imshow(Labelout);
    % figure;imshow(LabelResize );
    % imwrite(Tempfilter , [savepath,'TempHist','.bmp']);
    % imwrite(Labelout,[savepath,'LabelHist','.bmp']);
    %% 基于阈值的灰度变换；将label； template 变换成相同灰度风格
%     close all
    % figure; imshow(Labelout);
   
    % LabelAdjust = imadjust(Labelout, [0,0.4],[0,0]);
    LabelAdjust = Labelout;
    LabelAdjust(Labelout<128)=0;
    LabelAdjust(Labelout>140)=135;
    figure; imshow(LabelAdjust )
    


    %% 基于SAD的模板匹配
    src = LabelAdjust;
    [h1,w1]=size(src);%m行n列 
    src = imresize(src,[h1/resizefactor,w1/resizefactor]);
    [m,n] =size(src);
%     mask = TempAdjust;
%     [h2, w2, d2]=size(mask);%M行N列  
%     mask = imresize(mask,[h2/8,w2/8]);
%     [M,N] = size(mask );
    dst=zeros(m-M+1,n-N+1);  
    for i=1:m-M+1         %子图选取，每次滑动一个像素  
        for j=1:n-N+1  
%     for i=1:1        %子图选取，每次滑动一个像素  
%          for j=1:1 
            temp=src(i:i+M-1,j:j+N-1);%当前子图  

            %绝对误差和算法（SAD）
            dst(i,j)=dst(i,j)+sum(sum(abs(double(temp)- double(mask)))); 

            %误差平方和算法（SSD）
    %       dst(i,j)=dst(i,j)+sum(sum((temp-mask).^2));%.^：矩阵中每个元素的平方  
        end  
    end  

    % m=min(dst);%找出矩阵dst中每列中的最小元素，构成行向量m
    % mm=min(m);%进一步找出m中的最小元素mm，当然也就是矩阵dst中的最小元素
    abs_min=min(min(dst));
    [r,c]=find(dst==abs_min);%返回最小值在dst（同样也在src）中的行列号 r：行 c：列  
    value = abs_min/(M*N);
    dis(kk,2)=value;
    x=c;%x坐标对应的是列
    y=r;%y坐标对应的是行
%     figure;  
%     imshow(mask);title('模板');  
%     figure;
%     imshow(src);  
%     hold on;  
%     rectangle('position',[x,y,N-1,M-1],'edgecolor','r'); %[x坐标,y坐标,宽,高] 
%     hold off;title('匹配结果');  
end
%% 
% 保存数据
Dis = sortrows(dis,2, 'ascend' );
save([savepath,'SAD.mat'],'Dis');






