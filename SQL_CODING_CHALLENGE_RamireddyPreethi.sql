
--                                                Coding challege
-- Name: Ramireddy Preethi
-- coding challenge: Vitual Art Gallery
create database virtual_art_gallery
use virtual_art_gallery

-- Create the Artists table

CREATE TABLE Artists (
ArtistID INT PRIMARY KEY,
Name VARCHAR(255) NOT NULL,
Biography TEXT,
Nationality VARCHAR(100));


-- Create the Categories table

CREATE TABLE Categories (
CategoryID INT PRIMARY KEY,
Name VARCHAR(100) NOT NULL);


-- Create the Artworks table

CREATE TABLE Artworks (
ArtworkID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
ArtistID INT,
CategoryID INT,
Year INT,
Description TEXT,
ImageURL VARCHAR(255),
FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));


-- Create the Exhibitions table

CREATE TABLE Exhibitions (
ExhibitionID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
StartDate DATE,
EndDate DATE,
Description TEXT);

-- Create a table to associate artworks with exhibitions
CREATE TABLE ExhibitionArtworks (
ExhibitionID INT,
ArtworkID INT,
PRIMARY KEY (ExhibitionID, ArtworkID),
FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

-- Insert sample data into the Artists table

INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

-- Insert sample data into the Categories table

INSERT INTO Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');

-- Insert sample data into the Artworks table

INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picassos powerful anti-war mural.', 'guernica.jpg');

-- Insert sample data into the Exhibitions table

INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- Insert artworks into exhibitions

INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);


-- QUERIES

/* 1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and
list them in descending order of the number of artworks. */

select a.Name,count(aw.artworkID) as Number_of_Artworks from artists a
inner join artworks aw on a.artistid=aw.artistid 
group by a.name order by Number_of_Artworks DESC


/* 2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order
them by the year in ascending order.*/

select aw.Title from Artworks aw 
inner join Artists a on aw.ArtistID=a.ArtistID
where a.Nationality in ('Spanish','Dutch')
order by aw.year ASC

/* 3. Find the names of all artists who have artworks in the 'Painting' category, and the number of
artworks they have in this category.  */

Select a.Name , count(aw.ArtworkId) as Num_of_Artworks from Artists a
inner join Artworks aw on a.ArtistID= aw.ArtistID
inner join Categories c on aw.CategoryID=c.CategoryID
where c.name='Painting' 
Group by a.Name 

/* 4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their
artists and categories. */

select aw.Title as ArtworkTitle,a.Name as ArtistName,c.Name as CategoryName from Artworks aw
inner join ExhibitionArtworks ea on aw.ArtworkID = ea.ArtworkID
inner join Exhibitions e on ea.ExhibitionID = e.ExhibitionID
inner join Artists a on aw.ArtistID = a.ArtistID
inner join Categories c on aw.CategoryID = c.CategoryID
where e.Title = 'Modern Art Masterpieces';

/* 5. Find the artists who have more than two artworks in the gallery.*/

select a.Name , count(aw.ArtworkID) as ArtworkCount
from Artists a
join Artworks aw on a.ArtistID=aw.ArtistID
group by a.Name
Having count(aw.ArtworkID) >2

/* 6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and
'Renaissance Art' exhibitions*/

select a.Title from Artworks a
join ExhibitionArtworks ea on a.ArtworkID = ea.ArtworkID
join Exhibitions e on ea.ExhibitionID = e.ExhibitionID 
where e.Title = 'Modern Art Masterpieces'
and a.ArtworkID in (
    select ea2.ArtworkID from ExhibitionArtworks ea2
    join Exhibitions e2 on ea2.ExhibitionID = e2.ExhibitionID
    where e2.Title = 'Renaissance Art'
)

/* 7. Find the total number of artworks in each category */

select c.Name AS CategoryName,count(aw.ArtworkID) AS TotalArtworks from Categories c
left join Artworks aw on c.CategoryID = aw.CategoryID
group by c.Name

/* 8. List artists who have more than 3 artworks in the gallery.*/

