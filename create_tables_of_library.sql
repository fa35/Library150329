CREATE TABLE Fachgebiete
(
	p_fachgebiet_id INTEGER NOT NULL PRIMARY KEY,
	name NVARCHAR(MAX) NOT NULL,
	kuerzel CHAR(4) NOT NULL UNIQUE,
)

CREATE TABLE Autoren
(
	p_autor_id INTEGER NOT NULL PRIMARY KEY,
	vorname NVARCHAR(MAX) NOT NULL,
	name NVARCHAR(MAX) NOT NULL,
)

CREATE TABLE Oeffnungszeiten
(
	p_wochentag INTEGER NOT NULL PRIMARY KEY,
	von TIME,
	bis TIME,
)

CREATE TABLE Bibliotheken
(
	p_bibliothek_id INTEGER NOT NULL PRIMARY KEY,
	name NVARCHAR(MAX) NOT NULL,
	ort NVARCHAR(MAX) NOT NULL,
	gebuehren_jahr SMALLMONEY,
	gebuehren_leihfrist SMALLMONEY,
	leihfrist_wochen TINYINT,
)

CREATE TABLE Nutzer
(
	p_personen_id INTEGER NOT NULL PRIMARY KEY,
	mitarbeiter BIT NOT NULL,
	vorname NVARCHAR(MAX) NOT NULL,
	name NVARCHAR(MAX) NOT NULL,
	geburtsdatum DATE,
	kontostand SMALLMONEY,
)

CREATE TABLE Ausweise
(
	pf_personen_id INTEGER NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES NUTZER(p_personen_id) ON UPDATE CASCADE ON DELETE CASCADE,
	ausweisnr INTEGER NOT NULL UNIQUE,
	passwort VARCHAR(16) NOT NULL,
	gueltigBis DATE NOT NULL,
	gesperrt BIT NOT NULL,
)

CREATE TABLE Buecher
(
	p_ISBN BIGINT NOT NULL PRIMARY KEY,
	titel NVARCHAR(MAX) NOT NULL,
	f_fachgebiet_id INTEGER FOREIGN KEY REFERENCES Fachgebiete(p_fachgebiet_id) ON UPDATE CASCADE,
)

CREATE TABLE Exemplare
(
	p_signatur VARCHAR(10) PRIMARY KEY,
	f_ISBN BIGINT NOT NULL FOREIGN KEY REFERENCES Buecher(p_ISBN) ON UPDATE CASCADE,
)

CREATE TABLE Ausgeliehene_Exemplare
(
	pf_signatur VARCHAR(10) FOREIGN KEY REFERENCES Exemplare(p_signatur) ON UPDATE CASCADE,
	pf_personen_id INTEGER FOREIGN KEY REFERENCES Nutzer(p_personen_id) ON UPDATE CASCADE,
	rueckgabe_datum DATE NOT NULL,
	anzahl_verlaengerungen TINYINT,
	PRIMARY KEY (pf_signatur, pf_personen_id),
)

CREATE TABLE Vorbestellte_Buecher
(
	pf_isbn BIGINT NOT NULL FOREIGN KEY REFERENCES Buecher(p_ISBN) ON UPDATE CASCADE,
	pf_personen_id INTEGER FOREIGN KEY REFERENCES Nutzer(p_personen_id) ON UPDATE CASCADE,
	PRIMARY KEY (pf_isbn, pf_personen_id)
	)

CREATE TABLE Buecher_Autoren
(
	pf_autor_id INTEGER NOT NULL FOREIGN KEY REFERENCES Autoren(p_autor_id) ON UPDATE CASCADE ON DELETE CASCADE,
	pf_isbn BIGINT NOT NULL FOREIGN KEY REFERENCES Buecher(p_ISBN) ON UPDATE CASCADE,
	PRIMARY KEY (pf_autor_id, pf_isbn)
)

-- https://msdn.microsoft.com/en-us/library/jj851200%28v=vs.103%29.aspx 
