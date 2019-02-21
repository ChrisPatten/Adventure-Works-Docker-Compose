#! /bin/sh

# Set up variables
SQL_USER=sa
SQL_PASS=password-1234

# Wait for SQL Server to come up
sleep 20s

# Database importer function
import_db (){
    SOURCE_PATH="$SOURCE_PATH_BASE/$1.bak"
    LOCAL_FILEPATH="/var/opt/mssql/data"
    # Check if .bak file already exists. If not, download it
    if [ ! -e "/setup/$1.bak" ]
    then
        wget -P /setup $SOURCE_PATH
    fi
    # Buld DB restore query
    QUERY="RESTORE DATABASE [$1] FROM DISK='/setup/$1.bak' WITH"
    # Set up DB specific queries
    if [ "$1" = "WideWorldImporters-Full" ]
    then
        QUERY="$QUERY MOVE 'WWI_Primary' TO '$LOCAL_FILEPATH/$1.mdf'"
        QUERY="$QUERY, MOVE 'WWI_Log' TO '$LOCAL_FILEPATH/$1_log.mdf'"
        QUERY="$QUERY, MOVE 'WWI_UserData' TO '$LOCAL_FILEPATH/$1_UserData.ndf'"
        QUERY="$QUERY, MOVE 'WWI_InMemory_Data_1' TO '$LOCAL_FILEPATH/$1_InMemory_Data_1'"
    elif [ "$1" = "WideWorldImportersDW-Full" ]
    then
        QUERY="$QUERY MOVE 'WWI_Primary' TO '$LOCAL_FILEPATH/$1.mdf'"
        QUERY="$QUERY, MOVE 'WWI_Log' TO '$LOCAL_FILEPATH/$1_log.mdf'"
        QUERY="$QUERY, MOVE 'WWI_UserData' TO '$LOCAL_FILEPATH/$1_UserData.ndf'"
        QUERY="$QUERY, MOVE 'WWIDW_InMemory_Data_1' TO '$LOCAL_FILEPATH/$1_InMemory_Data_1'"
    else
        QUERY="$QUERY MOVE '$1' TO '$LOCAL_FILEPATH/$1.mdf'"
        QUERY="$QUERY, MOVE '$1_log' TO '$LOCAL_FILEPATH/$1_log.mdf'"
    fi
    # Run SQL
    /opt/mssql-tools/bin/sqlcmd \
        -S localhost \
        -U $SQL_USER -P $SQL_PASS \
        -Q "$QUERY"
}

# Database presence checker function
db_exists (){
    QUERY="SET NOCOUNT ON; SELECT COUNT(*) FROM dbo.sysdatabases"
    QUERY="$QUERY WHERE [name] = '$1'"
    /opt/mssql-tools/bin/sqlcmd \
        -S localhost \
        -U $SQL_USER -P $SQL_PASS \
        -Q "$QUERY" \
        -h -1 \
        | grep -q "1"
}

check_for_db (){
    if $(db_exists $1)
    then
        echo "$1 already exists!"
    else
        echo "Restore $1"
        import_db $1
    fi
}

setup_adventureworks (){
    SOURCE_PATH_BASE="https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks"
    if [ "$DB_TYPE" = "oltp" ]
    then
        check_for_db AdventureWorks2017
    elif [ "$DB_TYPE" = "dw" ]
    then
        check_for_db AdventureWorksDW2017
    else
        check_for_db AdventureWorks2017
        check_for_db AdventureWorksDW2017
    fi
}

setup_wideworld (){
    SOURCE_PATH_BASE="https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0"
    if [ "$DB_TYPE" = "oltp" ]
    then
        check_for_db WideWorldImporters-Full
    elif [ "$DB_TYPE" = "dw" ]
    then
        check_for_db WideWorldImportersDW-Full
    else
        check_for_db WideWorldImporters-Full
        check_for_db WideWorldImportersDW-Full
    fi
}

# Check or create databases
if [ "$SEED_DATA" = "adventure" ]
then
    setup_adventureworks
elif [ "$SEED_DATA" = "wideworld" ]
then
    setup_wideworld
elif [ "$SEED_DATA" = "all" ]
then
    setup_adventureworks
    setup_wideworld
else
    echo "Set SEED_DATA environment variable to create databases"
fi