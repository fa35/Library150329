-- @license: GPLv2
-- @author: Corinna Rohr

-- Nutzer mit Ausweis, kann Bücher vorbestellen:

USE[Bibliothek]
GO

CREATE PROCEDURE sp_BestelleBuchVor (@isbn bigint, @ausweisNr int)
AS

DECLARE @gesperrt bit = dbo.GetAusweisGesperrt (@ausweisNr)

IF(@gesperrt = 1)
BEGIN
	PRINT 'Ausweis ist geperrt'
END
ELSE
	BEGIN
		DECLARE @personenId int = (select pf_personen_id from Ausweise where ausweisnr = @ausweisNr)

		INSERT INTO [dbo].[Vorbestellte_Buecher]
				   ([pf_isbn]
				   ,[pf_personen_id])
			 VALUES
				   (@isbn, @personenId)
	END
GO


EXEC sp_BestelleBuchVor 3897215675, 4