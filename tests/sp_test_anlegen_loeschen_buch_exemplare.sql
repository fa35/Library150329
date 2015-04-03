-- anlegen nutzer
-- löschen nutzer
-- anlegen buch / exemplar 
-- löschen buch / exemplar
-- testen der createsignatur - function

-- anlegen nutzer
-- löschen nutzer
-- anlegen buch / exemplar 
-- löschen buch / exemplar
-- testen der createsignatur - function

-- lege buch an / lege exempar an lösche beides wieder

USE [Bibliothek]
GO
CREATE PROCEDURE sp_TestBuchExemplareAnlegenLoeschen @ausweisNr int, @isbn bigint, @titel nvarchar(max), @fachgebiet int

DECLARE @anzBuecherVor int = (select count (*) from Buecher);
PRINT 'Versuche neues Buch anzulegen'
exec sp_LegeBuchAn @ausweisNr, @isbn, @titel, @fachgebiet
PRINT 'Prozedur zum Anlegen eines neuen Buches wurde ausgeführt.'
DECLARE @anzBuecherNach int = (select count (*) from Buecher);
PRINT CONCAT('Anzahl Vor: ', @anzBuecherVor, ' Anzahl Nach: ' , @anzBuecherNach)

IF(@anzBuecherVor < @anzBuecherNach)
	BEGIN
		PRINT 'Prozedur zum Anlegen eines neuen Buches funktioniert.'
		PRINT 'Suche nach der ISBN in der Buecher Tabelle'
		DECLARE @AnzIds int = (select count(*) from Buecher where p_ISBN = @isbn)

		IF(@AnzIds = 1)
			BEGIN
			PRINT 'Die ISBN wurde genau 1-Mal gefunden'
-- neue exemplare
			PRINT 'Versuche ein neues Exemplar zu dem neuen Buch anzulege'
			DECLARE @anzExemVor int = (select count(*) from Exemplare)
			EXEC sp_LegeExemplarAn @ausweisNr, @isbn
			PRINT 'Prozedur zum Anlegen eines neuen Exemplares wurde ausgeführt.'
			DECLARE @anzExemNach int = (select count(*) from Exemplare);
			PRINT CONCAT('Anzahl Vor: ', @anzExemVor, ' Anzahl Nach: ' , @anzExemNach)

			IF(@anzExemVor < @anzExemNach)
				BEGIN
				PRINT 'Prozedur zum Anlegen eines neuen Exemplares funktioniert.'
				PRINT 'Suche nach der Signatur in der Exemplar Tabelle durch'
				DECLARE @signature varchar(10) = (select Top(1) p_signatur from Exemplare where f_ISBN = @isbn);
				SET @AnzIds = (select count(*) from Exemplare where p_signatur = @signature)

				IF(@AnzIds = 1)
					BEGIN
					PRINT 'Die Signatur wurde genau 1-Mal gefunden'
					-- weiteres exemplare
					PRINT 'Versuche weiteres Exemplar anzulegen, um die Signatur zu überprüfen'
					PRINT 'Neue Signatur muss mit 0002 aufhören'
					SET @anzExemVor = @anzExemNach
					EXEC sp_LegeExemplarAn @ausweisNr, @isbn 
					SET @anzExemNach = (select count(*) from Exemplare);
					PRINT CONCAT('Anzahl Vor: ', @anzExemVor, ' Anzahl Nach: ' , @anzExemNach)

					IF(@anzExemVor < @anzExemNach)
					BEGIN
					PRINT 'Prozedur zum Anlegen eines neuen Exemplares funktioniert.'
					PRINT 'Suche nach der Signatur in der Exemplar Tabelle durch'
					DECLARE @newSig varchar(10) = (select Top(1) p_signatur from Exemplare where f_ISBN = @isbn and p_signatur <> @signature);
					PRINT CONCAT('Neue Signatur: ', @newSig)
					SET @AnzIds = (select count(*) from Exemplare where f_ISBN = @isbn)

					IF(@AnzIds = 2)
						BEGIN
						PRINT 'Es wurden genau 2 Signaturen gefunden'
						PRINT 'Prozedure LegeExemplarAn funktioniert, Funktion CreateSignature funktioniert'
						Print 'Versuche zweites Exemplare zu Löschen'
						EXEC sp_LoescheExemplar @ausweisNr, @newSig
						SET @AnzIds = (select count(*) from Exemplare where f_ISBN = @isbn)
						PRINT 'Prozedur zum Löschen des Exemplares wurde ausgeführt'
						
						IF(@AnzIds = 1)
							BEGIN
							PRINT 'Es gibt noch genau ein Exemplar'
							Print 'Versuche anderes Exemplar zu löschen'
							EXEC sp_LoescheExemplar @ausweisNr, @signature
							PRINT 'Prozedur zum Löschen des Exemplares wurde ausgeführt'
							END
						ELSE
							BEGIN
							PRINT 'Etwas stimmt mit der Prozedur zum Löschen von Exemplaren nicht'
							END

						SET @AnzIds = (select count(*) from Exemplare where f_ISBN = @isbn)
						
						IF(@AnzIds = 0)
							BEGIN
							PRINT 'Es gibt kein Exemplar zu dieser ISBN'
							PRINT 'Prozedur zum Löschen von Exemplaren funktioniert'

							-- lösche das buch

							PRINT 'Versuche das neuangelegte Buch wieder zu löschen'
							EXEC sp_LoescheBuch @ausweisNr, @isbn
							PRINT 'Prozedur zum Löschen von Buechern wurde ausgefuehrt'
							SET @AnzIds = (select count(*) from buecher where p_ISBN = @isbn)
							
							IF(@AnzIds = 0)
								BEGIN
								PRINT CONCAT('Es sind keine Buecher mit der ISBN: ', @isbn, ' vorhanden')
								END
							ELSE
								BEGIN
								PRINT 'Etwas stimmt mit der Prozedure zum Löschen von Buechern nicht'
								END
							END
						END
						ELSE
							BEGIN
							PRINT 'Etwas stimmt mit der Prozedur zum Lschen von Exemplaren nicht'
							END

						END
					ELSE
						BEGIN
						Print 'Etwas scheint mit der Prozedure LegeExemplarAn oder der Funktion CreateSignature nicht zu stimmen'
						END
				END
			ELSE
				BEGIN
				Print 'Etwas scheint mit der Prozedure LegeBuchAn nicht zu stimmen'
				END
	END
	ELSE
	BEGIN -- isbn war mehr oder weniger als 1 mal in der buecher tabelle
		PRINT CONCAT('Etwas stimmt nicht!!! Die ISBN: ', @isbn, ' wurde genau: ', @AnzIds, ' gefunden')
	END
END


EXEC sp_TestBuchExemplareAnlegenLoeschen  @ausweisNr int, @isbn bigint, @titel nvarchar(max), @fachgebiet int