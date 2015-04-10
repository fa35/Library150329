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

DECLARE @sig varchar(10), @nummer varchar(4), @exists bit = 1;

WHILE @exists = 1
BEGIN
	SET @nummer = dbo.GetNumber (@anzahl)
	DECLARE @preSig varchar(10) = (@kuezel + @name + @nummer) 
	
	SET @exists = dbo.CheckSignature (@preSig)

	SET @sig = @preSig
	SET @anzahl = (@anzahl + 1)
	
END

	RETURN @sig

END





EXEC sp_TestAnlegenLoeschenExemplar 2, 3871347558
--EXEC sp_LegeExemplarAn 2, 3871347558
