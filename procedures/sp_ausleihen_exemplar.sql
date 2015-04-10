-- @license: GPLv2
-- @author: Corinna Rohr


USE[Bibliothek]
GO

CREATE PROCEDURE sp_LeiheExemplarAus (@isbn bigint, @ausweisNr int, @name nvarchar(max))
AS
DECLARE @signatur varchar(10), @personenId int;

SET @signatur = (select Top(1) p_signatur from Exemplare where f_ISBN = @isbn and p_signatur not in (select pf_signatur from Ausgeliehene_Exemplare )) -- = signatur des exemplares

SET @personenId = (select pf_personen_id from Ausweise where ausweisnr = @ausweisNr)

-- ausweis gültig

DECLARE @b bit = dbo.GetAusweisGesperrt (@personenId)

IF(@b = 1)
BEGIN
	PRINT 'Der Ausweis ist gesperrt'
END
ELSE
BEGIN

	-- keine überfälligen buecher

	select * from Ausgeliehene_Exemplare
	SET @b = dbo.CheckUeberfaelligeExemplare (@personenId)

	IF(@b = 1)
	BEGIN
		PRINT 'Es sind noch Bücher fällig'
	END
	ELSE
	BEGIN
		
		-- check konto

		SET @b = dbo.CheckKontoLimit (@personenId)

		IF(@b = 0)
		BEGIN
			PRINT 'Der Kontostand ist ueber 10000'
		END
		ELSE
		BEGIN

			-- anzahl der ausge. exempolare max. 10 , davo max. 1 pro buch
			DECLARE @count int = (select count(*) from Ausgeliehene_Exemplare where pf_personen_id = @personenId) 

			IF(@count >= 10)
			BEGIN
				PRINT 'Es sind schon 10 oder mehr Exemplare ausgeliehen'
			END
			ELSE
			BEGIN

			-- max 1. exemplar pro buch

			DECLARE @ex int = (select count(*) from Exemplare where f_ISBN = @isbn and p_signatur in (
					select pf_signatur from Ausgeliehene_Exemplare where pf_personen_id = @personenId )
			)

			IF(@ex > 0)
				BEGIN
					PRINT 'Es wurde bereits ein Exemplare dieses Buches ausgeliehen'
				END
			ELSE
				BEGIN

				-- vorbestetll ? 
				
					DECLARE @vorBestellt int = (select count(*) from Vorbestellte_Buecher where pf_isbn = @isbn)
					IF(@vorBestellt > 0)
					BEGIN
						PRINT 'Buch bereits vorbestellt'
					END
					ELSE
					BEGIN
						DECLARE @leihWochen tinyint, @rueckgabeDatum date;
						SET @leihWochen = (select leihfrist_wochen from Bibliotheken where name = @name) -- = leihwochen
						SET @rueckgabeDatum = DATEADD(WEEK,1,GETDATE())

						INSERT INTO [dbo].[Ausgeliehene_Exemplare]
							   ([pf_signatur]
							   ,[pf_personen_id]
							   ,[rueckgabe_datum]
							   ,[anzahl_verlaengerungen])
							VALUES
							(@signatur, @personenId, @rueckgabeDatum,0 )
					END
				END
			END
		END
	END
END


EXEC sp_LeiheExemplarAus @isbn, @ausweisNr, @name 





EXEC sp_LeiheExemplarAus 3499624249, 4, 'Stadtbibliothek'