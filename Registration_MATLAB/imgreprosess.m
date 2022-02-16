% ͼ��Ԥ����
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
% figure;imshow(Tempad);title('ʹ�ù���ģ��������');
% Tempmatch2 = imhist(Tempad );
% figure; plot(Tempmatch );title('�����Ҷ�ģ��');figure;
%  plot(Tempmatch2);title('������ģ��');
%% 
% Tempmatch = imhist(Tempfilter );%��ȡƥ��ͼ��ֱ��ͼ
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
[h2, w2, d2]=size(mask);%M��N��  
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
    %% ����ģ���ȡ�Ҷȱ任����
    % ��label ͼ��ĻҶ�ӳ�䵽��ͬ�ռ䣻
%     close all
    Labelout=histeq(Labelfilter,Tempmatch);%ֱ��ͼƥ��
%     figure;imshow(Tempfilter);
%     figure;imshow(Labelout);
    % figure;imshow(LabelResize );
    % imwrite(Tempfilter , [savepath,'TempHist','.bmp']);
    % imwrite(Labelout,[savepath,'LabelHist','.bmp']);
    %% ������ֵ�ĻҶȱ任����label�� template �任����ͬ�Ҷȷ��
%     close all
    % figure; imshow(Labelout);
   
    % LabelAdjust = imadjust(Labelout, [0,0.4],[0,0]);
    LabelAdjust = Labelout;
    LabelAdjust(Labelout<128)=0;
    LabelAdjust(Labelout>140)=135;
    figure; imshow(LabelAdjust )
    


    %% ����SAD��ģ��ƥ��
    src = LabelAdjust;
    [h1,w1]=size(src);%m��n�� 
    src = imresize(src,[h1/resizefactor,w1/resizefactor]);
    [m,n] =size(src);
%     mask = TempAdjust;
%     [h2, w2, d2]=size(mask);%M��N��  
%     mask = imresize(mask,[h2/8,w2/8]);
%     [M,N] = size(mask );
    dst=zeros(m-M+1,n-N+1);  
    for i=1:m-M+1         %��ͼѡȡ��ÿ�λ���һ������  
        for j=1:n-N+1  
%     for i=1:1        %��ͼѡȡ��ÿ�λ���һ������  
%          for j=1:1 
            temp=src(i:i+M-1,j:j+N-1);%��ǰ��ͼ  

            %���������㷨��SAD��
            dst(i,j)=dst(i,j)+sum(sum(abs(double(temp)- double(mask)))); 

            %���ƽ�����㷨��SSD��
    %       dst(i,j)=dst(i,j)+sum(sum((temp-mask).^2));%.^��������ÿ��Ԫ�ص�ƽ��  
        end  
    end  

    % m=min(dst);%�ҳ�����dst��ÿ���е���СԪ�أ�����������m
    % mm=min(m);%��һ���ҳ�m�е���СԪ��mm����ȻҲ���Ǿ���dst�е���СԪ��
    abs_min=min(min(dst));
    [r,c]=find(dst==abs_min);%������Сֵ��dst��ͬ��Ҳ��src���е����к� r���� c����  
    value = abs_min/(M*N);
    dis(kk,2)=value;
    x=c;%x�����Ӧ������
    y=r;%y�����Ӧ������
%     figure;  
%     imshow(mask);title('ģ��');  
%     figure;
%     imshow(src);  
%     hold on;  
%     rectangle('position',[x,y,N-1,M-1],'edgecolor','r'); %[x����,y����,��,��] 
%     hold off;title('ƥ����');  
end
%% 
% ��������
Dis = sortrows(dis,2, 'ascend' );
save([savepath,'SAD.mat'],'Dis');






