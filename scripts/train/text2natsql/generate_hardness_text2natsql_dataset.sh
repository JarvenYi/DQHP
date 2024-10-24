set -e


# predict probability for each schema item in the eval set
python hardness_classifier.py \
    --batch_size 8 \
    --device "0" \
    --seed 42 \
    --save_path "./models/text2natsql_hardness_classifier_Jarven/RoBerta-large/4Linear-resd" \
    --dev_filepath "./data/preprocessed_data/resdsql_dev_natsql.json" \
    --output_filepath "./data/preprocessed_data/hardness_dev_with_probs_natsql.json" \
    --use_contents \
    --resd_preprocessed \
    --mode "eval"

python separate_dataset_by_hardness_labels.py \
    --input_dir "./data/preprocessed_data/resdsql_train_spider_natsql.json" \
    --output_dir "./data/preprocessed_data/preprocessed_by_resd_hardness_with_prob_natsql" \
    --mode train

python separate_dataset_by_hardness_labels.py \
    --input_dir "./data/preprocessed_data/hardness_dev_with_probs_natsql.json" \
    --output_dir "./data/preprocessed_data/preprocessed_by_resd_hardness_with_prob_natsql" \
    --mode dev
