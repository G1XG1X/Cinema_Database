DROP DATABASE IF EXISTS KINO;
CREATE DATABASE KINO;
USE KINO;

-- Tabela Film
CREATE TABLE Film (
    FIL_ID INT PRIMARY KEY AUTO_INCREMENT,
    FIL_TYTUL VARCHAR(50) NOT NULL,
    FIL_DLUGOSC VARCHAR(10) NOT NULL
);

-- Tabela Sala Zwykła
CREATE TABLE Sala_Zwykla (
    SZW_ID INT PRIMARY KEY AUTO_INCREMENT,
    SZW_ILOSC_MIEJSC INT NOT NULL,
    SZW_NUMER_SALI VARCHAR(10) UNIQUE NOT NULL
);

-- Tabela Sala 3D
CREATE TABLE Sala_3D (
    STD_ID INT PRIMARY KEY AUTO_INCREMENT,
    STD_ILOSC_MIEJSC INT NOT NULL,
    STD_NUMER_SALI VARCHAR(10) UNIQUE NULL
);

-- Tabela Seans
CREATE TABLE Seans (
    SEA_ID INT PRIMARY KEY AUTO_INCREMENT,
    FIL_ID INT,
    SZW_ID INT,
    STD_ID INT,
    SEA_DATA DATE NOT NULL,
    SEA_NAPISY ENUM('TAK', 'NIE', 'BRAK') DEFAULT 'BRAK',
    CONSTRAINT fk_film_seans FOREIGN KEY (FIL_ID) REFERENCES Film(FIL_ID),
    CONSTRAINT fk_szw_seans FOREIGN KEY (SZW_ID) REFERENCES Sala_Zwykla(SZW_ID),
    CONSTRAINT fk_std_seans FOREIGN KEY (STD_ID) REFERENCES Sala_3D(STD_ID)
);

-- Tabela Klient
CREATE TABLE Klient (
    KLI_ID INT PRIMARY KEY AUTO_INCREMENT,
    KLI_IMIE VARCHAR(40) NOT NULL,
    KLI_NAZWISKO VARCHAR(40) NOT NULL,
    KLI_TELEFON VARCHAR(20) DEFAULT NULL
);

-- Tabela Bilet Normalny
CREATE TABLE Bilet_Normalny (
    BNM_ID INT PRIMARY KEY AUTO_INCREMENT,
    SEA_ID INT NOT NULL,
    KLI_ID INT NOT NULL,
    BNM_MIEJSCE INT NOT NULL,
    BNM_CENA DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (SEA_ID) REFERENCES Seans(SEA_ID),
    FOREIGN KEY (KLI_ID) REFERENCES Klient(KLI_ID)
);

-- Tabela Bilet Ulgowy
CREATE TABLE Bilet_Ulgowy (
    BUL_ID INT PRIMARY KEY AUTO_INCREMENT,
    SEA_ID INT NOT NULL,
    KLI_ID INT NOT NULL,
    BUL_MIEJSCE INT NOT NULL,
    BUL_CENA DECIMAL(10, 2) NOT NULL,
    BUL_RODZAJ_ZNIZKI VARCHAR(50) NOT NULL,
    FOREIGN KEY (SEA_ID) REFERENCES Seans(SEA_ID),
    FOREIGN KEY (KLI_ID) REFERENCES Klient(KLI_ID)
);

INSERT INTO Film (FIL_TYTUL, FIL_DLUGOSC)
VALUES
    ('Incepcja', '148  min'),('Interstellar', '169  min'),('Pulp Fiction', '154 min'),('Forrest Gump', '142 min'),('Matrix', '136 min'),
    ('Shawshank Redemption', '142 min'),('The Dark Knight', '152 min'),('Fight Club', '139 min'),('The Lord of the Rings: The Fellowship of the Ring', '178 min'),
    ('The Godfather', '175 min'),('Schindler''s List', '195 min'),('The Matrix', '136 min'),('The Lord of the Rings: The Return of the King', '201 min'),
    ('Titanic', '195 min'),('Gladiator', '155 min'),('The Green Mile', '189 min'),('Avatar', '162 min'),('Inglourious Basterds', '153 min'),
    ('The Silence of the Lambs', '118 min'),('The Prestige', '130 min'),('The Departed', '151 min'),('Back to the Future', '116 min'),('Jurassic Park', '127 min'),
    ('The Lion King', '88 min'),('The Sixth Sense', '107 min');
    
    
    -- Wstawianie danych do tabeli Sala_Zwykla
INSERT INTO Sala_Zwykla (SZW_ILOSC_MIEJSC, SZW_NUMER_SALI)
VALUES
    (100, '30A'),(80, '5H'),(120, '22C'),(90, '15B'),(110, '10D'),(95, '18E'),(105, '25F'),
    (85, '12G'),(115, '20J'),(175, '8K'),(125, '35L'),(70, '3M'),(130, '40N'),(60, '1P'),
    (135, '45Q'),(150, '2R'),(140, '50S'),(40, '5T'),(145, '55U'),(30, '6V'),(150, '60W'),
    (20, '7X'),(155, '65Y'),(10, '8Z'),(160, '70AA');

INSERT INTO Sala_3D (STD_ILOSC_MIEJSC, STD_NUMER_SALI)
VALUES
    (50, '3D1'),(55, '3D2'),(60, '3D3'),(40, '3D4'),(45, '3D5'),(55, '3D6'),(58, '3D7'),
    (52, '3D8'),(48, '3D9'),(53, '3D10'),(56, '3D11'),(49, '3D12'),(58, '3D13'),(59, '3D14'),(50, '3D15');


