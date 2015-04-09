-- @license: GPLv2
-- @author: Corinna Rohr

USE[Bibliothek]
GO
CREATE PROCEDURE sp_VerlaengereAusweis @ausweisNr int, @personenId int
AS
DECLARE @ok bit = 0, @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr);
IF (@mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
		RETURN @ok
	END
ELSE
	BEGIN
		DECLARE @bit bit = dbo.CheckKontoAusgeglichen(@personenId)

		IF(@bit = 0)
			BEGIN
				PRINT 'Das Nutzer-Konto ist nicht ausgeglichen'
				RETURN @ok
			END
		ELSE
			BEGIN
				UPDATE [dbo].[Ausweise] SET [gueltigBis] = DATEADD(YEAR, 10, GETDATE()) WHERE pf_personen_id = @personenId
				SET @ok = 1;
				RETURN @ok
			END
	END
GO


EXEC sp_VerlaengereAusweis 2, 3

