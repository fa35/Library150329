-- @license: GPLv2
-- @author: Corinna Rohr

USE[Bibliothek]
GO
CREATE PROCEDURE sp_TestCheckPostiveGanzzahl @zahl smallmoney
AS

DECLARE @b bit = dbo.CheckPositiveGanzzahl (@zahl)

IF(@b = 0) -- = false
BEGIN
	PRINT 'Zahl ist nicht positiv oder keine Ganzzahl'
END
ELSE
BEGIN
	PRINT 'Zahl ist positiv und eine Ganzzahl'
END

PRINT CONCAT('Kontostand = ', @zahl)




EXEC sp_TestCheckPostiveGanzzahl 15