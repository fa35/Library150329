-- @license: GPLv2
-- @author: Corinna Rohr

-- sperre ausweis

USE[Bibliothek]
GO
CREATE PROCEDURE sp_SperreAusweis @ausweisNr int, @personenId int
AS
DECLARE @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr);
IF (@mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		UPDATE [dbo].[Ausweise] SET [gesperrt] = 1 WHERE pf_personen_id = @personenId
	END
GO


EXEC sp_SperreAusweis 2, 3



-- entsperre ausweis

USE[Bibliothek]
GO
CREATE PROCEDURE sp_EntsperreAusweis @ausweisNr int, @personenId int
AS
DECLARE @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr);
IF (@mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		UPDATE [dbo].[Ausweise] SET [gesperrt] = 0 WHERE pf_personen_id = @personenId
	END
GO


EXEC sp_EntsperreAusweis 2, 3

