USE[Bibliothek]
GO
CREATE FUNCTION GetAusweisGesperrt (@personenId int)
RETURNS BIT
AS
BEGIN
	RETURN (select gesperrt from Ausweise where pf_personen_id = @personenId);
END
GO