Select a.Name FROM Artists a
JOIN Artworks Aw ON A.ArtistID = Aw.ArtistID
GROUP BY A.Name
HAVING COUNT(Aw.ArtworkID) >3;

/* 9. Find the artworks created by artists from a specific nationality (e.g., Spanish).*/

Select aw.title as Artwork_title, a.Name, aw.year from artworks aw
join artists a ON aw.ArtistID = a.ArtistID
WHERE a.nationality = 'Spanish';

/* 10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.*/

select e.Title from Exhibitions e
JOIN ExhibitionArtworks ea1 ON e.ExhibitionID = ea1.ExhibitionID
JOIN Artworks aw1 ON ea1.ArtworkID = aw1.ArtworkID
JOIN Artists a1 ON aw1.ArtistID = a1.ArtistID
JOIN ExhibitionArtworks ea2 ON e.ExhibitionID = ea2.ExhibitionID
JOIN Artworks aw2 ON ea2.ArtworkID = aw2.ArtworkID
JOIN Artists a2 ON aw2.ArtistID = a2.ArtistID
WHERE a1.Name = 'Vincent van Gogh' AND a2.Name = 'Leonardo da Vinci';

/* 11. Find all the artworks that have not been included in any exhibition.*/

select aw.title, a.Name From Artworks aw
Join Artists a on aw.ArtistID=a.ArtistID
Left join ExhibitionArtworks ea on aw.ArtworkID=ea.ArtworkID
where ea.ExhibitionID IS null;

/* 12. List artists who have created artworks in all available categories. */

select a.Name from Artists a
join Artworks aw on a.ArtistID = aw.ArtistID
GROUP BY a.Name
having COUNT(DISTINCT aw.CategoryID) = (select COUNT(CategoryID) from Categories)
/* 13. List the total number of artworks in each category.*/

select C.Name AS CategoryName,COUNT(Art.ArtworkID) AS ArtworkCount FROM Categories C
left join Artworks Art ON C.CategoryID = Art.CategoryID
GROUP By C.Name

/* 14. Find the artists who have more than 2 artworks in the gallery**/

Select a.Name,count(aw.artworkid) as artworkcount FROM Artists a
JOIN Artworks Aw ON A.ArtistID = Aw.ArtistID
GROUP BY A.Name
HAVING COUNT(Aw.ArtworkID) >2;

/* 15. List the categories with the average year of artworks they contain, only for categories with more
than 1 artwork.*/

Select c.Name, AVG(Aw.Year) AS Average_Year FROM Categories c
JOIN Artworks Aw ON c.CategoryID = Aw.CategoryID
GROUP BY C.Name
HAVING COUNT(Aw.ArtworkID) > 1

/* 16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.*/

select Aw.Title from Artworks Aw
join ExhibitionArtworks ea on Aw.ArtworkID = ea.ArtworkID
join Exhibitions e on ea.ExhibitionID = e.ExhibitionID
WHERE e.Title = 'Modern Art Masterpieces'
/* 17. Find the categories where the average year of artworks is greater than the average year of all
artworks. */

select c.Name as CategoryName from Categories c
join Artworks aw on c.CategoryID = aw.CategoryID
GROUP BY c.CategoryID, c.Name
HAVING AVG(aw.Year) > (select AVG(Year) from Artworks)

/* 18. List the artworks that were not exhibited in any exhibition. */

select aw.Title as artworks from Artworks aw
LEFT JOIN ExhibitionArtworks ea on aw.ArtworkID = ea.ArtworkID
WHERE ea.ArtworkID IS NULL

/* 19. Show artists who have artworks in the same category as "Mona Lisa."*/

select distinct a.Name  as artists from Artists a
JOIN Artworks aw on a.ArtistID = aw.ArtistID
WHERE aw.CategoryID = (select CategoryID from Artworks WHERE Title = 'Mona Lisa')

/* 20. List the names of artists and the number of artworks they have in the gallery.*/

select a.Name, COUNT(aw.ArtworkID) as ArtworkCount from Artists a
JOIN Artworks aw on a.ArtistID = aw.ArtistID
GROUP BY a.Name
