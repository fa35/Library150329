USE[Bibliothek]
GO
CREATE FUNCTION CheckKontoLimit (@personenId int)
RETURNS BIT
AS
BEGIN
	DECLARE @result bit, @kontostand smallmoney
	SET @kontostand = (select kontostand from nutzer where p_personen_id = @personenId)

	IF(@kontostand < 100)
		BEGIN
			SET @result = 1;
		END
	ELSE
		BEGIN
			SET @result = 0;
		END
	RETURN @result;
END
GO