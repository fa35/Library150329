
USE[Bibliothek]
GO
CREATE PROCEDURE sp_TestKontoLimitErreicht
AS

DECLARE @personenId int = (select top(1) p_personen_id from Nutzer)
PRINT CONCAT('PersonenId= ', @personenId)

DECLARE @b bit = dbo.CheckKontoLimit (@personenId)

IF(@b = 0) -- = false = Kontostand >= 100
BEGIN
	PRINT 'Kontostand-Limit erreicht (>= 100)'
END
ELSE
BEGIN
	PRINT 'Kontostand-Limit nicht erreicht (< 100)'
END

DECLARE @stand smallmoney = (select kontostand from Nutzer where p_personen_id = @personenId)
PRINT CONCAT('Kontostand = ', @stand)

