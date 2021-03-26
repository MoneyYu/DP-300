/*
For more details, take a look at the demo here : https://blog.hicham.website/?p=55
*/

-- Listing the advanced configuration options
USE master;
GO
sp_configure 'show advanced', 1;

--Updates the currently configured value of a configuration option changed with the sp_configure .
RECONFIGURE;

-- display server-level settings.
EXEC sp_configure;
GO

--Limiting the CPU to 1
sp_configure 'affinity mask', 1;
GO


--Limiting memory to 512 MB
sp_configure 'min server', 512;
GO
sp_configure 'max server', 512;
GO

--Updates the currently configured value of a configuration option changed with the sp_configure .
RECONFIGURE;
GO