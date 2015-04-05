USE [Bibliothek]
GO
IF OBJECT_ID (N'dbo.GetBuchByFachgebiet', N'IF') IS NOT NULL
    DROP FUNCTION dbo.GetBuchByFachgebiet;
GO
CREATE FUNCTION dbo.GetBuchByFachgebiet (@fachgebiet int)
RETURNS TABLE
AS
RETURN 
(
    SELECT b.p_ISBN, b.titel, b.f_fachgebiet_id
    FROM Buecher as b
    WHERE b.f_fachgebiet_id = @fachgebiet
);
GO

SELECT * FROM dbo.GetBuchByFachgebiet (1);
