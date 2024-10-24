set -e

## train text2sql-t5-large model
#python -u text2sql.py \
#    --batch_size 1 \
#    --gradient_descent_step 2 \
#    --device "1" \
#    --learning_rate 5e-5 \
#    --epochs 1 \
#    --seed 42 \
#    --save_path "./models/DQCP-3B/Extra-hard" \
#    --tensorboard_save_path "./tensorboard_log/DQCP/Extra-hard_DQCP_3B" \
#    --model_name_or_path "./model/text2sql-t5-3b/checkpoint-103292" \
#    --use_adafactor \
#    --mode train \
#    --train_filepath "./data/preprocessed_data/preprocessed_by_resd_hardness/Extra-hard_resd_hardness_train_dataset.json" \
#    --output "Extra-hard_predicted_sql.txt"

## generate spider hardness dataset
#python -u generate_hardness_text2sql_dev_data.py \
#    --save_path "./data/preprocessed_data/preprocessed_by_resd_hardness_with_prob/Extra-hard_spider_dev_dataset.json" \
#    --input_resd_hardness_file "./data/preprocessed_data/preprocessed_by_resd_hardness_with_prob/Extra-hard_resd_hardness_dev_dataset.json" \
#    --input_spider_file "./data/spider/dev.json"

# select the best text2sql-t5-large ckpta
python -u evaluate_text2sql_ckpts.py \
    --batch_size 1 \
    --device "1" \
    --seed 42 \
    --save_path "./models/DQCP-3B/Extra-hard" \
    --eval_results_path "./eval_results/DQCP-3B-Extra-hard" \
    --mode eval \
    --dev_filepath "./data/preprocessed_data/preprocessed_by_resd_hardness_with_prob/Extra-hard_resd_hardness_dev_dataset.json" \
    --original_dev_filepath "./data/preprocessed_data/preprocessed_by_resd_hardness_with_prob/Extra-hard_spider_dev_dataset.json" \
    --db_path "./database" \
    --num_beams 8 \
    --num_return_sequences 8 \
    --target_type "sql" \
    --output "Extra-hard_DQCP_3B_predicted_sql.txt"