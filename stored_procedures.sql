-- Aufgabe 3 - Prozeduren:


-- Suche der Bücher ohne Ausweis möglich

USE[Bibliothek]
GO
CREATE PROCEDURE sp_SucheBuecherNachISBN (@pattern bigint)
AS
SELECT * 
FROM Buecher
WHERE p_ISBN = @pattern
GO
EXEC sp_SucheBuecherNachISBN 3499624249


USE[Bibliothek]
GO
CREATE PROCEDURE sp_SucheBuecherNachTitel (@pattern nvarchar)
AS
SELECT *
FROM Buecher
WHERE titel like '%'+@pattern+'%'
GO
EXEC sp_SucheBuecherNachTitel 'Dinge geregelt kriegen'


USE[Bibliothek]
GO
CREATE PROCEDURE sp_SucheBuecherNachFachgebietId (@pattern int)
AS
SELECT * 
FROM Buecher
WHERE f_fachgebiet_id = @pattern
GO
EXEC sp_SucheBuecherNachFachgebietId 1


-- Rückgabe der Bücher bzw. da Exemplare ausgeliehen werden, Exemplare, ist ohne Ausweis möglich

USE [Bibliothek]
GO
CREATE PROCEDURE sp_GebeExemplarZurueck (@signature varchar(10))
AS
DELETE FROM Ausgeliehene_Exemplare
WHERE pf_signatur = @signature
GO

EXEC sp_GebeExemplarZurueck 'WISP0001'



-- Nutzer mit Ausweis, kann Bücher / Exemplare ausleihen:

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
		PRINT 'Ausweis ist nicht mehr gültig'
	END
END

GO

EXEC sp_LeiheExemplarAus 3499624249, 4, 'Stadtbibliothek'




-- - - bücher vorbestellen



-- - - gebühren bezahlen

