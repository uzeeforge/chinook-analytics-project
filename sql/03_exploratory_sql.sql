USE Chinook;

-- Track -> Album -> Artist join
SELECT TOP 10
    t.Name AS TrackName,
    al.Title AS AlbumTitle,
    ar.Name AS ArtistName
FROM Track t
INNER JOIN Album al ON t.AlbumId = al.AlbumId
INNER JOIN Artist ar ON al.ArtistId = ar.ArtistId
ORDER BY t.Name;

-- Filter with WHERE
SELECT 
    t.Name AS TrackName,
    al.Title AS AlbumTitle,
    ar.Name AS ArtistName
FROM Track t
INNER JOIN Album al ON t.AlbumId = al.AlbumId
INNER JOIN Artist ar ON al.ArtistId = ar.ArtistId
WHERE ar.Name = 'Metallica'
ORDER BY al.Title, t.Name;

-- Track count per genre
SELECT 
    g.Name AS GenreName,
    COUNT(t.TrackId) AS TotalTracks
FROM Track t
INNER JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY TotalTracks DESC;

-- Revenue per genre, filtered with HAVING
SELECT 
    g.Name AS GenreName,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM InvoiceLine il
INNER JOIN Track t ON il.TrackId = t.TrackId
INNER JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
HAVING SUM(il.UnitPrice * il.Quantity) > 100
ORDER BY TotalRevenue DESC;