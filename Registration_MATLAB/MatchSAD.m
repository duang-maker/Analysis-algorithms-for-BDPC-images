function [rec,value] = TemplateMatchSAD(src,mask,ifshow)
%     src = LabelAdjust;
    [M,N] = size(mask );
    [m,n] =size(src);
%     PaddingWidth = floor(min(M,N)/2);
%     paddingsrc = zeros(morg + 2*PaddingWidth, norg + 2*PaddingWidth);
% %     paddingsrc = paddingmask;
%     paddingsrc(PaddingWidth+1:PaddingWidth+1+morg-1, PaddingWidth+1:PaddingWidth+1+norg-1) = src;
% %     figure; imshow(paddingsrc);
%     paddingmask = zeros(size(paddingsrc));
%     paddingmask(PaddingWidth+1:PaddingWidth+1+morg-1, PaddingWidth+1:PaddingWidth+1+norg-1) = 1;
% %     figure;imshow(paddingmask);
%     [m,n] = size(paddingsrc);
    dst=zeros(m-M+1,n-N+1);  
    for i=1:m-M+1         %子图选取，每次滑动一个像素  
        for j=1:n-N+1  
%     for i=1:1        %子图选取，每次滑动一个像素  
%          for j=1:1 
            
%             loc = paddingmask(i:i+M-1,j:j+N-1); % 非零部分的mask
%             temp=paddingsrc(i:i+M-1,j:j+N-1);%当前子图  
%                 figure; imshowpair(temp,loc);
%             nonzerolen = length(nonzeros(loc));
            
%             masktemp = loc.* mask;
%             figure; imshow(masktemp);
            temp = src(i:i+M-1,j:j+N-1);%当前子图  
            dst(i,j)= sum(abs(double(temp)- double(mask)),'all'); 
%             else
%              dst(i,j)= dst(i,j) + sum(abs(double(temp)- double(mask)),'all')/nonzerolen;   
           

           

            %误差平方和算法（SSD）
    %       dst(i,j)=dst(i,j)+sum(sum((temp-mask).^2));%.^：矩阵中每个元素的平方  
        end  
    end  

    % m=min(dst);%找出矩阵dst中每列中的最小元素，构成行向量m
    % mm=min(m);%进一步找出m中的最小元素mm，当然也就是矩阵dst中的最小元素
    value=min(min(dst));
    [r,c]=find(dst==value);%返回最小值在dst（同样也在src）中的行列号 r：行 c：列  
    value = value/(M*N);
%     dis(kk,2)=value;
    
    x=c(1);%x坐标对应的是列
    y=r(1);%y坐标对应的是行
    rec = [x,y,N,M];
    if ifshow
        figure;  
        imshow(mask);title('模板');  
        figure;
        imshow(src);  
        hold on;  
        rectangle('position',[x,y,N-1,M-1],'edgecolor','r'); %[x坐标,y坐标,宽,高] 
        hold off;title('匹配结果');  
    end
end