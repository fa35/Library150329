-- buch

--DECLARE @ausweisNr int, @isbn bigint, @titel nvarchar(max), @fachgebiet int;

USE [Bibliothek]
GO
CREATE PROCEDURE sp_TestAnlegenLoeschenBuch @ausweisNr int, @isbn bigint, @titel nvarchar(max), @fachgebiet int
AS
DECLARE @anzBuecherVor int = (select * from Buecher)

PRINT 'Versuche neues Buch anzulegen'
EXEC sp_LegeBuchAn @ausweisNr, @isbn, @titel, @fachgebiet 
PRINT 'Prozedur sp_LegeBuchAn ausgefuehrt'

DECLARE @anzBuecherNach int = (select * from Buecher)

PRINT CONCAT('Anzahl vor: ', @anzBuecherVor, ' Anzahl nach: ', @anzBuecherNach)

IF(@anzBuecherVor < @anzBuecherNach)
BEGIN
	PRINT 'Prozedur sp_LegeBuchAn funktioniert'
	-- loesche buch

	PRINT 'Versuche Buch zu loeschen'
	EXEC sp_LoescheBuch @ausweisNr, @isbn
	PRINT 'Prozedur sp_LoescheBuch ausgefuehrt'

	SET @anzBuecherVor = @anzBuecherNach
	SET @anzBuecherNach = (select * from Buecher)

	PRINT CONCAT('Anzahl vor: ', @anzBuecherVor, ' Anzahl nach: ', @anzBuecherNach)

	IF(@anzBuecherVor > @anzBuecherNach)
	BEGIN
		PRINT 'Prozedur sp_LoescheBuch funktioniert'
	END
	ELSE
	BEGIN
		PRINT 'Prozedur sp_LoescheBuch scheint nicht richtig zu funktionieren'
	END
END
ELSE
BEGIN
	PRINT 'Prozedur sp_LegeBuchAn scheint nicht richtig zu funktionieren'
END

exec sp_TestAnlegenLoeschenBuch 2, 9999999999, 'test buch anlegen', 1

select * from buecher