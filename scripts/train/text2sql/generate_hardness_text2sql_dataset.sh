set -e


# predict probability for each schema item in the eval set
python hardness_classifier.py \
    --batch_size 8 \
    --device "0" \
    --seed 42 \
    --save_path "./models/text2sql_hardness_classifier_Jarven/RoBerta-large/4Linear" \
    --dev_filepath "./data/preprocessed_data/refined_dev.json" \
    --output_filepath "./data/preprocessed_data/hardness_dev_with_probs.json" \
    --use_contents \
    --resd_preprocessed \
    --add_fk_info \
    --mode "eval"

python separate_dataset_by_hardness_labels.py \
    --input_dir "./data/preprocessed_data/hardness_dev_with_probs.json" \
    --output_dir "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob" \
    --mode dev