set -e

python -u evaluate_total.py \
    --easy_model_sql './prediction/Easy_DQHP_3B_predicted_sql.txt' \
    --medium_model_sql './prediction/Medium_DQHP_3B_predicted_sql.txt' \
    --hard_model_sql './prediction/Hard_DQHP_3B_predicted_sql.txt' \
    --extra_hard_model_sql './prediction/Extra-hard_DQHP_3B_predicted_sql.txt' \
    --easy_original_dev_filepath './data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Easy_spider_dev_dataset.json' \
    --medium_original_dev_filepath './data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Medium_spider_dev_dataset.json' \
    --hard_original_dev_filepath './data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Hard_spider_dev_dataset.json' \
    --extra_original_dev_filepath './data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Extra-hard_spider_dev_dataset.json' \
    --db_path './database'