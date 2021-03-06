-- @license: GPLv2
-- @author: Corinna Rohr

-- bestelle buch vor

USE[Bibliothek]
GO
CREATE PROCEDURE sp_TestBegleicheGebuehr @ausweisNr int, @recht bit, @vname nvarchar(max), @nname varchar(max), @gdatum date, @konto smallmoney, @pw varchar(16), @beitrag smallmoney
AS

PRINT 'Lege Test-Nutzer an'
EXEC sp_LegeNutzerAn @ausweisNr, @recht, @vname, @nname, @gdatum, @konto, @pw
PRINT CONCAT('Test-Nutzer mit Vname: ', @vname, ' Nname: ', @nname, ' Geburtsdatum: ', @gdatum, ' Recht: ', @recht , ' Kontostand: ', @konto, ' Passwort: ', @pw, ' angelegt')


PRINT 'Suche nach AusweisNr'
DECLARE @personenId int = (select p_personen_id from Nutzer where name = @nname and vorname = @vname and geburtsdatum = @gdatum and mitarbeiter = @recht)
DECLARE @perAus int = (select ausweisnr from Ausweise where passwort = @pw and pf_personen_id = @personenId)
PRINT CONCAT('PersonenId = ', @personenId, ' AusweisNr =' , @perAus)

DECLARE @shouldKonto smallmoney = @konto - @beitrag

PRINT 'Versuche Gebuehren zu begleihen'
PRINT CONCAT('Der Kontostand sollte: ', @shouldKonto, ' betragen')
EXEC sp_BegleicheGebuehr @perAus, @beitrag
PRINT 'Prozedur sp_BegleicheGebuehr ausgefuehrt'

PRINT 'Pruefe Kontostand'
DECLARE @aktKonto smallmoney = (select kontostand from Nutzer where p_personen_id = @personenId)
PRINT CONCAT('Kontostand = ', @aktKonto)

IF(@shouldKonto = @aktKonto)
	BEGIN
		PRINT 'Prozedure sp_BegleicheGebuehr war erfolgreich'
	END
ELSE
	BEGIN
		PRINT 'Prozedure sp_BegleicheGebuehr funktioniert nicht richtig'
	END

PRINT 'Beginne damit die Test-Daten wieder zu loeschen'
EXEC sp_LoescheNutzer @ausweisNr, @personenId

DECLARE @catched int = (select count(*) from nutzer where p_personen_id = @personenId and vorname = @vname and name = @nname)

IF(@catched = 0)
	BEGIN
		PRINT 'Loeschung erfolgreich'
	END
ELSE
	BEGIN
		PRINT 'Die Prozedur sp_LoescheNutzer weist Fehler auf, der Nutzer wurde nicht geloescht'
	END


EXEC sp_TestBegleicheGebuehr 2, 0, 'test_vorname', 'test_nachname', '24.07.1992', 75, '44uf8374', 50


