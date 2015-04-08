-- @license: GPLv2
-- @author: Corinna Rohr

-- Nutzer mit Ausweis, kann Exemplare ausleihen:

USE[Bibliothek]
GO

CREATE PROCEDURE sp_LeiheExemplarAus (@isbn bigint, @ausweisNr int, @name nvarchar(max))
AS
DECLARE @signatur varchar(10), @personenId int;

SET @signatur = (select Top(1) p_signatur from Exemplare where f_ISBN = @isbn and p_signatur not in (select pf_signatur from Ausgeliehene_Exemplare )) -- = signatur des exemplares
SET @personenId = (select pf_personen_id from Ausweise where gesperrt = 0 and ausweisnr = @ausweisNr) -- = pf_personen_id falls ausweis gueltig

--PRINT @signatur
--PRINT @personenId

BEGIN
-- wenn ausweis noch gueltig: 
IF (@personenId >= 1)
	BEGIN
		DECLARE @leihWochen tinyint, @rueckgabeDatum date;
		SET @leihWochen = (select leihfrist_wochen from Bibliotheken where name = @name) -- = leihwochen
		SET @rueckgabeDatum = DATEADD(Day,(@leihWochen*7),GETDATE())

		--PRINT @leihWochen
		--PRINT @rueckgabeDatum

		INSERT INTO [dbo].[Ausgeliehene_Exemplare]
				   ([pf_signatur]
				   ,[pf_personen_id]
				   ,[rueckgabe_datum]
				   ,[anzahl_verlaengerungen])
			 VALUES
				   (@signatur, @personenId, @rueckgabeDatum,0 )
	END
ELSE
	BEGIN
		PRINT 'Ausweis ist nicht mehr gueltig'
	END
END

GO

EXEC sp_LeiheExemplarAus 3499624249, 4, 'Stadtbibliothek'