INSERT INTO Seans (FIL_ID, SZW_ID, STD_ID, SEA_DATA, SEA_NAPISY)
SELECT 
    F.FIL_ID,
    SZ.SZW_ID,
    CASE WHEN RAND() < 0.5 THEN NULL ELSE SD.STD_ID END,
    DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY),
    CASE WHEN RAND() < 0.3 THEN 'TAK' WHEN RAND() < 0.6 THEN 'NIE' ELSE 'BRAK' END
FROM 
    Film F
JOIN 
    Sala_Zwykla SZ ON FLOOR(RAND() * (SELECT COUNT(*) FROM Sala_Zwykla)) + 1 = SZ.SZW_ID
LEFT JOIN 
    Sala_3D SD ON FLOOR(RAND() * (SELECT COUNT(*) FROM Sala_3D)) + 1 = SD.STD_ID
ORDER BY RAND()
;


INSERT INTO Klient (KLI_IMIE, KLI_NAZWISKO, KLI_TELEFON)
VALUES
    ('Janusz', 'Kowalski', '883567871'),('Alicja', 'Nowak', '987654312'),('Piotr', 'Zieliński', NULL),('Katarzyna', 'Wiśniewska', '234567891'),
    ('Michał', 'Lewandowski', '345678912'),('Anna', 'Dąbrowska',NULL),('Tomasz', 'Wójcik', '567891234'),('Magdalena', 'Kamińska', '678912345'),
    ('Marcin', 'Kowalczyk', NULL),('Monika', 'Szymańska', '891234567'),('Łukasz', 'Woźniak', NULL),('Karolina', 'Jaworska', '123987654'),
    ('Damian', 'Michalski', '234876543'),('Natalia', 'Kaczmarek', '345765432'),('Jakub', 'Piotrowski', '456654321'),('Aleksandra', 'Grabowska', NULL),
    ('Mariusz', 'Pawlak', NULL),('Patrycja', 'Olszewska', '789321098'),('Robert', 'Jasiński', '890210987'),
    ('Dominika', 'Mazurek', NULL);


INSERT INTO Bilet_Normalny (SEA_ID, KLI_ID, BNM_MIEJSCE, BNM_CENA)
SELECT 
    S.SEA_ID,
    K.KLI_ID,
    FLOOR(RAND() * (SELECT SZW_ILOSC_MIEJSC FROM Sala_Zwykla WHERE SZW_ID = S.SZW_ID)) + 1,
    20.00 + (RAND() * 10.00)
FROM 
    Seans S
JOIN 
    Klient K ON FLOOR(RAND() * (SELECT COUNT(*) FROM Klient)) + 1 = K.KLI_ID
ORDER BY RAND()
;

INSERT INTO Bilet_Ulgowy (SEA_ID, KLI_ID, BUL_MIEJSCE, BUL_CENA, BUL_RODZAJ_ZNIZKI)
SELECT 
    S.SEA_ID,
    K.KLI_ID,
    FLOOR(RAND() * (SELECT SZW_ILOSC_MIEJSC FROM Sala_Zwykla WHERE SZW_ID = S.SZW_ID)) + 1,
    15.00 + (RAND() * 5.00),
    CASE WHEN RAND() < 0.5 THEN 'Student' WHEN RAND() < 0.8 THEN 'Senior' ELSE 'Inwalida' END
FROM 
    Seans S
JOIN 
    Klient K ON FLOOR(RAND() * (SELECT COUNT(*) FROM Klient)) + 1 = K.KLI_ID
ORDER BY RAND()
;

DELIMITER //
CREATE FUNCTION get_film_revenue(film_id INT)
RETURNS VARCHAR(100)
BEGIN
    DECLARE revenue_normal DECIMAL(10, 2);
    DECLARE revenue_ulgowy DECIMAL(10, 2);
    
    SELECT SUM(BNM_CENA) INTO revenue_normal
    FROM Bilet_Normalny BN
    JOIN Seans S ON BN.SEA_ID = S.SEA_ID
    WHERE S.FIL_ID = film_id;
     
    SELECT SUM(BUL_CENA) INTO revenue_ulgowy
    FROM Bilet_Ulgowy BU
    JOIN Seans S ON BU.SEA_ID = S.SEA_ID
    WHERE S.FIL_ID = film_id;
    
    RETURN CONCAT('Normalny: ', revenue_normal, ', Ulgowy: ', revenue_ulgowy);
END//
DELIMITER ;

CREATE VIEW top_films AS
SELECT F.FIL_TYTUL, COUNT(*) AS num_tickets_sold
FROM Film F
JOIN Seans S ON F.FIL_ID = S.FIL_ID
JOIN (
  SELECT SEA_ID FROM Bilet_Normalny
  UNION ALL
  SELECT SEA_ID FROM Bilet_Ulgowy
) B ON S.SEA_ID = B.SEA_ID
GROUP BY F.FIL_TYTUL
ORDER BY num_tickets_sold DESC
LIMIT 5;

DELIMITER //
CREATE PROCEDURE book_ticket(in sea_id int, in kli_id int, in miejsce int, in bilet_type enum('Normalny', 'Ulgowy'), in cena decimal(10, 2), in rodzaj_znizki varchar(50))
BEGIN
    IF bilet_type = 'Normalny' THEN
        INSERT INTO Bilet_Normalny (SEA_ID, KLI_ID, BNM_MIEJSCE, BNM_CENA)
        VALUES (sea_id, kli_id, miejsce, cena);
    ELSE
        INSERT INTO Bilet_Ulgowy (SEA_ID, KLI_ID, BUL_MIEJSCE, BUL_CENA, BUL_RODZAJ_ZNIZKI)
        VALUES (sea_id, kli_id, miejsce, cena, rodzaj_znizki);
    END IF;
END//
DELIMITER ;




