-- @license: GPLv2
-- @author: Corinna Rohr

USE[Bibliothek]
GO
CREATE FUNCTION CheckUeberfaelligeExemplare(@personenId int)
RETURNS BIT
AS
BEGIN

	DECLARE @test int = (
		select count(*) from Ausgeliehene_Exemplare where pf_personen_id = @personenId and rueckgabe_datum <= GETDATE()
	)

	IF(@test = 0)
	BEGIN
		RETURN 0
	END

	RETURN 1
END