USE[Bibliothek]
GO
CREATE FUNCTION GetMitarbeiterBit (@ausweisNr int)
RETURNS bit
AS
BEGIN
DECLARE @personenId int = (select pf_personen_id from Ausweise where ausweisnr = @ausweisNr),
@bit bit;

IF (@personenId >= 1)
	BEGIN
		SET @bit = (SELECT mitarbeiter FROM Nutzer WHERE p_personen_id = @personenId)
	END
ELSE
	BEGIN
		SET @bit = 0
	END
	RETURN @bit
END
GO