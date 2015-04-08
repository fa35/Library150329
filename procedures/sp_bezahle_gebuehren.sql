-- @license: GPLv2
-- @author: Corinna Rohr

-- Nutzer mit Ausweis, kann Gebuehren bezahlen:

USE[Bibliothek]
GO

CREATE PROCEDURE sp_BegleicheGebuehr (@ausweisNr int, @betrag smallmoney)
AS

DECLARE @personenId int, @currKontostand smallmoney;
SET @personenId = (select pf_personen_id from Ausweise where ausweisnr = @ausweisNr)
SET @currKontostand = (select top(1) kontostand from Nutzer where p_personen_id = @personenId)

IF(@personenId >= 0)
	BEGIN
		UPDATE [dbo].[Nutzer]
			SET kontostand = (@currKontostand-@betrag)
			WHERE p_personen_id = @personenId
	END
ELSE
	BEGIN
		PRINT 'Person konnte nicht gefunden werden.'
	END
GO

EXEC sp_BegleicheGebuehr 4, 50