USE[Bibliothek]
GO
CREATE FUNCTION GetAnzahlAusgeliehenerExemplare (@isbn bigint)
RETURNS int
AS
BEGIN
	DECLARE @anzahl int = (
							select count (*) from Ausgeliehene_Exemplare where pf_signatur in ( 
										select p_signatur from exemplare where f_ISBN = @isbn)
						  )
	return @anzahl
END
GO