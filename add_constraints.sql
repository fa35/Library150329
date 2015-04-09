-- @license: GPLv2
-- @author: Corinna Rohr

-- Oeffnungszeiten: von < bis
ALTER TABLE Oeffnungszeiten
ADD CONSTRAINT ct_bis CHECK (von < bis)

-- Leihfrist mindestens 1 Wochen
ALTER TABLE Bibliotheken
ADD CONSTRAINT ct_leihwochen CHECK (leihfrist_wochen >= 1)

-- Gebuehren >= 0
ALTER TABLE Bibliotheken
ADD CONSTRAINT ct_jahresgebuehr CHECK (gebuehren_jahr >= 0)

ALTER TABLE Bibliotheken
ADD CONSTRAINT ct_leihgebuehr CHECK (gebuehren_leihfrist >= 0)

-- max. 2 Verlaengerungen
ALTER TABLE Ausgeliehene_Exemplare
ADD CONSTRAINT ct_anzahlmax CHECK (anzahl_verlaengerungen <= 2)

