
USE [Bibliothek]
GO
CREATE FUNCTION CheckSignature (@signatur varchar(10))
RETURNS BIT
AS
BEGIN
	DECLARE @count int = (SELECT COUNT(*) FROM Exemplare WHERE p_signatur = @signatur)

	IF(@count > 0)
	BEGIN
		RETURN 1
	END
	ELSE
	BEGIN
		RETURN 0
	END

	RETURN 0
END