set -e

device="0"

if [ $1 = "base" ]
then
    Easy_DQHP_model_save_path="./models/DQHP-base/Easy"
    Medium_DQHP_model_save_path="./models/DQHP-base/Medium"
    Hard_DQHP_model_save_path="./models/DQHP-base/Hard"
    Extra_hard_DQHP_model_save_path="./models/DQHP-base/Extra-hard"
    text2sql_model_bs=8
elif [ $1 = "large" ]
then
    Easy_DQHP_model_save_path="./models/DQHP-large/Easy"
    Medium_DQHP_model_save_path="./models/DQHP-large/Medium"
    Hard_DQHP_model_save_path="./models/DQHP-large/Hard"
    Extra_hard_DQHP_model_save_path="./models/DQHP-large/Extra-hard"
    text2sql_model_bs=4
elif [ $1 = "3b" ]
then
    Easy_DQHP_model_save_path="./models/DQHP-3B/Easy"
    Medium_DQHP_model_save_path="./models/DQHP-3B/Medium"
    Hard_DQHP_model_save_path="./models/DQHP-3B/Hard"
    Extra_hard_DQHP_model_save_path="./models/DQHP-3B/Extra-hard"
    text2sql_model_bs=1
else
    echo "The first arg must in [base, large, 3b]."
    exit
fi

model_name="DQHPsql_$1_sql"

if [ $2 = "spider" ]
then
    # spider's dev set
    table_path="./data/spider/tables.json"
    input_dataset_path="./data/spider/dev.json"
    db_path="./database"
    output="./predictions/Spider-dev/$model_name/pred.sql"
elif [ $2 = "spider-realistic" ]
then
    # spider-realistic
    table_path="./data/spider/tables.json"
    input_dataset_path="./data/spider-realistic/spider-realistic.json"
    db_path="./database"
    output="./predictions/spider-realistic/$model_name/pred.sql"
    if [ $1 = "3b" ]
    then
        text2sql_model_save_path="./models/text2sql-t5-3b/checkpoint-61642"
    fi
elif [ $2 = "spider-syn" ]
then
    # spider-syn
    table_path="./data/spider/tables.json"
    input_dataset_path="./data/spider-syn/dev_syn.json"
    db_path="./database"
    output="./predictions/spider-syn/$model_name/pred.sql"
elif [ $2 = "spider-dk" ]
then
    # spider-dk
    table_path="./data/spider-dk/tables.json"
    input_dataset_path="./data/spider-dk/Spider-DK.json"
    db_path="./database"
    output="./predictions/spider-dk/$model_name/pred.sql"
