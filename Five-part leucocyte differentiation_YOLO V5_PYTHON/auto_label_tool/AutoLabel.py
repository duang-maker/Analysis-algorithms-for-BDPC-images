# 将 txt 标签 文件转换为 xml 标签文件, 修改dict中的类，以及xml  txt 和jpg 路径。

from xml.dom.minidom import Document
import os
import cv2


def makexml(txtPath,xmlPath,picPath): #读取txt路径，xml保存路径，数据集图片所在路径
        dict = {'0': "Neu",       #字典对类型进行转换，自己的标签的类。
                '1': "Lym",
                '2': "Eos",
                '3': "Bas",
                '4': "Mon",
               }
        files = os.listdir(txtPath)
        for i, name in enumerate(files):
          xmlBuilder = Document()
          annotation = xmlBuilder.createElement("annotation")  # 创建annotation标签
          xmlBuilder.appendChild(annotation)
          txtFile=open(txtPath+name)
          txtList = txtFile.readlines()
          img = cv2.imread(picPath+name[0:-4]+".bmp")
          Pheight,Pwidth,Pdepth=img.shape
          for i in txtList:
             oneline = i.strip().split(" ")

             folder = xmlBuilder.createElement("folder")#folder标签
             folderContent = xmlBuilder.createTextNode("Rename_512_begin1173")
             folder.appendChild(folderContent)
             annotation.appendChild(folder)

             filename = xmlBuilder.createElement("filename")#filename标签
             filenameContent = xmlBuilder.createTextNode(name[0:-4]+".bmp")
             filename.appendChild(filenameContent)
             annotation.appendChild(filename)

             size = xmlBuilder.createElement("size")  # size标签
             width = xmlBuilder.createElement("width")  # size子标签width
             widthContent = xmlBuilder.createTextNode(str(Pwidth))
             width.appendChild(widthContent)
             size.appendChild(width)
             height = xmlBuilder.createElement("height")  # size子标签height
             heightContent = xmlBuilder.createTextNode(str(Pheight))
             height.appendChild(heightContent)
             size.appendChild(height)
             depth = xmlBuilder.createElement("depth")  # size子标签depth
             depthContent = xmlBuilder.createTextNode(str(Pdepth))
             depth.appendChild(depthContent)
             size.appendChild(depth)
             annotation.appendChild(size)

             object = xmlBuilder.createElement("object")
             picname = xmlBuilder.createElement("name")
             nameContent = xmlBuilder.createTextNode(dict[oneline[0]])
             picname.appendChild(nameContent)
             object.appendChild(picname)
             pose = xmlBuilder.createElement("pose")
             poseContent = xmlBuilder.createTextNode("Unspecified")
             pose.appendChild(poseContent)
             object.appendChild(pose)
             truncated = xmlBuilder.createElement("truncated")
             truncatedContent = xmlBuilder.createTextNode("0")
             truncated.appendChild(truncatedContent)
             object.appendChild(truncated)
             difficult = xmlBuilder.createElement("difficult")
             difficultContent = xmlBuilder.createTextNode("0")
             difficult.appendChild(difficultContent)
             object.appendChild(difficult)
             bndbox = xmlBuilder.createElement("bndbox")
             xmin = xmlBuilder.createElement("xmin")
             mathData=int(((float(oneline[1]))*Pwidth+1)-(float(oneline[3]))*0.5*Pwidth)
             xminContent = xmlBuilder.createTextNode(str(mathData))
             xmin.appendChild(xminContent)
             bndbox.appendChild(xmin)
             ymin = xmlBuilder.createElement("ymin")
             mathData = int(((float(oneline[2]))*Pheight+1)-(float(oneline[4]))*0.5*Pheight)
             yminContent = xmlBuilder.createTextNode(str(mathData))
             ymin.appendChild(yminContent)
             bndbox.appendChild(ymin)
             xmax = xmlBuilder.createElement("xmax")
             mathData = int(((float(oneline[1]))*Pwidth+1)+(float(oneline[3]))*0.5*Pwidth)
             xmaxContent = xmlBuilder.createTextNode(str(mathData))
             xmax.appendChild(xmaxContent)
             bndbox.appendChild(xmax)
             ymax = xmlBuilder.createElement("ymax")
             mathData = int(((float(oneline[2]))*Pheight+1)+(float(oneline[4]))*0.5*Pheight)
             ymaxContent = xmlBuilder.createTextNode(str(mathData))
             ymax.appendChild(ymaxContent)
             bndbox.appendChild(ymax)
             object.appendChild(bndbox)

             annotation.appendChild(object)

          f = open(xmlPath+name[0:-4]+".xml", 'w')
          xmlBuilder.writexml(f, indent='\t', newl='\n', addindent='\t', encoding='utf-8')
          f.close()


if __name__=='__main__':
    Picpath =  "F:\\WBC_classify\\Rename_512_begin1173\\"
    xmlpath = "F:\\WBC_classify\\xml_Rename_512_begin1173\\"
    txtpath = "D:\\duan\\yolov5\\yolov5-master_09172021\\yolov5-master\\runs\detect\exp2\\labels\\"
    if not os.path.exists(xmlpath):
        os.makedirs(xmlpath)
    makexml(txtpath,xmlpath,Picpath)   #txt文件夹 #xml文件夹 #图片数据文件夹



