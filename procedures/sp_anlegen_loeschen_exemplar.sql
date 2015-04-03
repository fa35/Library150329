
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