elif [ $2 = "DB_DBcontent_equivalence" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/DB_DBcontent_equivalence/tables_post_perturbation.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/DB_DBcontent_equivalence/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/DB_DBcontent_equivalence/database_post_perturbation"
    output="./predictions/DB_DBcontent_equivalence/$model_name/pred.sql"
elif [ $2 = "DB_schema_abbreviation" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/DB_schema_abbreviation/tables_post_perturbation.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/DB_schema_abbreviation/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/DB_schema_abbreviation/database_post_perturbation"
    output="./predictions/DB_schema_abbreviation/$model_name/pred.sql"
elif [ $2 = "DB_schema_synonym" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/DB_schema_synonym/tables_post_perturbation.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/DB_schema_synonym/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/DB_schema_synonym/database_post_perturbation"
    output="./predictions/DB_schema_synonym/$model_name/pred.sql"
elif [ $2 = "NLQ_column_attribute" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_attribute/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_attribute/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_attribute/databases"
    output="./predictions/NLQ_column_attribute/$model_name/pred.sql"
elif [ $2 = "NLQ_column_carrier" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_carrier/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_carrier/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_carrier/databases"
    output="./predictions/NLQ_column_carrier/$model_name/pred.sql"
elif [ $2 = "NLQ_column_synonym" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_synonym/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_synonym/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_synonym/databases"
    output="./predictions/NLQ_column_synonym/$model_name/pred.sql"
elif [ $2 = "NLQ_column_value" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_value/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_value/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_column_value/databases"
    output="./predictions/NLQ_column_value/$model_name/pred.sql"
elif [ $2 = "NLQ_keyword_carrier" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_keyword_carrier/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_keyword_carrier/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_keyword_carrier/databases"
    output="./predictions/NLQ_keyword_carrier/$model_name/pred.sql"
elif [ $2 = "NLQ_keyword_synonym" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_keyword_synonym/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_keyword_synonym/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_keyword_synonym/databases"
    output="./predictions/NLQ_keyword_synonym/$model_name/pred.sql"
elif [ $2 = "NLQ_multitype" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_multitype/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_multitype/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_multitype/databases"
    output="./predictions/NLQ_multitype/$model_name/pred.sql"
elif [ $2 = "NLQ_others" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_others/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_others/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_others/databases"
    output="./predictions/NLQ_others/$model_name/pred.sql"
elif [ $2 = "NLQ_value_synonym" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_value_synonym/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_value_synonym/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/NLQ_value_synonym/databases"
    output="./predictions/NLQ_value_synonym/$model_name/pred.sql"
elif [ $2 = "SQL_comparison" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/SQL_comparison/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/SQL_comparison/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/SQL_comparison/databases"
    output="./predictions/SQL_comparison/$model_name/pred.sql"
elif [ $2 = "SQL_DB_number" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/SQL_DB_number/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/SQL_DB_number/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/SQL_DB_number/databases"
    output="./predictions/SQL_DB_number/$model_name/pred.sql"
elif [ $2 = "SQL_DB_text" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/SQL_DB_text/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/SQL_DB_text/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/SQL_DB_text/databases"
    output="./predictions/SQL_DB_text/$model_name/pred.sql"
elif [ $2 = "SQL_NonDB_number" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/SQL_NonDB_number/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/SQL_NonDB_number/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/SQL_NonDB_number/databases"
    output="./predictions/SQL_NonDB_number/$model_name/pred.sql"
elif [ $2 = "SQL_sort_order" ]
then
    table_path="./data/diagnostic-robustness-text-to-sql/data/SQL_sort_order/tables.json"
    input_dataset_path="./data/diagnostic-robustness-text-to-sql/data/SQL_sort_order/questions_post_perturbation.json"
    db_path="./data/diagnostic-robustness-text-to-sql/data/SQL_sort_order/databases"
    output="./predictions/SQL_sort_order/$model_name/pred.sql"
else
    echo "The second arg must in [spider, spider-realistic, spider-syn, spider-dk, DB_schema_synonym, DB_schema_abbreviation, DB_DBcontent_equivalence, NLQ_keyword_synonym, NLQ_keyword_carrier, NLQ_column_synonym, NLQ_column_carrier, NLQ_column_attribute, NLQ_column_value, NLQ_value_synonym, NLQ_multitype, NLQ_others, SQL_comparison, SQL_sort_order, SQL_NonDB_number, SQL_DB_text, SQL_DB_number]."
    exit
fi

# preprocess test set
python preprocessing.py \
    --mode "eval" \
    --table_path $table_path \
    --input_dataset_path $input_dataset_path \
    --output_dataset_path "./data/preprocessed_data/preprocessed_dev.json" \
    --db_path $db_path \
    --target_type "sql"

# predict probability for each schema item in the test set
python schema_item_classifier.py \
    --batch_size 16 \
    --device $device \
    --seed 42 \
    --save_path "./models/schema_items_sql" \
    --dev_filepath "./data/preprocessed_data/preprocessed_dev.json" \
    --output_filepath "./data/preprocessed_data/dev_with_probs.json" \
    --use_contents \
    --add_fk_info \
    --mode "eval"

# generate text2natsql test set for hardness classifier
python text2sql_data_generator.py \
    --input_dataset_path "./data/preprocessed_data/dev_with_probs.json" \
    --output_dataset_path "./data/preprocessed_data/refined_dev.json" \
    --topk_table_num 4 \
    --topk_column_num 5 \
    --mode "eval" \
    --use_contents \
    --add_fk_info \
    --output_skeleton \
    --target_type "sql"

# generate text2natsql test set
python hardness_classifier.py \
    --batch_size 8 \
    --device "0" \
    --seed 42 \
    --save_path "./models/text2sql_hardness_classifier_Jarven/RoBerta-large/4Linear" \
    --dev_filepath "./data/preprocessed_data/refined_dev.json" \
    --output_filepath "./data/preprocessed_data/hardness_dev_with_probs.json" \
    --use_contents \
    --resd_preprocessed \
    --mode "eval"

python separate_dataset_by_hardness_labels.py \
    --input_dir "./data/preprocessed_data/hardness_dev_with_probs.json" \
    --output_dir "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob" \
    --mode dev

# generate spider hardness dataset
# Easy
python -u generate_hardness_text2sql_dev_data.py \
    --save_path "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Easy_spider_dev_dataset.json" \
    --input_resd_hardness_file "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Easy_refined_hardness_dev_dataset.json" \
    --input_spider_file $input_dataset_path

# select the best Easy ckpta
python -u evaluate_text2sql_ckpts.py \
    --batch_size $text2sql_model_bs \
    --device $device \
    --seed 42 \
    --save_path $Easy_DQHP_model_save_path \
    --eval_results_path "./eval_results/DQHP-3B-Easy" \
    --mode eval \
    --dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Easy_refined_hardness_dev_dataset.json" \
    --original_dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Easy_spider_dev_dataset.json" \
    --db_path $db_path \
    --num_beams 8 \
    --num_return_sequences 8 \
    --target_type "sql" \
    --output "./prediction/Easy_DQHP_3B_predicted.txt"

# Medium
python -u generate_hardness_text2sql_dev_data.py \
    --save_path "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Medium_spider_dev_dataset.json" \
    --input_resd_hardness_file "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Medium_refined_hardness_dev_dataset.json" \
    --input_spider_file $input_dataset_path

# select the best text2sql-t5-large ckpta
python -u evaluate_text2sql_ckpts.py \
    --batch_size $text2sql_model_bs \
    --device $device \
    --seed 42 \
    --save_path $Medium_DQHP_model_save_path \
    --eval_results_path "./eval_results/DQHP-3B-Medium" \
    --mode eval \
    --dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Medium_refined_hardness_dev_dataset.json" \
    --original_dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Medium_spider_dev_dataset.json" \
    --db_path $db_path \
    --num_beams 8 \
    --num_return_sequences 8 \
    --target_type "sql" \
    --output "./prediction/Medium_DQHP_3B_predicted.txt"

# Hard
python -u generate_hardness_text2sql_dev_data.py \
    --save_path "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Hard_spider_dev_dataset.json" \
    --input_resd_hardness_file "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Hard_refined_hardness_dev_dataset.json" \
    --input_spider_file $input_dataset_path

# select the best text2sql-t5-large ckpta
python -u evaluate_text2sql_ckpts.py \
    --batch_size $text2sql_model_bs \
    --device $device \
    --seed 42 \
    --save_path $Hard_DQHP_model_save_path \
    --eval_results_path "./eval_results/DQHP-3B-Hard" \
    --mode eval \
    --dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Hard_refined_hardness_dev_dataset.json" \
    --original_dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Hard_spider_dev_dataset.json" \
    --db_path $db_path \
    --num_beams 8 \
    --num_return_sequences 8 \
    --target_type "sql" \
    --output "./prediction/Hard_DQHP_3B_predicted.txt"

# Extra-hard
python -u generate_hardness_text2sql_dev_data.py \
    --save_path "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Extra-hard_spider_dev_dataset.json" \
    --input_resd_hardness_file "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Extra-hard_refined_hardness_dev_dataset.json" \
    --input_spider_file $input_dataset_path

# select the best text2sql-t5-large ckpta
python -u evaluate_text2sql_ckpts.py \
    --batch_size $text2sql_model_bs \
    --device $device \
    --seed 42 \
    --save_path $Extra_hard_DQHP_model_save_path \
    --eval_results_path "./eval_results/DQHP-3B-Extra-hard" \
    --mode eval \
    --dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Extra-hard_refined_hardness_dev_dataset.json" \
    --original_dev_filepath "./data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Extra-hard_spider_dev_dataset.json" \
    --db_path $db_path \
    --num_beams 8 \
    --num_return_sequences 8 \
    --target_type "sql" \
    --output "./prediction/Extra-hard_DQHP_3B_predicted.txt"

#Evaluation
python -u evaluate_total.py \
    --easy_model_sql './prediction/Easy_DQHP_3B_predicted.txt' \
    --medium_model_sql './prediction/Medium_DQHP_3B_predicted.txt' \
    --hard_model_sql './prediction/Hard_DQHP_3B_predicted.txt' \
    --extra_hard_model_sql './prediction/Extra-hard_DQHP_3B_predicted.txt' \
    --easy_original_dev_filepath './data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Easy_spider_dev_dataset.json' \
    --medium_original_dev_filepath './data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Medium_spider_dev_dataset.json' \
    --hard_original_dev_filepath './data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Hard_spider_dev_dataset.json' \
    --extra_original_dev_filepath './data/preprocessed_data/preprocessed_by_refined_hardness_with_prob/Extra-hard_spider_dev_dataset.json' \
    --db_path $db_path

