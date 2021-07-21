#!/usr/bin/env bash


KAGGLE_DATASET="mattiuzc/stock-exchange-data"
DATASET_DIR="dataset"
DATASET_ZIP="${KAGGLE_DATASET##*/}.zip" # removing text before '/'
UPLOAD_FILE="./${DATASET_DIR}/indexData.csv"
DELIMITER=","
ENCODING="UTF8"

PG_HOST="34.228.242.241"
PG_PORT=5432
DB_NAME="clq"
DB_USER="cdc_user"
DB_PWD="${DB_PWD:-default}"
DB_TABLE_NAME="ods.stock_exchange"
PSQL_CONN="host=${PG_HOST} port=${PG_PORT} dbname=${DB_NAME} user=${DB_USER} password=${DB_PWD}"


# Download Kaggle dataset
echo "Downloading dataset."
kaggle datasets download -d "$KAGGLE_DATASET" -p "$(pwd)" # download in cur dir
./unzip.py -t $DATASET_DIR $DATASET_ZIP


# Create table
echo "Creating table."
psql "$PSQL_CONN" <<EOF
  DROP TABLE IF EXISTS ${DB_TABLE_NAME};
  CREATE TABLE ${DB_TABLE_NAME}(
    "index" varchar(10),
    "date" date,
    "open" float null,
    high float null,
    low float null,
    "close" float null,
    adj_close float null,
    volume float null
  );
EOF


# Import csv
echo "Uploading to postgres."
PSQL_CMD="\\COPY ${DB_TABLE_NAME} FROM '${UPLOAD_FILE}' WITH CSV "
PSQL_CMD+="DELIMITER '${DELIMITER}' HEADER "
PSQL_CMD+="ENCODING '${ENCODING}'"
PSQL_CMD+="NULL AS 'null'"
psql "$PSQL_CONN" -c "$PSQL_CMD"


echo "Finished!"
