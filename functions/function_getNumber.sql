
USE[Bibliothek]
GO
CREATE FUNCTION GetNumber (@anzahl int)
RETURNS varchar(4)
AS
BEGIN

DECLARE @nummer varchar(4) = '0001';

IF (@anzahl > 0)
	BEGIN
		IF @anzahl <= 9
			BEGIN
				SET @nummer = ('000' + @anzahl);
			END
		ELSE IF @anzahl >= 10 and @anzahl < 100
			BEGIN
				SET @nummer = ('00' + @anzahl); 
			END
		ELSE IF @anzahl >= 100 and @anzahl < 1000
			BEGIN
				SET @nummer = ('0' + @anzahl);
			END
		ELSE
			BEGIN 
				SET @nummer = @anzahl
			END
   END

RETURN @nummer

END