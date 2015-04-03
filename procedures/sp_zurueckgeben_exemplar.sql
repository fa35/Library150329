-- Rückgabe der Bücher bzw. da Exemplare ausgeliehen werden, Exemplare, ist ohne Ausweis möglich

USE [Bibliothek]
GO
CREATE PROCEDURE sp_GebeExemplarZurueck (@signature varchar(10))
AS
DELETE FROM Ausgeliehene_Exemplare
WHERE pf_signatur = @signature
GO

EXEC sp_GebeExemplarZurueck 'WISP0001'
