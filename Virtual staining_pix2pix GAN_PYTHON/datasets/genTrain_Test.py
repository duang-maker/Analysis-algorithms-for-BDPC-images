
import os
import cv2

def genTypeAfilefromTypeB(TypeBpath, sourcefile, TypeApath):
    filelist = os.listdir(TypeBpath)
    for img in os.listdir(sourcefile):
        if img in filelist:
            img1path = os.path.join(os.path.join(sourcefile,img))
            img1 = cv2.imread(img1path)
            # rgbimg1 = cv2.cvtColor(img1, cv2.COLOR_BGR2RGB)
            cv2.imwrite(os.path.join(TypeApath,img), img1)
            os.remove(os.path.join(os.path.join(sourcefile,img)))
            print('')

if __name__=='__main__':
    TypeApath = 'F:\WBC_classify\FineRis_512_temp\\testB' # 最后生成的数据集
    TypeBpath = 'F:\WBC_classify\FineRis_512_temp\\testA' # 已有的数据集
    source = 'F:\WBC_classify\FineRis_512_temp\\trainB' # 源文件所在数据集
    genTypeAfilefromTypeB(TypeBpath, source, TypeApath)

