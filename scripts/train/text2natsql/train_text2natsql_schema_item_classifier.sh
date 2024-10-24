set -e

# train schema item classifier  modify: *** batch_size 16->8 , I should modify the epochs to 256, but I do not.
# --easy_model_save_path: "./models/text2natsql_schema_item_classifier" ->"./models/text2natsql_schema_item_classifier_By_Jarven"
# --epochs 128 -> 64
python -u schema_item_classifier.py \
    --batch_size 8 \
    --gradient_descent_step 2 \
    --device "0,1" \
    --learning_rate 1e-5 \
    --gamma 2.0 \
    --alpha 0.75 \
    --epochs 64 \
    --patience 16 \
    --seed 42 \
    --save_path "./models/text2natsql_schema_item_classifier_Jarven" \
    --tensorboard_save_path "./tensorboard_log/text2natsql_schema_item_classifier" \
    --train_filepath "./data/preprocessed_data/preprocessed_train_spider_natsql.json" \
    --dev_filepath "./data/preprocessed_data/preprocessed_dev_natsql.json" \
    --model_name_or_path "roberta-large" \
    --use_contents \
    --mode "train"