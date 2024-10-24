import os
import json
import torch
import argparse
import torch.optim as optim
import transformers
from tqdm import tqdm

def parse_option():
    parser = argparse.ArgumentParser("command line arguments for fine-tuning pre-trained language model.")

    parser.add_argument('--input_dir', type=str, default="./data/preprocessed_data/hardness_dev_with_probs_natsql.json",
                        help='the json file path preprocessed by refined & hardness classifier,'
                             'train: ./data/preprocessed_data/refined_train_spider_natsql.json'
                             'dev: ./data/preprocessed_data/hardness_dev_with_probs_natsql.json'
                             'test: ')
    parser.add_argument('--output_dir', type=str, default="./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob_natsql(2)",
                        help='the save path of output')
    parser.add_argument('--mode', type=str, default="train",
                        help='train, dev or test')
    opt = parser.parse_args()

    return opt


def separate_dataset(opt):
    # --------------- Separate team By hardness --------------------
    with open(opt.input_dir, 'r', encoding='utf-8') as f:
        dataset = json.load(f)

    easy_dataset, medium_dataset, hard_dataset, extra_dataset = [], [], [], []
    easy_c, medium_c, hard_c, extra_c = 0, 0, 0, 0

    if opt.mode == 'train':
        for data in dataset:
            if data["hardness_labels"] == 0:
                easy_dataset.append(data)
                easy_c += 1
            elif data["hardness_labels"] == 1:
                medium_dataset.append(data)
                medium_c += 1
            elif data["hardness_labels"] == 2:
                hard_dataset.append(data)
                hard_c += 1
            elif data["hardness_labels"] == 3:
                extra_dataset.append(data)
                extra_c += 1
        count = easy_c + medium_c + hard_c + extra_c
        print("The number of each hardness label")
        print("Easy: ", easy_c, "\tMedium: ", medium_c, "\tHard:", hard_c, "\tExtra-Hard:", extra_c)

    elif opt.mode == 'dev' or opt.mode == 'test':
        for data in dataset:
            if data["hardness_pred_probs"] == 0:# "hardness_labels" "hardness_pred_probs"
                easy_dataset.append(data)
                easy_c += 1
            elif data["hardness_pred_probs"] == 1:
                medium_dataset.append(data)
                medium_c += 1
            elif data["hardness_pred_probs"] == 2:
                hard_dataset.append(data)
                hard_c += 1
            elif data["hardness_pred_probs"] == 3:
                extra_dataset.append(data)
                extra_c += 1
        count = easy_c + medium_c + hard_c + extra_c
        print("DEV DATA: The number of each hardness label")
        print("Easy: ", easy_c, "\tMedium: ", medium_c, "\tHard:", hard_c, "\tExtra-Hard:", extra_c)

    if opt.mode == 'train':
        if count != 7000:
            print("------------------------------------")
            print("The train dataset number is NOT 7000!!!")
            print("------------------------------------")
        else:
            with open(opt.output_dir + '/Easy_refined_hardness_train_dataset.json', "w") as f_easy:
                str_easy = json.dumps(easy_dataset, indent=2)
                f_easy.write(str_easy)

            with open(opt.output_dir + '/Medium_refined_hardness_train_dataset.json', "w") as f_medium:
                str_medium = json.dumps(medium_dataset, indent=2)
                f_medium.write(str_medium)
            with open(opt.output_dir + '/Hard_refined_hardness_train_dataset.json', "w") as f_hard:
                str_hard = json.dumps(hard_dataset, indent=2)
                f_hard.write(str_hard)
            with open(opt.output_dir + '/Extra-hard_refined_hardness_train_dataset.json', "w") as f_extra:
                str_extra = json.dumps(extra_dataset, indent=2)
                f_extra.write(str_extra)
            print("Train dataset has Finished!")

    elif opt.mode == 'test':
        if False:
            print("------------------------------------")
            print("The test dataset number is NOT 1034!!!")
            print("------------------------------------")
        else:
            with open(opt.output_dir + '/Easy_refined_hardness_test_dataset.json', "w") as f_easy:
                str_easy = json.dumps(easy_dataset, indent=2)
                f_easy.write(str_easy)
            with open(opt.output_dir + '/Medium_refined_hardness_test_dataset.json', "w") as f_medium:
                str_medium = json.dumps(medium_dataset, indent=2)
                f_medium.write(str_medium)
            with open(opt.output_dir + '/Hard_refined_hardness_test_dataset.json', "w") as f_hard:
                str_hard = json.dumps(hard_dataset, indent=2)
                f_hard.write(str_hard)
            with open(opt.output_dir + '/Extra-hard_refined_hardness_test_dataset.json', "w") as f_extra:
                str_extra = json.dumps(extra_dataset, indent=2)
                f_extra.write(str_extra)
            print("Test dataset has Finished!")

    elif opt.mode == 'dev':
        if count != 1034:
            print("------------------------------------")
            print("The dev dataset number is NOT 1034!!!")
            print("------------------------------------")
        else:
            with open(opt.output_dir + '/Easy_refined_hardness_dev_dataset.json', "w") as f_easy:
                str_easy = json.dumps(easy_dataset, indent=2)
                f_easy.write(str_easy)
            with open(opt.output_dir + '/Medium_refined_hardness_dev_dataset.json', "w") as f_medium:
                str_medium = json.dumps(medium_dataset, indent=2)
                f_medium.write(str_medium)
            with open(opt.output_dir + '/Hard_refined_hardness_dev_dataset.json', "w") as f_hard:
                str_hard = json.dumps(hard_dataset, indent=2)
                f_hard.write(str_hard)
            with open(opt.output_dir + '/Extra-hard_refined_hardness_dev_dataset.json', "w") as f_extra:
                str_extra = json.dumps(extra_dataset, indent=2)
                f_extra.write(str_extra)
            print("Dev dataset has Finished!")


if __name__ == "__main__":
    opt = parse_option()
    path = opt.output_dir
    if not os.path.exists(path):
        os.makedirs(path)
    separate_dataset(opt)
