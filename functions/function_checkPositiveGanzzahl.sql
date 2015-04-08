
-- Wie kann man herausfinden ob der Wert einer Ganzzahl entspricht?

USE[Bibliothek]
GO
CREATE FUNCTION CheckPositiveGanzzahl (@wert smallmoney)
RETURNS BIT
AS
BEGIN

DECLARE @result bit;

IF((@wert >= 0) AND ((@wert - @wert) = 0))
	BEGIN 
		-- Wert ist positiv und Ganzzahl
		SET @result = 1;
	END
ELSE
	BEGIN
		-- Wert ist negativ oder keine Ganzzahl
		SET @result = 0;
	END

	RETURN @result;
END
GO