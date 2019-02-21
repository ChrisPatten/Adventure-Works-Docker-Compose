# Adventure Works Docker Compose
A Docker Compose application running SQL Server Linux with the Adventure Works OLTP, Adventure Works DW, Wide World Importers OLTP, and Wide World Importers DW databases.

# Getting Started
Clone the repository, then navigate to the directory in your command line tool of choice and run `docker-compose up`. The image, based on the official SQL Server 2017 image, will automatically download the latest [AdventureWorks2017 and AdventureWorksDW2017 database backups](https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks) and [WideWorldImporters-Full and WideWorldImportersDW-Full database backups](https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0). On first run (or whenever the databases are removed) the backups will be automatically restored.

# Configuration
Pick and choose which databases are restored by modifying `docker-compose.yml` and changing the values of `SEED_DATA` and `DB_TYPE` variables.

|  | AdventureWorks2017 | AdventureWorksDW2017 | WideWorldImporters-Full | WideWorldImportersDW-Full |
|----------------------------------|--------------------|----------------------|-------------------------|---------------------------|
| SEED_DATA=adventure DB_TYPE=oltp | ✔ |  |  |  |
| SEED_DATA=adventure DB_TYPE=dw |  | ✔ |  |  |
| SEED_DATA=adventure DB_TYPE=all | ✔ | ✔ |  |  |
| SEED_DATA=wideworld DB_TYPE=oltp |  |  | ✔ |  |
| SEED_DATA=wideworld DB_TYPE=dw |  |  |  | ✔ |
| SEED_DATA=wideworld DB_TYPE=all |  |  | ✔ | ✔ |
| SEED_DATA=all DB_TYPE=oltp | ✔ |  | ✔ |  |
| SEED_DATA=all DB_TYPE=dw |  | ✔ |  | ✔ |
| SEED_DATA=all DB_TYPE=all | ✔ | ✔ | ✔ | ✔ |

# Connecting
Using your SQL client of choice, connect to server `localhost` using SQL authentication, username `sa`, password `password-1234`.