

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

