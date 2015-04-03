-- aendere leihfrist / die ausleihwochen

USE[Bibliothek]
GO
CREATE PROCEDURE sp_AendereLeihfrist @ausweisNr int, @leihwochen tinyint, @bibId int
AS
DECLARE @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr);
IF (@mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		UPDATE [dbo].[Bibliotheken] SET [leihfrist_wochen] = @leihwochen WHERE p_bibliothek_id = @bibId
	END
GO


EXEC sp_AendereLeihfrist 2, 3, 2

