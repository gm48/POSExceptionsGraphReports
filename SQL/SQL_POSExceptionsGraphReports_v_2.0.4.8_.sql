

------------------------------------------  ++++++++++++++  ----------------------------------------------
------------------------------------------  ++++++++++++++  ----------------------------------------------
USE [storekeeper_demo]
GO
------------------------------------------  ++++++++++++++  ----------------------------------------------
 
if object_id('dbo.__fnStrip') is not null drop function [dbo].[__fnStrip]
go
if object_id('dbo.__fnTimeSeq') is not null drop function [dbo].[__fnTimeSeq]
go
if object_id('dbo.__fnDTS') is not null drop function [dbo].[__fnDTS]
go
if object_id('dbo.__fnSplitString') is not null drop function [dbo].[__fnSplitString]
go
if object_id('dbo.__fnGetNumeric') is not null drop function [dbo].[__fnGetNumeric]
go
if object_id('dbo.__fnTimeRange') is not null drop function [dbo].[__fnTimeRange]
go
if object_id('dbo.__fnSeq') is not null drop function [dbo].[__fnSeq]
go
if object_id('dbo.__sp_POSExceptionsGraphReports') is not null drop procedure [dbo].[__sp_POSExceptionsGraphReports]
go
if object_id('dbo.__sp_ct_Daily_Average_By_DVR') is not null drop procedure [dbo].[__sp_ct_Daily_Average_By_DVR]
go
if object_id('dbo.__sp_ct_By_DVR_By_Hour') is not null drop procedure [dbo].[__sp_ct_By_DVR_By_Hour]
go
if object_id('dbo.__sp_ct_By_DVR_By_Date_Custom') is not null drop procedure [dbo].[__sp_ct_By_DVR_By_Date_Custom]
go
if object_id('dbo.__sp_ct_By_DVR_By_Date') is not null drop procedure [dbo].[__sp_ct_By_DVR_By_Date]
go
if object_id('dbo.__sp_ct_By_DVR') is not null drop procedure [dbo].[__sp_ct_By_DVR]
go
if object_id('dbo.__sp_ct_By_Date') is not null drop procedure [dbo].[__sp_ct_By_Date]
go
if object_id('dbo.__sp_ct_By_Cashier_By_Date_Custom') is not null drop procedure [dbo].[__sp_ct_By_Cashier_By_Date_Custom]
go
if object_id('dbo.__sp_ct_By_Cashier_By_Date') is not null drop procedure [dbo].[__sp_ct_By_Cashier_By_Date]
go
if object_id('dbo.__sp_ct_By_Cashier') is not null drop procedure [dbo].[__sp_ct_By_Cashier]
go
if object_id('dbo.__sp_DVR') is not null drop procedure [dbo].[__sp_DVR]
go
if object_id('dbo.__sp_CSHR') is not null drop procedure [dbo].[__sp_CSHR]
go
if object_id('dbo.__sp_URL') is not null drop procedure [dbo].[__sp_URL]
go
------------------------------------------  ++++++++++++++  ----------------------------------------------
USE [storekeeper_demo]
GO
------------------------------------------  ++++++++++++++  ----------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[__fnStrip](@nv nvarchar(64)) returns nvarchar(64)
as
begin
	declare @k as varchar(16) = '%[^a-z0-9, ]%';
	while patindex(@k, @nv) > 0 set @nv = stuff(@nv, patindex(@k, @nv), 1,'');
	return @nv
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[__fnTimeSeq]() returns @TimeSeq table(_time nvarchar(16), _seq tinyint)
as
begin
	insert into @TimeSeq (_time, _seq)
	values ('12AM - 1AM', 1),('1AM - 2AM', 2),('2AM - 3AM', 3),('3AM - 4AM', 4),('4AM - 5AM', 5),('5AM - 6AM', 6),('6AM - 7AM', 7),('7AM - 8AM', 8),('8AM - 9AM', 9),('9AM - 10AM', 10),('10AM - 11AM', 11),('11AM - 12AM', 12)
	,('12PM - 1PM', 13),('1PM - 2PM', 14),('2PM - 3PM', 15),('3PM - 4PM', 16),('4PM - 5PM', 17),('5PM - 6PM', 18),('6PM - 7PM', 19),('7PM - 8PM', 20),('8PM - 9PM', 21),('9PM - 10PM', 22),('10PM - 11PM', 23),('11PM - 12AM', 24);
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[__fnDTS] (@dt datetime) returns nvarchar(16) as begin return convert(nvarchar(16),cast(@dt as time),100); end;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[__fnGetNumeric] (@nv nvarchar(64)) returns int
as
begin

    declare @k as varchar(16) = '%[^0-9]%';
    while patindex(@k, @nv) > 0 set @nv = stuff(@nv, patindex(@k, @nv), 1,'');
    return cast(@nv as int);
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[__fnSplitString] (@string nvarchar(1024), @delimiter nchar(1)) returns @parts table(part nvarchar(64))
as
begin
    if @string is null return;
	set @string = replace(@string,'''', '');
    declare @start int, @pos int;
    if substring( @string, 1, 1 ) = @delimiter begin set @start = 2; insert into @parts values(null); end
    else set @start = 1;
    while 1=1
    begin
        set @pos = charindex(@delimiter,@string,@start);
        if @pos = 0 set @pos = len(@string)+1;
        if @pos - @start > 0 insert into @parts values (substring(@string, @start, @pos-@start));
        else insert into @parts values(null);
        set @start = @pos+1;
        if @start > len(@string) break;
    end
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[__fnTimeRange] (@time time(7)) returns nvarchar(16)
as
begin
return 
	case
		when @time >= '0:00AM' and  @time < '1:00AM' then '12AM - 1AM' 
		when @time >= '1:00AM' and  @time < '2:00AM' then '1AM - 2AM' 
		when @time >= '2:00AM' and  @time < '3:00AM' then '2AM - 3AM' 											  
		when @time >= '3:00AM' and  @time < '4:00AM' then '3AM - 4AM' 
		when @time >= '4:00AM' and  @time < '5:00AM' then '4AM - 5AM' 
		when @time >= '5:00AM' and  @time < '6:00AM' then '5AM - 6AM' 
		when @time >= '6:00AM' and  @time < '7:00AM' then '6AM - 7AM' 
		when @time >= '7:00AM' and  @time < '8:00AM' then '7AM - 8AM' 
		when @time >= '8:00AM' and  @time < '9:00AM' then '8AM - 9AM' 
		when @time >= '9:00AM' and  @time < '10:00AM' then '9AM - 10AM' 
		when @time >= '10:00AM' and @time < '11:00AM' then '10AM - 11AM' 
		when @time >= '11:00AM' and @time < '12:00PM' then '11AM - 12PM' 
		when @time >= '12:00PM' and @time < '1:00PM' then '12PM - 1PM' 
		when @time >= '1:00PM' and  @time < '2:00PM' then '1PM - 2PM' 
		when @time >= '2:00PM' and  @time < '3:00PM' then '2PM - 3PM' 
		when @time >= '3:00PM' and  @time < '4:00PM' then '3PM - 4PM' 
		when @time >= '4:00PM' and  @time < '5:00PM' then '4PM - 5PM' 
		when @time >= '5:00PM' and  @time < '6:00PM' then '5PM - 6PM' 
		when @time >= '6:00PM' and  @time < '7:00PM' then '6PM - 7PM' 
		when @time >= '7:00PM' and  @time < '8:00PM' then '7PM - 8PM' 
		when @time >= '8:00PM' and  @time < '9:00PM' then '8PM - 9PM' 
		when @time >= '9:00PM' and  @time < '10:00PM' then '9PM - 10PM' 
		when @time >= '10:00PM' and @time < '11:00PM' then '10PM - 11PM' 
		when @time >= '11:00PM' and @time < '11:59:59:9PM' then '11PM - 12AM'
 		else '00:00:00' 
	end;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[__fnSeq] (@time time(7)) returns tinyint
as
begin
return 
	case  
		when @time >= '0:00AM' and @time < '1:00AM' then 1 
		when @time >= '1:00AM' and @time < '2:00AM' then 2 
		when @time >= '2:00AM' and @time < '3:00AM' then 3 
		when @time >= '3:00AM' and @time < '4:00AM' then 4
		when @time >= '4:00AM' and @time < '5:00AM' then 5 
		when @time >= '5:00AM' and @time < '6:00AM' then 6 
		when @time >= '6:00AM' and @time < '7:00AM' then 7 
		when @time >= '7:00AM' and @time < '8:00AM' then 8 
		when @time >= '8:00AM' and @time < '9:00AM' then 9 
		when @time >= '9:00AM' and @time < '10:00AM' then 10 
		when @time >= '10:00AM' and @time < '11:00AM' then 11 
		when @time >= '11:00AM' and @time < '12:00PM' then 12
		when @time >= '12:00PM' and @time < '1:00PM' then 13
		when @time >= '1:00PM' and @time < '2:00PM' then 14 
		when @time >= '2:00PM' and @time < '3:00PM' then 15 
		when @time >= '3:00PM' and @time < '4:00PM' then 16 
		when @time >= '4:00PM' and @time < '5:00PM' then 17 
		when @time >= '5:00PM' and @time < '6:00PM' then 18 
		when @time >= '6:00PM' and @time < '7:00PM' then 19 
		when @time >= '7:00PM' and @time < '8:00PM' then 20
		when @time >= '8:00PM' and @time < '9:00PM' then 21 
		when @time >= '9:00PM' and @time < '10:00PM' then 22 
		when @time >= '10:00PM' and @time < '11:00PM' then 23 
		when @time >= '11:00PM' and @time < '11:59:59:9PM' then 24 
 		else 0  
	end;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------  ++++++++++++++  ----------------------------------------------
create procedure [dbo].[__sp_CSHR]
(
	@actionType		nvarchar(64)	= null
	, @file_date_from	nvarchar(64)	= null		
	, @file_date_to		nvarchar(64)	= null	
	, @ExceptionName	nvarchar(1024)	= null		
	, @CashierID		nvarchar(1024) 	= null output
)
as
begin
set nocount on
	declare @top int = dbo.__fnGetNumeric(@actionType);
	declare @w table(_cashier nvarchar(64), _count int);
	insert into @w(_cashier, _count)	
	select distinct top(@top) cashier_name, _count = count(1) over (partition by cashier_name) 
	from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
	and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,',')) order by _count desc;
	select @CashierID = N''''''''+string_agg(_cashier, ''''',''''')+'''''''' from @w;
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_DVR]
(
	@actionType		nvarchar(64)	= null
	, @file_date_from	nvarchar(64)	= null
	, @file_date_to		nvarchar(64)	= null
	, @ExceptionName	nvarchar(1024)	= null
	, @Title		nvarchar(1024) 	= null output
)
as
begin
set nocount on
	declare @top int = dbo.__fnGetNumeric(@actionType);
	declare @w table(_title nvarchar(64), _count int);
	insert into @w (_title, _count)
	select distinct top(@top) store_name, _count = count(1) over (partition by store_name)
	from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
	and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,',')) order by _count desc;
	select @Title = N''''''''+ string_agg(_title, ''''',''''')+'''''''' from @w;
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_ct_Daily_Average_By_DVR]
(
	@action				nvarchar(64)	= null
	, @actionType			nvarchar(64)	= null
	, @sub_action			nvarchar(64)	= null
	, @file_date_from		nvarchar(64)	= null
	, @file_date_to			nvarchar(64)	= null
)
as
begin
set nocount on
declare @t table (Title nvarchar(64), Average int);
	with a as(
		select cast(trans_datetime as date) as b, store_name, exception_name, count(1) as c from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to 
		group by cast(trans_datetime as date), store_name, exception_name
	) insert @t(Title, Average) select store_name as Title, avg(c) as Average from a group by store_name; select Title, Average from @t for xml path('_datasets'),type;
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_ct_By_Cashier]
(
	@action				nvarchar(64)	= null
	, @actionType			nvarchar(64)	= null
	, @sub_action			nvarchar(64)	= null
	, @file_date_from		nvarchar(64)	= null
	, @file_date_to			nvarchar(64)	= null
	, @Title			nvarchar(1024)	= null
	, @ExceptionName		nvarchar(1024)	= null
	, @CashierID			nvarchar(1024)	= null
)
as
begin
set nocount on
	if(@sub_action = 'Exceptions By Hour')
	begin
		declare @TimeRange table(Title nvarchar(64), ExName nvarchar(64), DateTimeStamp time, CashierId nvarchar(64), Time_Range nvarchar(64), Total int, seq tinyint);
		insert into @TimeRange(Time_Range, seq) select _time, _seq from dbo.__fnTimeSeq();
		insert into @TimeRange(Title, ExName, DateTimeStamp, CashierId, Total, Time_Range, seq)
		select store_name, exception_name, dbo.__fnDTS(trans_datetime), cashier_name, count(1), dbo.__fnTimeRange(trans_datetime), dbo.__fnSeq(trans_datetime)
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
		and cashier_name in (select part from dbo.__fnSplitString(@CashierID,','))  --  and store_name in (select part from dbo.__fnSplitString(@Title,','))
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,','))
		group by store_name, exception_name, trans_datetime, cashier_name order by trans_datetime;
		select isnull(Title,'') as Title, isnull(ExName,'') as ExName, isnull(DateTimeStamp,'') as DateTimeStamp, isnull(Total,0) as Total, Time_Range, isnull(DateTimeStamp, '00:00:00') as DateTimeStamp, seq 
		from @TimeRange order by seq for xml path('_datasets'),type;
	return;
	end
	if(@sub_action = 'Cashiers By Date')
		select cashier_name as CashierID, store_name as Title, convert(nvarchar(16),trans_datetime, 101) as 'Date', count(1) as Total  
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
		and cashier_name in (select part from dbo.__fnSplitString(@CashierID,',')) and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,','))		
		group by cashier_name, store_name, trans_datetime order by cashier_name for xml path('_datasets'),type;
	if(@sub_action = 'Exceptions Count By Cashier')
		select cashier_name as CashierID, count(1) as Total from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,',')) and store_name in (select part from dbo.__fnSplitString(@Title,','))
		group by cashier_name order by cashier_name for xml path('_datasets'),type; 
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_ct_By_Cashier_By_Date]
(
	@action				nvarchar(64)	= null
	, @actionType			nvarchar(64)	= null
	, @sub_action			nvarchar(64)	= null
	, @file_date_from		nvarchar(64)	= null
	, @file_date_to			nvarchar(64)	= null
	, @Title			nvarchar(1024)	= null
	, @ExceptionName		nvarchar(1024)	= null
	, @CashierID			nvarchar(1024)	= null
)
as
begin
set nocount on
	if(@sub_action = 'Exceptions By Hour')
	begin
		declare @TimeRange table(Title nvarchar(64), ExName nvarchar(64), DateTimeStamp time, CashierId nvarchar(64), Time_Range nvarchar(64), Total int, seq tinyint);
		insert into @TimeRange(Time_Range, seq) select _time, _seq from dbo.__fnTimeSeq();
		if(isnull(replace(@ExceptionName,'''', ''),'')='')
		begin
			insert into @TimeRange(Title, ExName, DateTimeStamp, CashierId, Total, Time_Range, seq)
			select store_name, exception_name, dbo.__fnDTS(trans_datetime), cashier_name, count(1), dbo.__fnTimeRange(trans_datetime), dbo.__fnSeq(trans_datetime)
			from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to and cashier_name in (select part from dbo.__fnSplitString(@CashierID,','))
			group by store_name, exception_name, trans_datetime, cashier_name order by trans_datetime;
			select isnull(Title,'') as Title, isnull(ExName,'') as ExName, isnull(DateTimeStamp, '00:00:00') as DateTimeStamp, isnull(CashierID,'') as CashierID, isnull(Total,0) as Total, Time_Range, seq from @TimeRange order by seq for xml path('_datasets'),type; 
		return;
		end
		insert into @TimeRange(Title, ExName, DateTimeStamp, CashierId, Total, Time_Range, seq)
		select store_name, exception_name, dbo.__fnDTS(trans_datetime), cashier_name, count(1), dbo.__fnTimeRange(trans_datetime), dbo.__fnSeq(trans_datetime)
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to 
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,',')) and cashier_name in (select part from dbo.__fnSplitString(@CashierID,',')) 
		group by store_name, exception_name, trans_datetime, cashier_name order by trans_datetime;
		select isnull(Title,'') as Title, isnull(ExName,'') as ExName, isnull(DateTimeStamp, '00:00:00') as DateTimeStamp, isnull(CashierID,'') as CashierID, isnull(Total,0) as Total, Time_Range, seq from @TimeRange order by seq for xml path('_datasets'),type; 
	return;
	end
	if(@sub_action = 'Exceptions Count By Cashier By Date')
		select cashier_name as CashierID, store_name as Title, convert(nvarchar(16),trans_datetime, 101) as 'Date', count(1) as Total
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to 
		and store_name in (select part from dbo.__fnSplitString(@Title,',')) and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,','))
		group by cashier_name, store_name, trans_datetime order by trans_datetime for xml path('_datasets'),type;   
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_ct_By_Cashier_By_Date_Custom]
(
	@action				nvarchar(64)	= null
	, @actionType			nvarchar(64)	= null
	, @sub_action			nvarchar(64)	= null
	, @file_date_from		nvarchar(64)	= null
	, @file_date_to			nvarchar(64)	= null
	, @Title			nvarchar(1024)	= null
	, @ExceptionName		nvarchar(1024)	= null
	, @CashierID			nvarchar(1024)	= null
)
as
begin
set nocount on
	select cashier_name as CashierID, store_name as Title, convert(nvarchar(16),trans_datetime, 101) as 'Date', count(1) as Total, _count = count(1) over (partition by cashier_name)
	from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
	and cashier_name in (select part from dbo.__fnSplitString(@CashierID,',')) and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,','))
	group by cashier_name, store_name, trans_datetime order by _count desc for xml path('_datasets'),type;
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_ct_By_Date]
(
	@action				nvarchar(64)	= null
	, @actionType			nvarchar(64)	= null
	, @sub_action			nvarchar(64)	= null
	, @file_date_from		nvarchar(64)	= null
	, @file_date_to			nvarchar(64)	= null
	, @Title			nvarchar(1024)	= null
	, @ExceptionName		nvarchar(1024)	= null
	, @CashierID			nvarchar(1024)	= null
)
as
begin
set nocount on
	if(@sub_action = 'Exceptions By Hour')
	begin
		declare @TimeRange table(Title nvarchar(64), ExName nvarchar(64), DateTimeStamp time, CashierId nvarchar(64), Time_Range nvarchar(64), Total int, seq tinyint);
		insert into @TimeRange(Time_Range, seq) select _time, _seq from dbo.__fnTimeSeq();
		insert into @TimeRange(Title, ExName, DateTimeStamp, CashierId, Total, Time_Range, seq)
		select store_name, exception_name, dbo.__fnDTS(trans_datetime), cashier_name, count(1), dbo.__fnTimeRange(trans_datetime), dbo.__fnSeq(trans_datetime)
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
		and store_name in (select part from dbo.__fnSplitString(@Title,',')) and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,','))
		group by store_name, exception_name, trans_datetime, cashier_name order by trans_datetime;
		select isnull(Title,'') as Title, isnull(ExName,'') as ExName, isnull(DateTimeStamp, '00:00:00') as DateTimeStamp, isnull(CashierID,'') as CashierID, isnull(Total,0) as Total, Time_Range, seq from @TimeRange order by seq for xml path('_datasets'),type; 
	return;
	end
	if(@sub_action = 'Exceptions By DVR')
		select store_name as Title, count(1) as Total from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to 
		and store_name in (select part from dbo.__fnSplitString(@Title,',')) and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,','))
		group by store_name order by store_name for xml path('_datasets'),type; 
	if(@sub_action = 'Exceptions Count By Date')
		select exception_name as ExName, convert(nvarchar(16),trans_datetime, 101) as 'Date', count(1) as Total
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to 
		and store_name in (select part from dbo.__fnSplitString(@Title,',')) and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,','))
		group by trans_datetime, exception_name order by trans_datetime desc, count(1) desc for xml path('_datasets'),type;    
	if(@sub_action = 'Exceptions Count By Cashier' ) 
		select cashier_name as CashierID, count(1) as Total from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,',')) and store_name in (select part from dbo.__fnSplitString(@Title,','))
		group by cashier_name order by cashier_name for xml path('_datasets'),type;
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_ct_By_DVR]
(
	@action				nvarchar(64)	= null
	, @actionType			nvarchar(64)	= null
	, @sub_action			nvarchar(64)	= null
	, @file_date_from		nvarchar(64)	= null
	, @file_date_to			nvarchar(64)	= null
	, @Title			nvarchar(1024)	= null
	, @ExceptionName		nvarchar(1024)	= null
	, @CashierID			nvarchar(1024)	= null
)
as
begin 
set nocount on
	if(@sub_action = 'Exceptions By Hour')
	begin
		declare @TimeRange table(Title nvarchar(64), ExName nvarchar(64), DateTimeStamp time, CashierId nvarchar(64), Time_Range nvarchar(64), Total int, seq tinyint);
		insert into @TimeRange(Time_Range, seq) select _time, _seq from dbo.__fnTimeSeq();
		insert into @TimeRange(Title, ExName, DateTimeStamp, CashierId, Total, Time_Range, seq)
		select store_name, exception_name, dbo.__fnDTS(trans_datetime), cashier_name, count(1), dbo.__fnTimeRange(trans_datetime), dbo.__fnSeq(trans_datetime)
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to		
		and store_name in (select part from dbo.__fnSplitString(@Title,',')) and cashier_name in (select part from dbo.__fnSplitString(@CashierID,',')) 
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,',')) group by store_name, exception_name, trans_datetime, cashier_name order by trans_datetime;
		select isnull(Title,'') as Title, isnull(ExName,'') as ExName, isnull(DateTimeStamp, '00:00:00') as DateTimeStamp, isnull(Total,0) as Total, Time_Range, seq from @TimeRange order by seq for xml path('_datasets'),type; 
	return;
	end
	if(@sub_action = 'Cashiers By Date')
		select cashier_name as CashierID, store_name as Title, convert(nvarchar(16),trans_datetime, 101) as 'Date', count(1) as Total  
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,',')) and store_name in (select part from dbo.__fnSplitString(@Title,','))
		group by cashier_name, store_name, trans_datetime order by cashier_name for xml path('_datasets'),type; 

	if(@sub_action = 'Exceptions Count By DVR' ) 
		select store_name as Title, count(1) as Total from dbo.transaction_exceptions 
		where cast(trans_datetime as date) between @file_date_from and @file_date_to
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,','))
		and store_name in (select part from dbo.__fnSplitString(@Title,','))
		group by store_name order by store_name for xml path('_datasets'),type;
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_ct_By_DVR_By_Date]
(
	@action				nvarchar(64)	= null
	, @actionType			nvarchar(64)	= null
	, @sub_action			nvarchar(64)	= null
	, @file_date_from		nvarchar(64)	= null
	, @file_date_to			nvarchar(64)	= null
	, @Title			nvarchar(1024)	= null
	, @ExceptionName		nvarchar(1024)	= null
	, @CashierID			nvarchar(1024)	= null
)
as
begin
set nocount on
	declare @TimeRange table(Title nvarchar(64), ExName nvarchar(64), DateTimeStamp time, CashierId nvarchar(64), Time_Range nvarchar(64), Total int, _DateTimeStamp time(7), seq tinyint);
	insert into @TimeRange(Time_Range, seq) select _time, _seq from dbo.__fnTimeSeq();
	if(@sub_action = 'Exceptions By Hour')
	begin
		if(isnull(replace(@ExceptionName,'''', ''),'')='')
		begin
 			insert into @TimeRange(Title, ExName, DateTimeStamp, CashierId, Total, Time_Range, _DateTimeStamp, seq)
			select store_name, exception_name, dbo.__fnDTS(trans_datetime), cashier_name, count(1), dbo.__fnTimeRange(trans_datetime), dbo.__fnDTS(trans_datetime), dbo.__fnSeq(trans_datetime)
			from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
			and store_name in (select part from dbo.__fnSplitString(@Title,',')) and cashier_name in (select part from dbo.__fnSplitString(@CashierID,','))
			group by store_name, exception_name, trans_datetime, cashier_name order by trans_datetime;
			select isnull(Title,'') as Title, isnull(ExName,'') as ExName, isnull(DateTimeStamp, '00:00:00') as DateTimeStamp, isnull(CashierID,'') as CashierID, isnull(Total,0) as Total, Time_Range, seq from @TimeRange order by seq for xml path('_datasets'),type; 
		return;
		end
 		insert into @TimeRange(Title, ExName, DateTimeStamp, CashierId, Total, Time_Range, _DateTimeStamp, seq)
		select store_name, exception_name, dbo.__fnDTS(trans_datetime), cashier_name, count(1), dbo.__fnTimeRange(trans_datetime), dbo.__fnDTS(trans_datetime), dbo.__fnSeq(trans_datetime)
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
		and store_name in (select part from dbo.__fnSplitString(@Title,',')) and cashier_name in (select part from dbo.__fnSplitString(@CashierID,','))
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,','))
		group by store_name, exception_name, trans_datetime, cashier_name order by trans_datetime;
		select isnull(Title,'') as Title, isnull(ExName,'') as ExName, isnull(DateTimeStamp, '00:00:00') as DateTimeStamp, isnull(CashierID,'') as CashierID, isnull(Total,0) as Total, Time_Range, seq from @TimeRange order by seq for xml path('_datasets'),type;  
	return;
	end
	if(@sub_action = 'Cashiers By Hour')
	begin
		if(isnull(replace(@ExceptionName,'''', ''),'')='')
		begin
			insert into @TimeRange(Title, DateTimeStamp, CashierId, Total, Time_Range, seq)
			select store_name, dbo.__fnDTS(trans_datetime), cashier_name, count(1), dbo.__fnTimeRange(trans_datetime), dbo.__fnSeq(trans_datetime)
			from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to and store_name in (select part from dbo.__fnSplitString(@Title,','))
			group by store_name, trans_datetime, cashier_name order by trans_datetime;
			select isnull(Title,'') as Title, isnull(DateTimeStamp, '00:00:00') as DateTimeStamp, isnull(CashierID,'') as CashierID, isnull(Total,0) as Total, Time_Range, seq from @TimeRange order by seq for xml path('_datasets'),type; 
		return;
		end
		insert into @TimeRange(Title, DateTimeStamp, CashierId, Total, Time_Range, seq)
		select store_name, dbo.__fnDTS(trans_datetime), cashier_name, count(1), dbo.__fnTimeRange(trans_datetime), dbo.__fnSeq(trans_datetime)
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,',')) and store_name in (select part from dbo.__fnSplitString(@Title,','))
		group by store_name, trans_datetime, cashier_name order by trans_datetime;
		select isnull(Title,'') as Title, isnull(DateTimeStamp, '00:00:00') as DateTimeStamp, isnull(CashierID,'') as CashierID, isnull(Total,0) as Total, Time_Range, seq from @TimeRange order by seq for xml path('_datasets'),type; 
	return;
	end
	if(@sub_action = 'Exceptions Count By DVR By Date' ) 
		select store_name as Title, convert(nvarchar(16),trans_datetime, 101) as 'Date', count(1) as Total from dbo.transaction_exceptions 
		where cast(trans_datetime as date) between @file_date_from and @file_date_to 
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,','))
		and store_name in (select part from dbo.__fnSplitString(@Title,',')) 
		group by store_name, trans_datetime order by store_name, trans_datetime for xml path('_datasets'),type;
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_ct_By_DVR_By_Date_Custom]
(
	@action				nvarchar(64)	= null
	, @actionType			nvarchar(64)	= null
	, @sub_action			nvarchar(64)	= null
	, @file_date_from		nvarchar(64)	= null
	, @file_date_to			nvarchar(64)	= null
	, @Title			nvarchar(1024)	= null
	, @ExceptionName		nvarchar(1024)	= null
	, @CashierID			nvarchar(1024)	= null
)
as
begin
set nocount on
	select store_name as Title, convert(nvarchar(16),trans_datetime, 101) as 'Date', count(1) as Total, _count = count(1) over (partition by store_name)
	from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
	and store_name in (select part from dbo.__fnSplitString(@Title,',')) and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,','))
	group by store_name, trans_datetime order by _count desc, store_name, trans_datetime for xml path('_datasets'),type; 
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_ct_By_DVR_By_Hour]
(
	@action				nvarchar(64)	= null
	, @actionType			nvarchar(64)	= null
	, @sub_action			nvarchar(64)	= null
	, @file_date_from		nvarchar(64)	= null
	, @file_date_to			nvarchar(64)	= null
	, @Title			nvarchar(1024)	= null
	, @ExceptionName		nvarchar(1024)	= null
	, @CashierID			nvarchar(1024)	= null
)
as
begin
set nocount on
	if(@sub_action = 'Exceptions Count By DVR By Hour')
	begin
		declare @TimeRange table(Title nvarchar(64), Time_Range nvarchar(64), Total int, seq tinyint);
		insert into @TimeRange(Time_Range, seq) select _time, _seq from dbo.__fnTimeSeq();
		insert into @TimeRange(Title, Total, Time_Range, seq) select store_name, count(1), dbo.__fnTimeRange(trans_datetime), dbo.__fnSeq(trans_datetime)
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,',')) and store_name in (select part from dbo.__fnSplitString(@Title,','))  
		group by store_name, exception_name, trans_datetime order by trans_datetime;
		select isnull(Title,'') as Title, isnull(Total,0) as Total, Time_Range, seq from @TimeRange order by seq for xml path('_datasets'),type; 
	return;
 	end
	if(@sub_action = 'Cashiers By Date')
		select cashier_name as CashierID, store_name as Title, convert(nvarchar(16),trans_datetime, 101) as 'Date', count(1) as Total
		from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to
		and exception_name in (select part from dbo.__fnSplitString(@ExceptionName,',')) and store_name in (select part from dbo.__fnSplitString(@Title,',')) 
		group by cashier_name, store_name, trans_datetime order by cashier_name, count(1) for xml path('_datasets'),type;
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_URL]
(
	@action				nvarchar(64)	= null
	, @actionType			nvarchar(64)	= null
	, @sub_action			nvarchar(64)	= null
	, @Report_Parent		nvarchar(64)	= null
	, @Report			nvarchar(64)	= null
	, @Title_Text			nvarchar(1024)	= null
	, @CashierID_Title		nvarchar(64)	= null
	, @Date				nvarchar(16)	= null
	, @Time_from			nvarchar(16)	= null
	, @Time_to			nvarchar(16)	= null
	, @ExceptionName		nvarchar(1024)	= null
)
as
begin
set nocount on
--  for demo only
	if(@actionType = 'url')
	begin
		if(@action = 'get')
		begin
			select '10.111.1.70:4900' as _IP_PORT_,'01/23/2019 9:12AM' as _DATETIME_,'05/10/2020' as _DATE_,'9:12AM' as _TIME_,'old-Mike' as __USER_,'here, in office' as _DVR_,'No Sales' as _XLIST_,'4848' as _REF_ for xml path('_datasets'),type; 
		return;
		end
		if(@Time_to = '12AM') set @Time_to = '11:59:59PM';
		declare @CashierID nvarchar(256), @Title nvarchar(256), @Time nvarchar(32);
		select  @CashierID = ltrim(rtrim(left(@CashierID_Title, charindex('@', @CashierID_Title) - 2))), @Title = ltrim(rtrim(right(@CashierID_Title, len(@CashierID_Title) - charindex('@', @CashierID_Title) - 1)));
 		declare @table_out table( _IP_PORT_ nvarchar(64), _DATETIME_ nvarchar(64), _DATE_ nvarchar(64), _TIME_ nvarchar(64), __USER_ nvarchar(64), _DVR_ nvarchar(64), _XLIST_ nvarchar(64), _REF_ nvarchar(32));
		select distinct  _IP_PORT_, _DATETIME_, _DATE_,  _TIME_, __USER_, _DVR_, _XLIST_, _REF_ from @table_out order by  _TIME_ for xml path('_datasets'),type;
	end
