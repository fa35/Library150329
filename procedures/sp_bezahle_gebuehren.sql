-- @license: GPLv2
-- @author: Corinna Rohr


USE[Bibliothek]
GO

CREATE PROCEDURE sp_BegleicheGebuehr (@ausweisNr int, @betrag smallint)
AS

DECLARE @b bit = dbo.CheckPositiveGanzzahl (@betrag)

IF(@b = 0)
BEGIN
	PRINT 'Negative Beitraege werden nicht angenommen'
END
ELSE
	BEGIN
		DECLARE @personenId int, @currKontostand smallint;
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
	END

EXEC sp_BegleicheGebuehr 4, 500