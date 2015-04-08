-- @license: GPLv2
-- @author: Corinna Rohr

USE [Bibliothek]
GO
IF OBJECT_ID (N'dbo.GetBuchByIsbn', N'IF') IS NOT NULL
    DROP FUNCTION dbo.GetBuchByIsbn;
GO
CREATE FUNCTION dbo.GetBuchByIsbn (@isbn bigint)
RETURNS TABLE
AS
RETURN 
(
    SELECT b.p_ISBN, b.titel, b.f_fachgebiet_id
    FROM Buecher as b
    WHERE b.p_ISBN = @isbn
);
GO

SELECT * FROM dbo.GetBuchByIsbn (3518260432);
