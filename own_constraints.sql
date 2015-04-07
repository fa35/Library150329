ALTER TABLE Exemplare
ADD CONSTRAINT ct_f_isbn_cascade FOREIGN KEY (f_ISBN) 
	REFERENCES Buecher (p_ISBN) ON DELETE CASCADE


ALTER TABLE Buecher
ADD CONSTRAINT ct_f_fachgebiet_cascade FOREIGN KEY (f_fachgebiet_id)
	REFERENCES Fachgebiete (p_fachgebiet_id) ON DELETE CASCADE


ALTER TABLE Ausgeliehene_Exemplare
ADD CONSTRAINT ct_pf_sig_cascade FOREIGN KEY (pf_signatur)
	REFERENCES Exemplare (p_signatur) ON DELETE CASCADE
	
ALTER TABLE Ausgeliehene_Exemplare
ADD CONSTRAINT ct_pf_personen_cascade FOREIGN KEY (pf_personen_id)
	REFERENCES Nutzer (p_personen_id) ON DELETE CASCADE


--ALTER TABLE Ausweise
--ADD CONSTRAINT ct_pf_persAusweise_cascade FOREIGN KEY (pf_personen_id)
--	REFERENCES Nutzer (p_personen_id) ON DELETE CASCADE

-- Meldung 1785, Ebene 16, Status 0, Zeile 1
-- Das Einführen der FOREIGN KEY-Einschränkung 'ct_pf_persAusweise_cascade' für die Ausweise-Tabelle 
-- kann Schleifen oder mehrere Kaskadepfade verursachen. Geben Sie ON DELETE NO ACTION oder ON UPDATE NO ACTION
-- an, oder ändern Sie andere FOREIGN KEY-Einschränkungen.
-- Meldung 1750, Ebene 16, Status 0, Zeile 1
-- Die Einschränkung konnte nicht erstellt werden. Siehe vorherige Fehler.

-- constraint fuer autoren_id funktioniert nicht, siehe oben
ALTER TABLE Buecher_Autoren
ADD CONSTRAINT ct_buchautor_id_cascade FOREIGN KEY (pf_autor_id)
	REFERENCES Autoren (p_autor_id) ON UPDATE NO ACTION ON DELETE CASCADE

ALTER TABLE Buecher_Autoren
ADD CONSTRAINT ct_buchaut_isbn_cascade FOREIGN KEY (pf_isbn)
	REFERENCES Buecher (p_ISBN) ON DELETE CASCADE


ALTER TABLE Vorbestellte_Buecher
ADD CONSTRAINT ct_vorbisbn_cascade FOREIGN KEY (pf_isbn)
	REFERENCES Buecher (p_ISBN) ON DELETE CASCADE

ALTER TABLE Vorbestellte_Buecher
ADD CONSTRAINT ct_vorbper_cascade FOREIGN KEY (pf_personen_id)
	REFERENCES Nutzer (p_personen_id) ON DELETE CASCADE