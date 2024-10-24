# Decoupling SQL Query Hardness Parsing for Text-to-SQL
### Environment Setup, Spider 1.0 Dataset, and Model Download
Environment: Python 3.8, Torch 1.11.0, CUDA 12.4, and related dependencies specified in requirements.txt.

## 1. Training DQHP
### Preprocessing
Execute the following terminal command in the corresponding location: \
`sh ./scripts/train/text2sql/preprocess.sh`\
Output:\
Training data: "./data/preprocessed_data/preprocessed_train_spider.json" \
Validation data: "./data/preprocessed_data/preprocessed_dev.json" 
### Training Schema Ranker
Execute the terminal command: \
`sh ./scripts/train/text2sql/train_text2sql_schema_item_classifier.sh` \
This will generate the schema ranker model at "./models/text2sql_schema_item_sql".

### Obtaining Refined Schema via Schema Ranker
Execute the terminal command: \
`sh ./scripts/train/text2sql/generate_text2sql_dataset.sh` \
Output: \
Refined schema for training: "./data/preprocessed_data/refined_train_spider.json" \
Refined schema for validation: "./data/preprocessed_data/refined_dev.json" 
### Training Hardness Classifier
Execute the terminal command: \
`sh ./scripts/train/text2sql/train_text2sql_hardness_classifier.sh` \
This will generate the hardness classifier model at "./models/text2sql_hardness_classifier_Jarven/RoBerta-large/4Linear".

### Obtaining Hardness Labels via Hardness Classifier
Execute the terminal command: \
`sh ./scripts/train/text2sql/generate_hardness_data_generator.sh` \
Identify the hardness of dev data and divide it into four datasets based on hardness.

### Two-stage Training and Testing of SQL Generator
Execute the following terminal commands separately to train and test the four distributed generators: 
#### Base Scale One-stage:
`sh scripts/train/text2sql/train_text2sql_base.sh` \
This generates the initial model parameters $I_m$.

#### Two-stage: Based on $I_m$, train on samples of different hardness:
`sh scripts/train/text2sql/train_DQHP_text2sql_t5_base_Easy.sh` \
`sh scripts/train/text2sql/train_DQHP_text2sql_t5_base_Medium.sh` \
`sh scripts/train/text2sql/train_DQHP_text2sql_t5_base_Hard.sh` \
`sh scripts/train/text2sql/train_DQHP_text2sql_t5_base_Extra.sh` \
This yields four models of the Distributed Generator, $I_1, I_2, I_3, I_4$, and outputs: Evaluation metrics EM and EX for each model on the Spider dev set.

### Overall Testing
Execute the code: \
`sh ./scripts/train/text2sql/evaluator_total.sh` \
Output: Overall EM and EX metrics for DQHP and for each hardness sample.

__NOTE: If you encounter an error IndexError: list index out of range, please delete the record in the corresponding folder in `./eval_results/.`__

__NOTE: The training process for DQHP+NatSQL is identical to the above. Use the corresponding code in `./scripts/train/text2natsql/`__

# 2. Validating DQHP
Execute the terminal command: \
`sh ./scripts/inference/text2sql.sh scale_level spider` \
or \
`sh ./scripts/inference/text2natsql.sh scale_level spider` \
where `scale_level` can be selected from `base`, `large`, or `3b`.
