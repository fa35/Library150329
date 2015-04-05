-- tests der suchen functionen


USE[Bibliothek]
GO
CREATE PROCEDURE sp_TestSucheBuch @ausweisNr int, @isbn bigint, @titel nvarchar(max), @fachgebiet int
AS
PRINT 'Lege Test-Buch an'

EXEC sp_LegeBuchAn @ausweisNr, @isbn, @titel, @fachgebiet

PRINT CONCAT('Suche Buch - Titel und FachgebietId per ISBN: ', @isbn)

DECLARE @isbnTitel nvarchar(max) = (SELECT titel FROM dbo.GetBuchByIsbn (@isbn));
DECLARE @isbnFach int = (SELECT f_fachgebiet_id FROM dbo.GetBuchByIsbn (@isbn));

PRINT CONCAT('Suche Buch - ISBN und FachgebietId per Titel: ', @titel)

DECLARE @titelIsbn bigint = (SELECT p_ISBN FROM dbo.GetBuchByTitel (@titel));
DECLARE @titelFach int = (SELECT f_fachgebiet_id FROM dbo.GetBuchByTitel (@titel));

PRINT 'Vergleiche Daten'

PRINT CONCAT('Original - Titel : ', @titel)
PRINT CONCAT('per ISBN - Titel : ', @isbnTitel)

IF(@titel = @isbnTitel)
	BEGIN
		PRINT 'Titel stimmen ueberein'
	END
ELSE
	BEGIN
		PRINT 'Titel stimmen nicht ueberein'
	END

PRINT CONCAT('Original - FachgebietID : ', @fachgebiet)
PRINT CONCAT('per ISBN - FachgebietID : ', @isbnFach)
PRINT CONCAT('per Titel - FachgebietID : ', @titelFach)

IF(@fachgebiet = @isbnFach and @fachgebiet = @titelFach)
	BEGIN
		PRINT 'FachgebietIds stimmen ueberein'
	END
ELSE
	BEGIN
		PRINT 'FachgebietIds stimmen nicht ueberein'
	END

PRINT CONCAT('Original - ISBN : ', @isbn)
PRINT CONCAT('per Titel - ISBN : ', @titelIsbn)

IF(@isbn = @titelIsbn)
	BEGIN
		PRINT 'ISBN stimmen ueberein'
	END
ELSE
	BEGIN
		PRINT 'ISBN stimmen nicht ueberein'
	END

PRINT 'Pruefe ob bei dieser FachgebietsID auch die ISBN in der Ergebnistabelle dabei ist'

DECLARE @fachIsbn bigint = (SELECT p_ISBN FROM dbo.GetBuchByFachgebiet(@fachgebiet) where titel = @titel);


PRINT CONCAT('Original - ISBN : ', @isbn)
PRINT CONCAT('per Fachgebiet und Titel - ISBN : ', @fachIsbn)


IF(@isbn = @fachIsbn)
	BEGIN
		PRINT 'ISBN stimmen ueberein'
	END
ELSE
	BEGIN
		PRINT 'ISBN stimmen nicht ueberein'
	END

PRINT 'Loesche Test-Buch'

EXEC sp_LoescheBuch @ausweisNr, @isbn

PRINT 'Suche nach Isbn'

DECLARE @catched int = (SELECT count(*) FROM dbo.GetBuchByIsbn(@isbn));

IF(@catched = 0)
	BEGIN
		PRINT 'Test-Buch wurde geloescht'
	END
ELSE
	BEGIN
		PRINT 'Etwas stimmt nicht'
	END

EXEC sp_TestSucheBuch 2, 9998999499, '###test###suche###buch', 1