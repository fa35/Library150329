-- @license: GPLv2
-- @author: Corinna Rohr

-- verlaengere ausweis


USE[Bibliothek]
GO
CREATE PROCEDURE sp_VerlaengereAusweis @ausweisNr int, @personenId int
AS
DECLARE @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr);
IF (@mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		UPDATE [dbo].[Ausweise] SET [gueltigBis] = DATEADD(YEAR, 10, GETDATE()) WHERE pf_personen_id = @personenId
	END
GO


EXEC sp_VerlaengereAusweis 2, 3

