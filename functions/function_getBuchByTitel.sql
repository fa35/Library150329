USE [Bibliothek]
GO
IF OBJECT_ID (N'dbo.GetBuchByTitel', N'IF') IS NOT NULL
    DROP FUNCTION dbo.GetBuchByTitel;
GO
CREATE FUNCTION dbo.GetBuchByTitel (@titel nvarchar(max))
RETURNS TABLE
AS
RETURN 
(
    SELECT b.p_ISBN, b.titel, b.f_fachgebiet_id
    FROM Buecher as b
    WHERE b.titel like '%'+@titel+'%'
);
GO

SELECT * FROM dbo.GetBuchByTitel ('Wissen');
