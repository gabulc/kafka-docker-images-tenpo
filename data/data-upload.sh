#!/usr/bin/env bash


KAGGLE_DATASET="mattiuzc/stock-exchange-data"
DATASET_DIR="dataset"
DATASET_ZIP="${KAGGLE_DATASET##*/}.zip" # removing text before '/'
UPLOAD_FILE="./${DATASET_DIR}/indexData.csv"
DELIMITER=","
ENCODING="UTF8"

PG_HOST="the-host"
PG_PORT=5432
DB_NAME="testing"
DB_USER="ops"
DB_TABLE_NAME="public.stock_exchange"
PSQL_CONN="host=${PG_HOST} port=${PG_PORT} dbname=${DB_NAME} user=${DB_USER}"


# Create table
psql "$PSQL_CONN" -c << EOF
  CREATE TABLE ${DB_TABLE_NAME}(
    col1 int8,
    col2 varchar(50) NULL,
    t timestamptz NULL
  );
EOF

# Download Kaggle dataset
kaggle datasets download -d "$KAGGLE_DATASET" -p "$(pwd)" # download in cur dir
./unzip.py -t $DATASET_DIR $DATASET_ZIP

# Import csv
PSQL_CMD="\\COPY ${DB_TABLE_NAME} FROM '${UPLOAD_FILE}' WITH CSV "
PSQL_CMD+="DELIMITER '${DELIMITER}' HEADER "
PSQL_CMD+="ENCODING '${ENCODING}'"
psql "$PSQL_CONN" -c "$PSQL_CMD"

echo "Finished!"
