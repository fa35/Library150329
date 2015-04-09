-- @license: GPLv2
-- @author: Corinna Rohr

USE[Bibliothek]
GO
CREATE FUNCTION CheckExemparAusgeliehen (@signatur varchar(10))
RETURNS BIT
AS
BEGIN
	DECLARE @anzahl int = (SELECT COUNT(*) FROM Ausgeliehene_Exemplare WHERE pf_signatur = @signatur)

	IF(@anzahl > 0)
		BEGIN
			RETURN 1
		END
	RETURN 0	
END
GO