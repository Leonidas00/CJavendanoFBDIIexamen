/* 1. crear dispositivo de backup para adventureworks2019: servidor virtual
	2. crear backup dinamico   awbc_yyyyMMdd_ hhmm.bak    dinamico  en el dispositvo
	3. configurar database mail

	No cree el servidor virtual :(
*/

use master
GO

BACKUP DATABASE AdventureWorks2019
	TO DISK = 'C:\AWDBexamen\AdventureWorks2019.bak'
WITH	
	NOFORMAT, 
	COMPRESSION, 
	NOINIT, 
	NAME = 'Full Adventure Backup',
	SKIP, 
	STATS = 10;
GO

-- 1. Variable declaration

DECLARE @path VARCHAR(500)
DECLARE @name VARCHAR(500)
DECLARE @pathwithname VARCHAR(500)
DECLARE @time DATETIME
DECLARE @year VARCHAR(4)
DECLARE @month VARCHAR(2)
DECLARE @day VARCHAR(2)
DECLARE @hour VARCHAR(2)
DECLARE @minute VARCHAR(2)
DECLARE @second VARCHAR(2)

-- 2. Setting the backup path

SET @path = 'C:\AWDBexamen\'

-- 3. Getting the time values

SELECT @time   = GETDATE()
SELECT @year   = (SELECT CONVERT(VARCHAR(4), DATEPART(yy, @time)))
SELECT @month  = (SELECT CONVERT(VARCHAR(2), FORMAT(DATEPART(mm,@time),'00')))
SELECT @day    = (SELECT CONVERT(VARCHAR(2), FORMAT(DATEPART(dd,@time),'00')))
SELECT @hour   = (SELECT CONVERT(VARCHAR(2), FORMAT(DATEPART(hh,@time),'00')))
SELECT @minute = (SELECT CONVERT(VARCHAR(2), FORMAT(DATEPART(mi,@time),'00')))
SELECT @second = (SELECT CONVERT(VARCHAR(2), FORMAT(DATEPART(ss,@time),'00')))

-- 4. Defining the filename format

SELECT @name ='AWDBexamen' + '_' + @year + @month + @day + @hour + @minute + @second

SET @pathwithname = @path + @name + '.bak';

--5. Executing the backup command

BACKUP DATABASE [AdventureWorks2019] 
TO DISK = @pathwithname WITH NOFORMAT, NOINIT, SKIP, REWIND, NOUNLOAD, STATS = 10;




/* database mail configuration  */

sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
 
sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO

sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO
 
 -- Create a Database Mail profile  
EXECUTE msdb.dbo.sysmail_add_profile_sp  
    @profile_name = 'Notifications',  
    @description = 'Profile used for sending outgoing notifications using Gmail.' ;  
GO

-- Grant access to the profile to the DBMailUsers role  
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp  
    @profile_name = 'Notifications',  
    @principal_name = 'public',  
    @is_default = 1 ;
GO