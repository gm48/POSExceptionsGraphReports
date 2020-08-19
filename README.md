# POSExceptionsGraphReports
POS (Point of Sale) Graphical Reports of Exceptions by Dates/Users/Exceptions;

1. run SQL/INIT_POSExceptionsGraphReports_Data_v_2.0.4.8_.sql first
  *create database, tables, and populate data;

2. run SQL/SQL_POSExceptionsGraphReports_v_2.0.4.8_.sql;
  *create functions and stored procedures;
  
3. copy/paste folder POSExceptionsGraphReports into "C:\inetpub\wwwroot";

4. add website and specify Physical path as "C:\inetpub\wwwroot\POSExceptionsGraphReports";
  * don't forget IIS_IUSERS permission;
  * Application Pools (POSExceptionsGraphReports): Identity: "NetworkService",

5. SQL Server: "NT AUTHORITY\IUSR" and "NT AUTHORITY\NETWORK SERVICE" should be added to database "storekeeper_demo" Security/Users

all set;
** use default password and dates from/to;
pls. see pictures in POSExceptionsGraphReports/_UI_pictures folder

;
