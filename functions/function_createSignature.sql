-- @license: GPLv2
-- @author: Corinna Rohr

USE[Bibliothek]
GO
CREATE FUNCTION CreateSignature (@fachgebietId int, @isbn bigint)
RETURNS varchar(10)
AS
BEGIN
DECLARE @kuezel varchar(3) = (select SUBSTRING(kuerzel, 1, 3) from Fachgebiete where p_fachgebiet_id = @fachgebietId)
DECLARE @name varchar(1) = (select SUBSTRING(name, 1,1) from Autoren where p_autor_id = (select pf_autor_id from Buecher_Autoren where pf_isbn = @isbn))
DECLARE @anzahl int = (select count(*) from Exemplare where f_ISBN = @isbn);
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
			SET @nummer = @anzahl;
		END
END

RETURN (@kuezel + @name + @nummer)
END
GO