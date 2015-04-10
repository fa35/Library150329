-- @license: GPLv2
-- @author: Corinna Rohr


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

		IF(@signature IS NULL OR LEN(@signature) < 10)
		BEGIN
			DECLARE @anzExem int = (select  count(*) from Exemplare)
			SET @signature = CONVERT(varchar(10), (@anzExem + 1))
		END

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

IF (@mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		DECLARE @existing bit = dbo.CheckExemparAusgeliehen (@signatur)

		IF(@existing > 0)
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
