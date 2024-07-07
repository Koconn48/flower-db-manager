-- flowers database
-- created at: 07-06-2024
-- author: Kevin O'Connell

-- Step 1: Create a database
CREATE DATABASE flower_db;

\c flower_db;


-- Create Zones table
CREATE TABLE Zones (
    id INT PRIMARY KEY,
    lowerTemp INT NOT NULL,
    higherTemp INT NOT NULL
);

-- Populate Zones table
INSERT INTO Zones (id, lowerTemp, higherTemp) VALUES
(2, -50, -40),
(3, -40, -30),
(4, -30, -20),
(5, -20, -10),
(6, -10, 0),
(7, 0, 10),
(8, 10, 20),
(9, 20, 30),
(10, 30, 40);

-- Create Deliveries table
CREATE TABLE Deliveries (
    id INT PRIMARY KEY,
    categ VARCHAR(5) NOT NULL,
    delSize DECIMAL(5,3)
);

-- Populate Deliveries table
INSERT INTO Deliveries (id, categ, delSize) VALUES
(1, 'pot', 1.500),
(2, 'pot', 2.250),
(3, 'pot', 2.625),
(4, 'pot', 4.250),
(5, 'plant', NULL),
(6, 'bulb', NULL),
(7, 'hedge', 18.000),
(8, 'shrub', 24.000),
(9, 'tree', 36.000);

-- Create FlowersInfo table
CREATE TABLE FlowersInfo (
    id INT PRIMARY KEY,
    comName VARCHAR(30) NOT NULL,
    latName VARCHAR(35) NOT NULL,
    cZone INT,
    hZone INT,
    deliver INT,
    sunNeeds VARCHAR(5),
    FOREIGN KEY (cZone) REFERENCES Zones(id),
    FOREIGN KEY (hZone) REFERENCES Zones(id),
    FOREIGN KEY (deliver) REFERENCES Deliveries(id)
);

-- Populate FlowersInfo table
INSERT INTO FlowersInfo (id, comName, latName, cZone, hZone, deliver, sunNeeds) VALUES
(101, 'Lady Fern', 'Atbyrium filix-femina', 2, 9, 5, 'SH'),
(102, 'Pink Caladiums', 'C.x bortulanum', 10, 10, 6, 'PtoSH'),
(103, 'Lily-of-the-Valley', 'Convallaria majalis', 2, 8, 5, 'PtoSH'),
(105, 'Purple Liatris', 'Liatris spicata', 3, 9, 6, 'StoP'),
(106, 'Black Eyed Susan', 'Rudbeckia fulgida var. specios', 4, 10, 2, 'StoP'),
(107, 'Nikko Blue Hydrangea', 'Hydrangea macrophylla', 5, 9, 4, 'StoSH'),
(108, 'Variegated Weigela', 'W. florida Variegata', 4, 9, 8, 'StoP'),
(110, 'Lombardy Poplar', 'Populus nigra Italica', 3, 9, 9, 'S'),
(111, 'Purple Leaf Plum Hedge', 'Prunus x cistena', 2, 8, 7, 'S'),
(114, 'Thorndale Ivy', 'Hedera belix Thorndale', 3, 9, 1, 'StoSH');

-- Queries

-- a) Total number of zones
SELECT COUNT(*) AS TotalZones FROM Zones;

-- b) Number of flowers per cool zone
SELECT cZone AS CoolZone, COUNT(*) AS NumberOfFlowers
FROM FlowersInfo
GROUP BY cZone;

-- c) Common names of the plants with delivery sizes less than 5
SELECT comName
FROM FlowersInfo
JOIN Deliveries ON FlowersInfo.deliver = Deliveries.id
WHERE delSize < 5;

-- d) Common names of the plants that require full sun
SELECT comName
FROM FlowersInfo
WHERE sunNeeds = 'S';

-- e) All delivery category names ordered alphabetically (without repetition)
SELECT DISTINCT categ
FROM Deliveries
ORDER BY categ;

-- f) Exact output as in pic2.png------------------
SELECT FlowersInfo.comName AS Name,
       Z1.lowerTemp AS CoolZoneLow,
       Z1.higherTemp AS CoolZoneHigh,
       Deliveries.categ AS DeliveryCategory
FROM FlowersInfo
JOIN Zones Z1 ON FlowersInfo.cZone = Z1.id
JOIN Deliveries ON FlowersInfo.deliver = Deliveries.id
ORDER BY FlowersInfo.comName;

-- g) Plant names that have the same hot zone as "Pink Caladiums"

SELECT comName
FROM FlowersInfo
WHERE hZone = (SELECT hZone FROM FlowersInfo WHERE comName = 'Pink Caladiums')
  AND comName != 'Pink Caladiums';


-- h) Total number of plants, minimum delivery size, maximum delivery size, and average size
SELECT COUNT(*) AS Total, 
       MIN(delSize) AS Min, 
       MAX(delSize) AS Max, 
       ROUND(AVG(delSize), 2) AS Average
FROM FlowersInfo
JOIN Deliveries ON FlowersInfo.deliver = Deliveries.id
WHERE delSize IS NOT NULL;

-- i) Latin name of the plant that has the word 'Eyed' in its name
SELECT latName
FROM FlowersInfo
WHERE comName LIKE '%Eyed%';

-- j) Exact output as in pic4.png
SELECT categ AS Category, comName AS Name
FROM FlowersInfo
JOIN Deliveries ON FlowersInfo.deliver = Deliveries.id
ORDER BY categ, comName;

