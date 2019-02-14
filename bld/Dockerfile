FROM mcr.microsoft.com/mssql/server:2017-latest
ENV ACCEPT_EULA Y
ENV SA_PASSWORD password-1234
WORKDIR /setup
COPY ./setup .
RUN chmod +x entrypoint.sh
RUN chmod +x setup.sh
RUN wget https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak
RUN wget https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2017.bak
CMD /bin/bash ./entrypoint.sh
