-- Aufgabe 3 - Prozeduren:


-- Suche der Bücher ohne Ausweis möglich

USE[Bibliothek]
GO
CREATE PROCEDURE sp_SucheBuecherNachISBN (@pattern bigint)
AS
SELECT * 
FROM Buecher
WHERE p_ISBN = @pattern
GO
EXEC sp_SucheBuecherNachISBN 3499624249


USE[Bibliothek]
GO
CREATE PROCEDURE sp_SucheBuecherNachTitel (@pattern nvarchar)
AS
SELECT *
FROM Buecher
WHERE titel like '%'+@pattern+'%'
GO
EXEC sp_SucheBuecherNachTitel 'Dinge geregelt kriegen'


USE[Bibliothek]
GO
CREATE PROCEDURE sp_SucheBuecherNachFachgebietId (@pattern int)
AS
SELECT * 
FROM Buecher
WHERE f_fachgebiet_id = @pattern
GO
EXEC sp_SucheBuecherNachFachgebietId 1


-- rückgabe der bücher ist ohne ausweis möglich