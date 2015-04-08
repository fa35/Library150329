-- @license: GPLv2
-- @author: Corinna Rohr

-- Mitarbeiter legt neues Buch an
-- Funktion GetMitarbeiterBit notwendig

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

-- es fehlt die buecher_autore zuordnung, evtl. müsse ein neuer autor angelegt werden oder ein neues fachgebiet

-- weitere Funktion zu Löschen benötigt: getAnzahlAusgeliehenerExemplare


USE [Bibliothek]
GO
CREATE PROCEDURE sp_LoescheBuch @ausweisNr int, @isbn bigint
AS

DECLARE @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr)

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
