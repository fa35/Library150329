
-- Nutzer mit Ausweis, kann Bücher vorbestellen:

USE[Bibliothek]
GO

CREATE PROCEDURE sp_BestelleBuchVor (@isbn bigint, @ausweisNr int)
AS

DECLARE @personenId int;
SET @personenId = (select pf_personen_id from Ausweise where gesperrt = 0 and ausweisnr = @ausweisNr) -- = pf_personen_id falls ausweis gueltig

IF (@personenId <= 0)
	BEGIN
		PRINT 'Ausweis ist nicht gueltig'
	END
ELSE
	BEGIN
		INSERT INTO [dbo].[Vorbestellte_Buecher]
				   ([pf_isbn]
				   ,[pf_personen_id])
			 VALUES
				   (@isbn, @personenId)
	END
GO

EXEC sp_BestelleBuchVor 3897215675, 4