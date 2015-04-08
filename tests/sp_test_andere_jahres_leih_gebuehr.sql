-- @license: GPLv2
-- @author: Corinna Rohr

-- aendere jahresgebuehr und setze sie dann wieder auf den urspruenglichen wert

USE[Bibliothek]
GO
CREATE PROCEDURE sp_TestAendereJahresgebuehr @ausweisNr int, @gebuehr smallmoney, @bibname nvarchar(max)
AS

DECLARE @tatGeb smallmoney = (select gebuehren_jahr from Bibliotheken where name = @bibname)
PRINT CONCAT('Aktuelle Jahresgebuehr =', @tatGeb)

PRINT CONCAT('Versuche sp_AendereJahresGebuehr auszufuehren, setze Gebuehr auf: ',  @gebuehr)
EXEC sp_AendereJahresGebuehr @ausweisNr, @gebuehr, @bibname
PRINT 'Prozedur sp_AendereJahresGebuehr wurde ausgefuehrt'

DECLARE @neueGeb smallmoney = (select gebuehren_jahr from Bibliotheken where name = @bibname)
PRINT CONCAT('Neue Jahresgebuehr ist: ' , @neueGeb)

IF(@neueGeb = @gebuehr)
BEGIN
	PRINT 'Prozedur sp_AendereJahresGebuehr funktioniert'

	PRINT CONCAT('Setze die Gebuehr wieder auf ihren urspruenglichen Wert von: ', @tatGeb)
	EXEC sp_AendereJahresGebuehr @ausweisNr, @tatGeb, @bibname
	PRINT 'Prozedur sp_AendereJahresGebuehr wurde ausgefuehrt'

	SET @neueGeb = (select gebuehren_jahr from Bibliotheken where name = @bibname)

	PRINT CONCAT('Die Jahresgebuehr betraegt nun: ' , @neueGeb)
	
	IF(@neueGeb = @tatGeb)
	BEGIN
		PRINT 'Prozedur sp_AendereJahresGebuehr funktioniert'
	END
	ELSE
	BEGIN
		PRINT 'Prozedur sp_AendereJahresGebuehr schein nicht zu funktioniert'
	END
END
ELSE
BEGIN
	PRINT 'Prozedure sp_AnedereJahresGebuehr scheint nicht richtig zu funktionieren'
END


EXEC sp_TestAendereJahresgebuehr 2, 123, 'Stadtbibliothek'





-- test fuer das aendern der leihgebuehr

USE[Bibliothek]
GO
CREATE PROCEDURE sp_TestAendereLeihgebuehr @ausweisNr int, @gebuehr smallmoney, @bibname nvarchar(max)
AS

DECLARE @tatGeb smallmoney = (select gebuehren_leihfrist from Bibliotheken where name = @bibname)
PRINT CONCAT('Aktuelle Leihgebuehr =', @tatGeb)

PRINT CONCAT('Versuche sp_AendereLeihGebuehr auszufuehren, setze Gebuehr auf: ',  @gebuehr)
EXEC sp_AendereLeihGebuehr @ausweisNr, @gebuehr, @bibname 
PRINT 'Prozedur sp_AendereLeihGebuehr wurde ausgefuehrt'

DECLARE @neueGeb smallmoney = (select gebuehren_leihfrist from Bibliotheken where name = @bibname)
PRINT CONCAT('Neue Leihgebuehr ist: ' , @neueGeb)

IF(@neueGeb = @gebuehr)
BEGIN
	PRINT 'Prozedur sp_AendereLeihGebuehr funktioniert'

	PRINT CONCAT('Setze die Gebuehr wieder auf ihren urspruenglichen Wert von: ', @tatGeb)
	EXEC sp_AendereLeihGebuehr @ausweisNr, @tatGeb, @bibname
	PRINT 'Prozedur sp_AendereLeihGebuehr wurde ausgefuehrt'

	SET @neueGeb = (select gebuehren_leihfrist from Bibliotheken where name = @bibname)

	PRINT CONCAT('Die Leihgebuehr betraegt nun: ' , @neueGeb)
	
	IF(@neueGeb = @tatGeb)
	BEGIN
		PRINT 'Prozedur sp_AendereLeihGebuehr funktioniert'
	END
	ELSE
	BEGIN
		PRINT 'Prozedur sp_AendereLeihGebuehr schein nicht zu funktioniert'
	END
END
ELSE
BEGIN
	PRINT 'Prozedure sp_AendereLeihGebuehr scheint nicht richtig zu funktionieren'
END


EXEC sp_TestAendereLeihgebuehr 2, 123, 'Stadtbibliothek'