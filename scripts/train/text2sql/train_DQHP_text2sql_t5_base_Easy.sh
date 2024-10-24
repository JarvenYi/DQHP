set -e

## train text2sql-t5-large model
#python -u text2sql.py \
#    --batch_size 12 \
#    --gradient_descent_step 2 \
#    --device "0" \
#    --learning_rate 5e-5 \
#    --epochs 64 \
#    --seed 42 \
#    --save_path "./models/DQHP-base/Easy" \
#    --tensorboard_save_path "./tensorboard_log/DQHP/Easy_refined_hardness_text2sql_base" \
#    --model_name_or_path "./models/text2sql-t5-base/checkpoint-39312" \
#    --use_adafactor \
#    --mode train \
#    --train_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness/Easy_refined_hardness_train_dataset.json" \
#    --output "./predictions/Easy_predicted_sql.txt"

# generate spider hardness dataset
python -u generate_hardness_text2sql_dev_data.py \
    --save_path "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Easy_spider_dev_dataset.json" \
    --input_resd_hardness_file "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Easy_refined_hardness_dev_dataset.json" \
    --input_spider_file "./data/spider/dev.json"

# select the best text2sql-t5-large ckpta
python -u evaluate_text2sql_ckpts.py \
    --batch_size 12 \
    --device "0" \
    --seed 42 \
    --save_path "./models/DQHP-base/Easy" \
    --eval_results_path "./eval_results/DQHP-base-Easy" \
    --mode eval \
    --dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Easy_refined_hardness_dev_dataset.json" \
    --original_dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Easy_spider_dev_dataset.json" \
    --db_path "./database" \
    --num_beams 8 \
    --num_return_sequences 8 \
    --target_type "sql" \
    --output "./predictions/Easy_DQHP_base_predicted_sql.txt"