return;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[__sp_POSExceptionsGraphReports]
(
	@procedure_name			nvarchar(64)	= null
	, @action			nvarchar(64)	= null
	, @actionType			nvarchar(64)	= null
	, @sub_action			nvarchar(64)	= null
	, @file_date_from		nvarchar(64)	= null
	, @file_date_to			nvarchar(64)	= null
	, @Title			nvarchar(1024)	= null
	, @ExceptionName		nvarchar(1024)	= null
	, @CashierID			nvarchar(1024)	= null
	, @DateTimeStamp_from		nvarchar(64)	= null
	, @DateTimeStamp_to		nvarchar(64)	= null
	, @Trans			nvarchar(1024)	= null
	, @Port				nvarchar(8)		= null			--  actually, port number is an unsigned 16-bit integer ( 65535 max )
	, @IP				nvarchar(64)	= null			--  actually, the correct maximum IPv6 string length is 45 characters
)
as
begin
set nocount on
	if(isdate(@file_date_from) = 0) set @file_date_from = convert(nvarchar(64), cast('2001-01-01' as date), 101);
	if(isdate(@file_date_to) = 0) set @file_date_to = convert(nvarchar(64), getdate(), 101); 
	if(isdate(@DateTimeStamp_from) = 0) set @DateTimeStamp_from = convert(nvarchar(64), convert(time, '00:00:01 AM'), 14);
	if(isdate(@DateTimeStamp_to) = 0) set @DateTimeStamp_to = convert(nvarchar(64), convert(time, '23:59:59 PM'), 14);
	if(@action = 'code' )
	begin
		if(@actionType = 'DVR') select distinct store_name as DVR from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to order by store_name for xml path('_datasets'),type;
		if(@actionType = 'EXC') select distinct exception_name as _Name from dbo.exceptions where [status] =1 for xml path('_datasets'),type;
		--  --  gm	if(@actionType = 'EXC') select distinct exception_name as _Name from dbo.transaction_exceptions where cast(trans_datetime as date) between @file_date_from and @file_date_to order by exception_name for xml path('_datasets'),type;
	
	return;
	end
	if(@action = 'custom_DVR' )
	begin
		exec dbo.__sp_DVR @actionType, @file_date_from, @file_date_to, @ExceptionName, @Title output;
		exec dbo.__sp_ct_By_DVR_By_Date_Custom @action, @actionType, @sub_action, @file_date_from, @file_date_to, @Title, @ExceptionName, @CashierID;
	return;
	end
	if(@action = 'custom_CSHR' )
	begin
		exec dbo.__sp_CSHR @actionType, @file_date_from, @file_date_to, @ExceptionName, @CashierID output;
		exec dbo.__sp_ct_By_Cashier_By_Date_Custom @action, @actionType, @sub_action, @file_date_from, @file_date_to, @Title, @ExceptionName, @CashierID;
	return;
	end  
	if(@action = 'report' )
	begin
		if(@actionType = 'Exceptions Count By DVR By Date') begin exec dbo.__sp_ct_By_DVR_By_Date @action, @actionType, @sub_action, @file_date_from, @file_date_to, @Title, @ExceptionName, @CashierID; return; end;
		if(@actionType = 'Exceptions Count By DVR') begin exec dbo.__sp_ct_By_DVR @action, @actionType, @sub_action, @file_date_from, @file_date_to, @Title, @ExceptionName, @CashierID; return; end;
		if(@actionType = 'Exceptions Count By Date') begin exec dbo.__sp_ct_By_Date @action, @actionType, @sub_action, @file_date_from, @file_date_to, @Title, @ExceptionName, @CashierID; return; end;
		if(@actionType = 'Exceptions Count Daily Average By DVR') begin exec dbo.__sp_ct_Daily_Average_By_DVR @action, @actionType, @sub_action, @file_date_from, @file_date_to; return; end;
		if(@actionType = 'Exceptions Count By DVR By Hour') begin exec dbo.__sp_ct_By_DVR_By_Hour @action, @actionType, @sub_action, @file_date_from, @file_date_to, @Title, @ExceptionName, @CashierID; return; end;
		if(@actionType = 'Exceptions Count By Cashier') begin exec dbo.__sp_ct_By_Cashier @action, @actionType, @sub_action, @file_date_from, @file_date_to, @Title, @ExceptionName, @CashierID; return; end;
		if(@actionType = 'Exceptions Count By Cashier By Date') begin exec dbo.__sp_ct_By_Cashier_By_Date @action, @actionType, @sub_action, @file_date_from, @file_date_to, @Title, @ExceptionName, @CashierID; return; end;
	end
