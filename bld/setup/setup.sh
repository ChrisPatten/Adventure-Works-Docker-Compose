#! /bin/sh

# Set up variables
SQL_USER=sa
SQL_PASS=password-1234

# Wait for SQL Server to come up
sleep 20s

# Database importer function
import_db (){
    QUERY="RESTORE DATABASE [$1] FROM DISK='/setup/$1.bak' WITH"
    QUERY="$QUERY MOVE '$1' TO '/var/opt/mssql/data/$1.mdf',"
    QUERY="$QUERY MOVE '$1_log' TO '/var/opt/mssql/data/$1_log.mdf'"
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

# Check or create databases
check_for_db AdventureWorks2017
check_for_db AdventureWorksDW2017
