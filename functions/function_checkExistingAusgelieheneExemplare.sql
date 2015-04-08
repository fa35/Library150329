USE [Bibliothek]
GO
CREATE FUNCTION [dbo].[CheckExistingAusgelieheneExemplare] (@isbn bigint)
RETURNS BIT
AS
BEGIN

DECLARE @result bit = 0;
DECLARE @anzExemplare int = (select count(*) from Exemplare where f_ISBN = @isbn)

IF(@anzExemplare = 0)
BEGIN
	RETURN @result;
END
ELSE
BEGIN
	-- fuehr jedes exempar nachsehe ob es ausgeleiehen ist

	DECLARE @i int = 0, @countAusgeliehen int = 0;
	DECLARE @signatur varchar(10)

	WHILE (@i < @anzExemplare)
	BEGIN
		-- hole sigatur zum prüfen ob diese signatur bei ausgeliehen_exemparen auftaucht
		SET @signatur = (SELECT p_signatur FROM Exemplare WHERE f_ISBN = @isbn 
						ORDER BY p_signatur asc OFFSET @i ROWS FETCH NEXT 1 ROWS ONLY )
						-- OFFSET @i ROWS = SKIP @i / FETCH NEXT 1 ROWS ONLY = TAKE 1
		-- suchen nach der signatur
		DECLARE @existing int = (SELECT COUNT(*) FROM Ausgeliehene_Exemplare WHERE pf_signatur = @signatur)

		-- wenn existing > 0 => @countAusgeliehen +1
		
		IF(@existing > 0)
		BEGIN 
			SET @result = 1 -- = false
			RETURN @result -- wenn ein exempar noch ausgeliehen ist können wir schon abbbrechen
			BREAK
		END
		
		SET @i = (@i +1)

	END

		RETURN @result;
END
	RETURN @result;
END
