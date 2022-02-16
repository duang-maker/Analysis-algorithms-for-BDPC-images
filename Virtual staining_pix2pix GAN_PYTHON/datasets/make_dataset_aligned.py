import os

from PIL import Image


def get_file_paths(folder):
    image_file_paths = []
    for root, dirs, filenames in os.walk(folder):
        filenames = sorted(filenames)
        for filename in filenames:
            input_path = os.path.abspath(root)
            file_path = os.path.join(input_path, filename)
            if filename.endswith('.bmp') or filename.endswith('.jpg'):
                image_file_paths.append(file_path)

        break  # prevent descending into subfolders
    return image_file_paths


def align_images(a_file_paths, b_file_paths, target_path):
    if not os.path.exists(target_path):
        os.makedirs(target_path)

    for i in range(len(a_file_paths)):
        img_a = Image.open(a_file_paths[i])
        img_b = Image.open(b_file_paths[i])
        assert(img_a.size == img_b.size)

        aligned_image = Image.new("RGB", (img_a.size[0] * 2, img_a.size[1]))
        aligned_image.paste(img_a, (0, 0))
        aligned_image.paste(img_b, (img_a.size[0], 0))
        aligned_image.save(os.path.join(target_path, '{:04d}.jpg'.format(i)))


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--dataset-path',
        dest='dataset_path',
        # default= 'D:\duan\pytorch-CycleGAN-and-pix2pix-master\pytorch-CycleGAN-and-pix2pix-master\\unaligneddata\smear0918',
        help='Which folder to process (it should have subfolders testA, testB, trainA and trainB'
    )
    parser.add_argument(
        '--save-path',
        dest='save_path',
        # default= 'D:\duan\pytorch-CycleGAN-and-pix2pix-master\pytorch-CycleGAN-and-pix2pix-master\\unaligneddata\smear0918',
        help='Which folder to save a;igned img (it should have subfolders test train'
    )
    parser.add_argument(
        '--dataset-Apath',
        dest='dataset_Apath',
        # default= 'D:\duan\pytorch-CycleGAN-and-pix2pix-master\pytorch-CycleGAN-and-pix2pix-master\\unaligneddata\smear0918',
        help='Which folder to process (it should have subfolders testA, testB, trainA and trainB'
    )
    parser.add_argument(
        '--dataset-Bpath',
        dest='dataset_Bpath',
        # default= 'D:\duan\pytorch-CycleGAN-and-pix2pix-master\pytorch-CycleGAN-and-pix2pix-master\\unaligneddata\smear0918',
        help='Which folder to process (it should have subfolders testA, testB, trainA and trainB'
    )
    args = parser.parse_args()

    dataset_folder = args.dataset_path
    dataset_Afloder = args.dataset_Apath
    dataset_Bfloder = args.dataset_Bpath
    print(dataset_folder)

    savepath = args.save_path

    test_a_path = os.path.join(dataset_folder, 'testA')
    test_b_path = os.path.join(dataset_folder, 'testB')
    test_a_file_paths = get_file_paths(test_a_path)
    test_b_file_paths = get_file_paths(test_b_path)
    assert(len(test_a_file_paths) == len(test_b_file_paths))
    test_path = os.path.join(savepath, 'test')

    # train_a_path = os.path.join(dataset_folder, 'trainA')
    # train_b_path = os.path.join(dataset_folder, 'trainB')
    # # train_a_path = os.path.join(dataset_Afloder, 'comics')
    # # train_b_path = os.path.join(dataset_Bfloder, 'faces')
    # train_a_file_paths = get_file_paths(train_a_path)
    # train_b_file_paths = get_file_paths(train_b_path)
    # assert(len(train_a_file_paths) == len(train_b_file_paths))
    # train_path = os.path.join(savepath, 'train')

    align_images(test_a_file_paths, test_b_file_paths, test_path)
    # align_images(train_a_file_paths, train_b_file_paths, train_path)
    print('ok')