import cv2
import numpy as np
import os
from matplotlib import pyplot as plt
import math


def contrast_canny(ScainByHandOrMachine, img):
    if ScainByHandOrMachine == 'M':
        # ImgType = 'jpg'
        CannyUpLimit = 60
    elif ScainByHandOrMachine == 'H':
        # ImgType = 'BMP'
        # CannyUpLimit = 80
        CannyUpLimit = 80
    # contrast = contrast_Min_Max()

    # canny = cv2.Canny(original_img, 190, 250)
    canny = cv2.Canny(original_img, 5, CannyUpLimit)
    ThisContrast = np.sum(canny)

    # cv2.namedWindow('canny', 0)
    # cv2.imshow('canny', canny)
    # cv2.waitKey(0)
    # # print('')
    return ThisContrast

def contrast_Min_Max(BoxSize, image):
    height, width = np.shape(image)
    YStepNum = int(np.floor(height/BoxSize))
    XStepNum = int(np.floor(width/BoxSize))
    ContrastList = []
    for i in range(YStepNum):
        for j in range(XStepNum):
            SubImg = image[i*BoxSize:(i+1)*BoxSize, j*BoxSize:(j+1)*BoxSize]
            MinValue = np.min(SubImg)
            MaxValue = np.max(SubImg)
            item = (MaxValue- MinValue)/(MaxValue+MinValue+0.1)
            ContrastList.append(item)
    ContrastArray = np.array(ContrastList)
    ThisContrast = np.mean(ContrastArray)
    # print('')
    return ThisContrast

def contrast_sobel(img):
    sobelx = cv2.Sobel(img,cv2.CV_64F,1,0,ksize=3)
    # sobelx = cv2.convertScaleAbs(sobelx)
    sobely = cv2.Sobel(img,cv2.CV_64F,0,1,ksize=3)
    # sobely = cv2.convertScaleAbs(sobely)
    # sobelxy = cv2.addWeighted(sobelx, 0.5, sobely, 0.5, 0)
    sobelxy = np.sqrt(np.square(sobelx) + np.square(sobely))

    Thiscontrast = np.sum(sobelxy)
    return Thiscontrast
def contrast_var(img):
    var = np.var(img)
    return var

def contrast_entropy(img):
    tmp = []
    for i in range(256):
        tmp.append(0)
    val = 0
    k = 0
    res = 0
    for i in range(len(img)):
        for j in range(len(img[i])):
            val = img[i][j]
            tmp[val] = float(tmp[val] + 1)
            k = float(k + 1)
    for i in range(len(tmp)):
        tmp[i] = float(tmp[i] / k)
    for i in range(len(tmp)):
        if (tmp[i] == 0):
            res = res
        else:
            res = float(res - tmp[i] * (math.log(tmp[i]) / math.log(2.0)))
    return res
    # print

def contrast_brenner(img):
    shape = np.shape(img)

    out = 0

    for x in range(0, shape[0] - 2):

        for y in range(0, shape[1]):

            out += (int(img[x + 2, y]) - int(img[x, y])) ** 2

    return out


if __name__=='__main__':
    imgpath = 'F:\DPC_experimental_data\ChangeFocus_scaning\\4'
    filelist = os.listdir(imgpath)
    contrast = []
    # filelist.split('_')
    # filelist.sort(key = lambda x: int(x[1])
    # 注意，这里使用lambda表达式，将文件按照最后修改时间顺序升序排列
    # os.path.getmtime() 函数是获取文件最后修改时间
    # os.path.getctime() 函数是获取文件最后创建时间
    dir_list = sorted(filelist,  key=lambda x: os.path.getctime(os.path.join(imgpath , x)))

    ScainByHandOrMachine = 'H'
    if ScainByHandOrMachine == 'M':
        ImgType = ['jpg']
        # CannyUpLimit = 60
    elif ScainByHandOrMachine == 'H':
        ImgType = ['BMP', 'bmp']
        # CannyUpLimit = 80
    with open(imgpath + '//' + "info.txt", "w") as f:
        for file in dir_list:
            if file.split('.')[-1] in ImgType:
                infovalue = []
                original_img = cv2.imread(os.path.join(imgpath, file), 0)
                # canny = cv2.Canny(original_img, 5, CannyUpLimit)
                # contrast_value = contrast_entropy(original_img)
                # contrast_value = contrast_brenner(original_img)
                # contrast_value = contrast_Min_Max(9, original_img)
                # contrast_value = np.sum(canny)
                contrast_value = contrast_canny(ScainByHandOrMachine, original_img)
                contrast.append(contrast_value)
                if ScainByHandOrMachine == 'H':
                    # 手扫数据
                    savefilename = file.split('.')
                    f.write(savefilename[0] + '.' + savefilename[1] + '\t' + str(contrast_value))
                elif ScainByHandOrMachine == 'M':
                    # 扫描仪数据
                    savefilename = file.split('_')
                    f.write(savefilename[1] + '\t' + str(contrast_value))
                # f.write(file + '\t' + str(contrast_value))
                f.write('\n')


    print('')
    plt.plot(contrast)
    plt.savefig( imgpath+ '//'+ "contrast_canny_02152022.svg", format="svg")
    plt.show()
# info = []
# maxinfo = []
# maxinfo.append(max(contrast))
# maxinfo.append(contrast.index(max(contrast)))


# canny(): 边缘检测
