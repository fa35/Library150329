


USE[Bibliothek]
GO
CREATE PROCEDURE sp_TestKontoAusgeglichen
AS

DECLARE @personenId int = (select top(1) p_personen_id from Nutzer)
PRINT CONCAT('PersonenId= ', @personenId)

DECLARE @b bit = dbo.CheckKontoAusgeglichen (@personenId)

IF(@b = 0) -- = false = Kontostand > 0
BEGIN
	PRINT 'Kontostand nicht ausgeglichen (> 0)'
END
ELSE
BEGIN
	PRINT 'Kontostand ausgeglichen (= 0)'
END

DECLARE @stand smallmoney = (select kontostand from Nutzer where p_personen_id = @personenId)
PRINT CONCAT('Kontostand = ', @stand)

