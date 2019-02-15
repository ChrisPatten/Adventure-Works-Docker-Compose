# Adventure Works Docker Compose
A Docker Compose application running SQL Server with the Adventure Works OLTP and Adventure Works DW databases.

# Getting Started
Clone the repository, then navigate to the directory in your command line tool of choice and run `docker-compose up`. The image, based on the official SQL Server 2017 image, will automatically download the latest AdventureWorks2017 and AdventureWorksDW2017 database backups from [Microsoft's GitHub repository](https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks). On first run (or whenever the databases are removed) the backups will be automatically restored.

# Connecting
Using your SQL client of choice, connect to server `localhost` using SQL authentication, username `sa`, password `password-1234`.