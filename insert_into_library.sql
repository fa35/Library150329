-- @license: GPLv2
-- @author: Corinna Rohr



USE [Bibliothek]

GO
INSERT INTO Oeffnungszeiten ( p_wochentag, von, bis)
VALUES ( 1, '10:30:00', '17:00:00'),(2,'11:00:00', '20:00:00'),( 3, '09:00:00', '16:00:00'),(4,'09:00:00', '16:00:00'), ( 5, '09:00:00', '18:00:00'),(6,'10:00:00', '14:00:00')

GO

INSERT INTO Bibliotheken
(
	p_bibliothek_id, name, ort, gebuehren_jahr, gebuehren_leihfrist, leihfrist_wochen
)
VALUES ( 1, 'Stadtbibliothek', 'Mitte', 3000, 250, 2 ), ( 2, 'Charlottenbibliothek', 'Charlottenburg', 4000, 2000, 1 )
GO

INSERT INTO Fachgebiete ( p_fachgebiet_id, name, kuerzel )
VALUES ( 1, 'Programmierung', 'PROG' ), ( 2, 'Wissen', 'WISS')
GO

INSERT INTO Buecher ( p_ISBN, titel, f_fachgebiet_id )
VALUES ( 3897215675, 'Weniger schlecht programmieren', 1 ), (3499624249, 'Dinge geregelt kriegen - ohne einen Funken Selbstdisziplin', 2) , 
(3499622300 , 'Lexikon des Unwissens: Worauf es bisher keine Antwort gibt', 2), ( 3871347558, 'Internet - Segen oder Fluch', 1), 
(3871346985, 'Das neue Lexikon des Unwissens: Worauf es bisher keine Antwort gibt', 2)

GO

INSERT INTO Exemplare ( p_signatur, f_ISBN )
VALUES ('WISP0001', 3499624249), ('WISP0002', 3499624249)
GO

INSERT INTO Autoren ( p_autor_id, vorname, name)
VALUES (1, 'Kathrin', 'Passig'), (2, 'Peter', 'Lustig'), (3, 'Hannelore', 'Haberstroh')
GO

INSERT INTO Buecher_Autoren (pf_autor_id, pf_isbn)
VALUES (1, 3499624249),(1,3871347558),(1,3871346985)
GO

INSERT INTO Nutzer
(p_personen_id, mitarbeiter, vorname, name, geburtsdatum, kontostand)
VALUES
(1, 0, 'Melanie', 'Weißer', '14.12.1987', 200), (2, 1, 'Bruno', 'Krög', '22.07.1967', 0),
(3, 0, 'Nadine', 'Siefert', '02.01.1977', 0), (4, 0, 'George', 'Meister', '18.11.1990', 200),
(5, 1, 'Moritz', 'Fischer', '03.03.1985', 0), (6, 0, 'Henry', 'Lombard', '11.04.1984', 500)
GO

INSERT INTO Ausgeliehene_Exemplare (pf_signatur, pf_personen_id, rueckgabe_datum, anzahl_verlaengerungen)
VALUES ('WISP0001', 4, '24.02.2015', 0)

INSERT INTO Vorbestellte_Buecher (pf_isbn, pf_personen_id)
VALUES (3897215675, 5)

INSERT INTO Ausweise (pf_personen_id, ausweisnr, passwort, gueltigBis, gesperrt)
VALUES (1, 1, 'fish', '01.01.2020', 0), (2, 2, 'gammelf', '01.01.2018', 0) ,
(3, 3, 'sh324', '01.01.2025', 0), (4, 4, '6a54df', '01.01.2016', 0),
(5, 5, 'is325h', '01.01.2012', 1), (6, 6, 'fasf23h', '01.01.2013', 1)