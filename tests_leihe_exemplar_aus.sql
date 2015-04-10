-- @license: GPLv2
-- @author: Corinna Rohr


-- test leihe exemplar aus

DECLARE @isbn bigint = 3518260432, @bibname nvarchar(max) = 'Standtbibliothek';

-- x 6 lombard ausweis gesperrt
PRINT 'Versuche Exempar auszuleihen'
PRINT 'Erwartet wird ein Fehler, da Ausweis gesperrt'
EXEC sp_LeiheExemplarAus @isbn, 6, @bibname

-- x 3 siefert überfällige buecher
PRINT 'Versuche Exempar auszuleihen'
PRINT 'Erwartet wird ein Fehler, da ueberfaellige Buecher vorhanden'
EXEC sp_LeiheExemplarAus @isbn, 3, @bibname


-- x 4 meister gebuehren > 10000
PRINT 'Versuche Exempar auszuleihen'
PRINT 'Erwartet wird ein Fehler, da Konto > 100 (bzw. 10000)'
EXEC sp_LeiheExemplarAus @isbn, 4, @bibname

-- x 1 weißer mehr als 10 exempalre
PRINT 'Versuche Exempar auszuleihen'
PRINT 'Erwartet wird ein Fehler, da 10 Exemplare ausgeliehen'
EXEC sp_LeiheExemplarAus @isbn, 1, @bibname


-- x 5 fischer exemplar bereits ausgeliehen
PRINT 'Versuche Exempar auszuleihen'
PRINT 'Erwartet wird ein Fehler, da Exempar bereits ausgeliehen'
EXEC sp_LeiheExemplarAus @isbn, 5, @bibname



-- x 2 krög funktioniert
PRINT 'Versuche Exempar auszuleihen'
PRINT 'Erwartet wird das es funktioniert'
EXEC sp_LeiheExemplarAus @isbn, 2, @bibname