return;
end
GO

select 'done';

------------------------------------------  ++++++++++++++  ----------------------------------------------
------------------------------------------  ++++++++++++++  ----------------------------------------------


/*
--		declare @test nvarchar(500);
--		set @test = n'this$is%a<>test,;to}⌡↕strip╞╟╚══¶out_ç_ƒ▀ special-ĳ-೫-chars-舛-დ-א-b';
--		    declare @k as varchar(16) = '%[^a-z0-9, ]%';
--		    while patindex(@k, @test) > 0 set @test = stuff(@test, patindex(@k, @test), 1,'');
--		    select @test;
--		declare @test nvarchar(64) = N'this$is%a<>test,;to}⌡↕strip╞╟╚══¶out_ç_ƒ▀ special-ĳ-೫-chars-舛-დ-א-b';
--		
--		select [dbo].[__fnStrip](@test)
--		
---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---
--				STRING_SPLIT ( string , separator )   --  ALTER DATABASE DailyAuditInfoData SET COMPATIBILITY_LEVEL = 130
--				IIF ( boolean_expression, true_value, false_value )  --  select convert( nvarchar(64), cast('2001-01-01' as date) , 121 )
--				declare @d datetime = '10/01/2011'; select format(@d, 'd', 'en-gb')  ' occurrence_info._Title as Title, format( occurrence_info._file_date, ''d'', ''en-gb'') as Date, count(1) as Total '
--				update my_table
--				set path = replace(path, 'oldstring', 'newstring')
--				WAITFOR DELAY '00:00:00.1'
--  if(@sub_action = 'ftp_images_info' )  
--  begin
--  	select 
--  		audit_info._Title as Title  
--  		, 'ftp:gulfcoastsoftware.com,3477;' as 'ftp:first'
--  		, audit_info._IP
--  		, audit_info._Port
--  		, 'ftp:gulfcoastsoftware.com,3204;' as 'ftp:second'
--  	from dbo.tbl_GCSDailyAuditInfoData_hdr hdr   
--  		inner join dbo.tbl_GCSExceptionReviewAuditInfo audit_info
--  			on audit_info._file_id  = hdr._file_id
--  			and audit_info._file_date = hdr._file_date   
--  		inner join dbo.tbl_GCSExceptionOccurrenceInfo occurrence_info
--  			on occurrence_info._file_id  = hdr._file_id
--  			and occurrence_info._file_date = hdr._file_date
--  			and occurrence_info._id_parent  = audit_info._id  
--  	where  audit_info._Date >= @file_date_from 
--  		and audit_info._Date <= @file_date_to 
--  		and audit_info._Name in (select part from dbo.__fnSplitString(@ExceptionName,','))
--  		and audit_info._Title in (select part from dbo.__fnSplitString(@Title,','))
--  	order by audit_info._Title;
--  return;
--  end
---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---
*/
