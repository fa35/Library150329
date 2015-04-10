-- @license: GPLv2
-- @author: Corinna Rohr

USE[Bibliothek]
GO
CREATE FUNCTION CheckKontoLimit (@personenId int)
RETURNS BIT
AS
BEGIN
	DECLARE @result bit, @kontostand smallint
	SET @kontostand = (select kontostand from nutzer where p_personen_id = @personenId)

	IF(@kontostand < 10000)
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