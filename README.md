# POSExceptionsGraphReports

POS (Point of Sale) Graphical Reports of Exceptions by Dates/Users/Exceptions.
	
	unzip "POSExceptionsGraphReports.zip" file;

1.	run "/SQL/INIT_POSExceptionsGraphReports_Data_v_2.0.4.8_.sql" first;

	for create database, tables, and populate data;

2.	run "/SQL/SQL_POSExceptionsGraphReports_v_2.0.4.8_.sql";

	for create functions and stored procedures;

3.	copy/paste folder POSExceptionsGraphReports into "C:\inetpub\wwwroot".

4.	add website and specify Physical path as "C:\inetpub\wwwroot\POSExceptionsGraphReports";

	(don't forget IIS_IUSERS permission) -Application Pools: "POSExceptionsGraphReports": Identity: "NetworkService",

5.	SQL Server: "NT AUTHORITY\IUSR" and "NT AUTHORITY\NETWORK SERVICE" should be added to database "storekeeper_demo" Security/Users
	use default password and dates from/to; 
	
	pls. see pictures in "/_UI_picture" folder;

---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   
	Web.config file

	specify following:
	<add key="SITE_LOCATION" value="site location here"/>
	<add name="dbconnection" connectionString="Data Source=DESKTOP-SUVI0CH\SQLEXPRESS02;Initial Catalog=storekeeper_TEST;Integrated Security=True;" providerName="System.Data.SqlClient"/>
;
---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   


