-- @license: GPLv2
-- @author: Corinna Rohr

USE[Bibliothek]
GO
CREATE FUNCTION CheckExistingExemplare (@isbn bigint)
RETURNS BIT
AS
BEGIN
	DECLARE @result bit, @count int
	SET @count = (select count(*) from Exemplare where f_ISBN = @isbn)

	IF(@count > 0)
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