set -e

## train text2sql-t5-large model
#python -u text2sql.py \
#    --batch_size 4 \
#    --gradient_descent_step 2 \
#    --device "1" \
#    --learning_rate 5e-5 \
#    --epochs 64 \
#    --seed 42 \
#    --save_path "./models/DQCP-large+NatSQL/Hard" \
#    --tensorboard_save_path "./tensorboard_log/DQCP/Hard_resd_hardness_text2natsql_RESD_large" \
#    --model_name_or_path "./models/text2natsql-t5-large/checkpoint-21216" \
#    --use_adafactor \
#    --mode train \
#    --train_filepath "./data/preprocessed_data/preprocessed_by_resd_hardness_with_prob_natsql(2)/Hard_resd_hardness_train_dataset.json" \
#    --output "Hard_DQCP_large_predicted_natsql.txt"


## generate spider hardness dataset
#python -u generate_hardness_text2sql_dev_data.py \
#    --save_path "./data/preprocessed_data/preprocessed_by_resd_hardness_with_prob_natsql/Hard_spider_dev_dataset.json" \
#    --input_resd_hardness_file "./data/preprocessed_data/preprocessed_by_resd_hardness_with_prob_natsql/Hard_resd_hardness_dev_dataset.json" \
#    --input_spider_file "./data/spider/dev.json"

# select the best text2sql-t5-large ckpta
python -u evaluate_text2sql_ckpts.py \
    --batch_size 4 \
    --device "1" \
    --seed 42 \
    --save_path "./models/DQCP-large+NatSQL/Hard" \
    --eval_results_path "./eval_results/DQCP-large+NatSQL-Hard" \
    --mode eval \
    --dev_filepath "./data/preprocessed_data/preprocessed_by_resd_hardness_with_prob_natsql(2)/Hard_resd_hardness_dev_dataset.json" \
    --original_dev_filepath "./data/preprocessed_data/preprocessed_by_resd_hardness_with_prob_natsql(2)/Hard_spider_dev_dataset.json" \
    --db_path "./database" \
    --tables_for_natsql "./data/preprocessed_data/tables_for_natsql.json" \
    --num_beams 8 \
    --num_return_sequences 8 \
    --target_type "natsql" \
    --output "Hard_DQCP_large_predicted_natsql.txt"