# Database Cinema

Projekt zrealizowany w ramach przedmiotu Bazy Danych

1. Projekt zakłada stworzenie bazy danych dotyczącej kina. Baza będzie się opierała na przechowywaniu  
 informacji o seansach, filmach, klientach, salach oraz biletach.
2. Baza danych powinna:  
   - zawierać encje specjalizowane
   - wypełniać przynajmniej jedną tabelę losowymi danymi (na podstawie relacji z innymi)
   - reprezentować przynajmniej po jednym przykładzie:  
     - Funkcji
     - Widoku
     - Procedury składowanej

**RDBMS: MySQL**

###  Entity Relationship Diagram

![Lk_02_ERD_Encje](https://github.com/user-attachments/assets/82178f4f-0916-4c80-9018-0cf094b17381)


![Lk_03_ERD_Podzial](https://github.com/user-attachments/assets/d7de3b8c-d3da-4f71-aaeb-612d2e2db13d)


 - [x] Wstawianie danych do tabeli SEANS na podstawie powiązanych i uzupełnionych tabel
```sql
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
ORDER BY RAND();
```
- [x] Funkcja - zwraca zysk z konkretnego filmu z podziałem na bilet normalny i ulgowy
      

```sql
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
```

- [x] Funkcja składowana - wstawianie nowego biletu do odpowiedniej tabeli, w zależności od określonego typu biletu.

```sql
DELIMITER //
CREATE PROCEDURE book_ticket(in sea_id int, in kli_id int, in miejsce int, in bilet_type enum('Normalny', 'Ulgowy'), 
							 in cena decimal(10, 2), in rodzaj_znizki varchar(50))
BEGIN
    IF bilet_type = 'Normalny' THEN
        INSERT INTO Bilet_Normalny (SEA_ID, KLI_ID, BNM_MIEJSCE, BNM_CENA)
        VALUES (sea_id, kli_id, miejsce, cena);
    ELSE
        INSERT INTO Bilet_Ulgowy (SEA_ID, KLI_ID, BUL_MIEJSCE, BUL_CENA, BUL_RODZAJ_ZNIZKI)
        VALUES (sea_id, kli_id, miejsce, cena, rodzaj_znizki);
    END IF;
END //
DELIMITER 
```

- [x] Widok - top 5 tytułów na podstawie sprzedanych biletów

```sql
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
```
       
