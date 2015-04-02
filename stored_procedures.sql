-- Aufgabe 3 - Prozeduren:


-- Suche der Bücher ohne Ausweis möglich

USE[Bibliothek]
GO

CREATE PROCEDURE sp_SucheBuecherNachISBN (@pattern nvarchar)
AS
SELECT * 
FROM Buecher
WHERE p_ISBN = @pattern

GO

CREATE PROCEDURE sp_SucheBuecherNachTitel (@pattern nvarchar)
AS
SELECT *
FROM Buecher
WHERE titel like '%'+@pattern+'%'

GO

CREATE PROCEDURE sp_SucheBuecherNachFachgebietId (@pattern nvarchar)
AS
SELECT * 
FROM Buecher
WHERE f_fachgebiet_id = @pattern

GO


-- rückgabe der bücher ist ohne ausweis möglich