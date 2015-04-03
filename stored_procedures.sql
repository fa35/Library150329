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



-- Funktion GetMitarbeiterBit notwendig

-- Mitarbeiter legt neues Buch an

USE [Bibliothek]
GO
CREATE PROCEDURE sp_LegeBuchAn @ausweisNr int, @isbn bigint, @titel nvarchar(max), @fachgebietId int
AS

DECLARE @mitarbeiter bit;
SET @mitarbeiter = dbo.GetMitarbeiterBit(@ausweisNr)

IF ( @mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
INSERT INTO [dbo].[Buecher]
           ([p_ISBN]
           ,[titel]
           ,[f_fachgebiet_id])
     VALUES
           (@isbn, @titel, @fachgebietId)
	END

GO

EXEC sp_LegeBuchAn 2, 3518260432 , 'Die stille Revolution: Wie Algorithmen Wissen, Arbeit, Öffentlichkeit und Politik verändern, ohne dabei viel Lärm zu machen (edition unseld)', 1

-- es fehlt die buecher_autore zuordnung, evtl. müsse ein neuer autor angelegt werden oder ein neues fachgebiet


-- weitere Funktion zu Löschen benötigt: getAnzahlAusgeliehenerExemplare


USE [Bibliothek]
GO
CREATE PROCEDURE sp_LoescheBuch @ausweisNr int, @isbn bigint
AS

DECLARE @mitarbeiter bit;
SET @mitarbeiter = dbo.GetMitarbeiterBit(@ausweisNr)

IF ( @mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		DECLARE @anzahlAusgeliehenerExemplare int = dbo.GetAnzahlAusgeliehenerExemplare(@isbn)
		IF (@anzahlAusgeliehenerExemplare <> 0)
			BEGIN
				PRINT 'Es sind noch Exemplare ausgeliehen'
			END
		ELSE
		BEGIN
			DELETE FROM [Buecher] WHERE p_ISBN = @isbn
		END
	END
GO

-- zum Testen neues Buch anlegen
EXEC sp_LegeBuchAn 2, 3518260430 , 'Die stille Revolution: Wie Algorithmen Wissen, Arbeit, Öffentlichkeit und Politik verändern, ohne dabei viel Lärm zu machen (edition unseld)', 1
-- das neu angelegte Buch loeschen
EXEC sp_LoescheBuch 2, 3518260430



-- Funktion CreateSignature zusätzlich wird benötigt


USE [Bibliothek]
GO
CREATE PROCEDURE sp_LegeExemplarAn @ausweisNr int, @isbn bigint
AS
DECLARE @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr)

IF ( @mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		DECLARE @fachgebiet int = (select f_fachgebiet_id from Buecher where p_ISBN = @isbn)
		DECLARE @signature varchar(10) = dbo.CreateSignature(@fachgebiet, @isbn);

		INSERT INTO [dbo].[Exemplare]
					([p_signatur]
					,[f_ISBN])
				VALUES
					(@signature, @isbn)
	END
GO

EXEC sp_LegeExemplarAn 2, 3518260432



-- Lösche Exemplar


USE[Bibliothek]
GO
CREATE PROCEDURE sp_LoescheExemplar @ausweisNr int, @signatur varchar(10)
AS
DECLARE @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr)

IF ( @mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		DECLARE @isbn bigint = (select f_isbn from Exemplare where p_signatur = @signatur);

		DECLARE @anzahl int = (
			select count(*) 
			from Ausgeliehene_Exemplare 
			where pf_signatur = @signatur
		)

		IF(@anzahl > 0)
		BEGIN
			PRINT 'Das Exemplar ist ausgeliehen - kann somit nicht gelöscht werden'
		END
		ELSE
		BEGIN
			DELETE FROM Exemplare WHERE p_signatur = @signatur
	END
END
GO

EXEC sp_LoescheExemplar 2, 'PROP0001'

-- evtl. cool oder notwendig sowas wie : loesche alle exemplare eines buches



-- Lege einen neuen Nutzer -> somit auch einen neuen Ausweis an


USE[Bibliothek]
GO
CREATE PROCEDURE sp_LegeNutzerAn @ausweisNr int, @nutzer bit, @vorname nvarchar(max),
           @name nvarchar(max), @geburtsdatum date, @kontostand smallmoney, @passwort varchar(16)
AS
DECLARE @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr);

IF (@mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		DECLARE @personenId int = ((select max(p_personen_id) from nutzer) + 1);
		INSERT INTO [dbo].[Nutzer]
			   ([p_personen_id]
			   ,[mitarbeiter]
			   ,[vorname]
			   ,[name]
			   ,[geburtsdatum]
			   ,[kontostand])
		 VALUES
			   (@personenId, @nutzer, @vorname, @name, @geburtsdatum, @kontostand)
		-- lege ausweis an
		DECLARE @ausweis int = ((select max(ausweisnr) from ausweise) + 1);
		INSERT INTO [dbo].[Ausweise]
				   ([pf_personen_id]
				   ,[ausweisnr]
				   ,[passwort]
				   ,[gueltigBis]
				   ,[gesperrt])
			 VALUES
				   (@personenId, @ausweis, @passwort, DATEADD(year, 2, getdate()), 0)
	END
GO

EXEC sp_LegeNutzerAn 2, 1, 'SA' , 'AS', '1960-01-01', 0, 'standard'



--- Loeschen von Nutzer, seines Ausweises und vorbestellter Buecher, wenn keine Exemplare mehr ausgeliehen sind

USE[Bibliothek]
GO
CREATE PROCEDURE sp_LoescheNutzer @ausweisNr int, @personenId int
AS
DECLARE @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr);
IF (@mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		-- prüfe ob es noch ausgeliehene exemplare gibt:
		DECLARE @ausgelieheneExemplare int = (SELECT COUNT(*) FROM Ausgeliehene_Exemplare WHERE pf_personen_id = @personenId)
		IF(@ausgelieheneExemplare <= 0)
			BEGIN
				DELETE FROM Ausweise WHERE pf_personen_id = @personenId
				DELETE FROM Vorbestellte_Buecher WHERE pf_personen_id = @personenId
				DELETE FROM Nutzer WHERE p_personen_id = @personenId
			END
		ELSE
			BEGIN
				PRINT 'Es sind noch Exemplare ausgeliehen'
			END
	END
GO

EXEC sp_LoescheNutzer 2, 7




mitarbeiter können zusätzlich:


- ausweis sperren / entsperren / verlängern
- leihfrist oder gebühr ändern
