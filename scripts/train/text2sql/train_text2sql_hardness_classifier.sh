set -e

# train schema item classifier
python -u hardness_classifier.py \
    --batch_size 8 \
    --gradient_descent_step 2 \
    --device "1" \
    --learning_rate 1e-5 \
    --gamma 2.0 \
    --alpha 0.75 \
    --epochs 64 \
    --patience 16 \
    --seed 42 \
    --save_path "./models/text2sql_hardness_classifier_Jarven/RoBerta-large/4Linear" \
    --tensorboard_save_path "./tensorboard_log/text2sql_hardenss_classifier_Jarven/hardness-resd_RoBERTa-large-4Linear" \
    --train_filepath "./data/preprocessed_data/refined_train_spider.json" \
    --dev_filepath "./data/preprocessed_data/refined_dev.json" \
    --model_name_or_path "./models/roberta-large" \
    --resd_preprocessed_data \
    --use_contents \
    --add_fk_info \
    --mode "train"\
    --edge_type "Default"

