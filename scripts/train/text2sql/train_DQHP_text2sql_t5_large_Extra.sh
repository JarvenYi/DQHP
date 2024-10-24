set -e

## train text2sql-t5-large model
#python -u text2sql.py \
#    --batch_size 4 \
#    --gradient_descent_step 2 \
#    --device "0" \
#    --learning_rate 5e-5 \
#    --epochs 64 \
#    --seed 42 \
#    --save_path "./models/DQHP-large/Extra-hard" \
#    --tensorboard_save_path "./tensorboard_log/DQHP/Extra-hard_refined_hardness_text2sql_large" \
#    --model_name_or_path "./models/text2sql-t5-large/checkpoint-30576" \
#    --use_adafactor \
#    --mode train \
#    --train_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness/Extra-hard_refined_hardness_train_dataset.json" \
#    --output "./predictions/Extra-hard_predicted_sql.txt"

# generate spider hardness dataset
python -u generate_hardness_text2sql_dev_data.py \
    --save_path "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Extra-hard_spider_dev_dataset.json" \
    --input_resd_hardness_file "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Extra-hard_refined_hardness_dev_dataset.json" \
    --input_spider_file "./data/spider/dev.json"

# select the best text2sql-t5-large ckpta
python -u evaluate_text2sql_ckpts.py \
    --batch_size 4 \
    --device "0" \
    --seed 42 \
    --save_path "./models/DQHP-large/Extra-hard" \
    --eval_results_path "./eval_results/DQHP-large-Extra-hard" \
    --mode eval \
    --dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Extra-hard_refined_hardness_dev_dataset.json" \
    --original_dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Extra-hard_spider_dev_dataset.json" \
    --db_path "./database" \
    --num_beams 8 \
    --num_return_sequences 8 \
    --target_type "sql" \
    --output "./predictions/Extra-hard_DQHP_large_predicted_sql.txt"