
-- aendere die jahres gebuehr


USE[Bibliothek]
GO
CREATE PROCEDURE sp_AendereJahresGebuehr @ausweisNr int, @gebuehr smallmoney, @bibId int
AS
DECLARE @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr);
IF (@mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		UPDATE [dbo].[Bibliotheken] SET [gebuehren_jahr] = @gebuehr WHERE p_bibliothek_id = @bibId
	END
GO


EXEC sp_AendereJahresGebuehr 2, 35, 2



-- andere die ausleih gebuehr

USE[Bibliothek]
GO
CREATE PROCEDURE sp_AendereLeihGebuehr @ausweisNr int, @gebuehr smallmoney, @bibId int
AS
DECLARE @mitarbeiter bit = dbo.GetMitarbeiterBit(@ausweisNr);
IF (@mitarbeiter = 0)
	BEGIN 
		PRINT 'Sie sind nicht berechtigt'
	END
ELSE
	BEGIN
		UPDATE [dbo].[Bibliotheken] SET [gebuehren_leihfrist] = @gebuehr WHERE p_bibliothek_id = @bibId
	END
GO


EXEC sp_AendereLeihGebuehr 2, 5, 2
