-- by Ramin Akhavijou
/* This project focuses on analyzing music data to solve problems and gain insights. 
The data is collected using touch sensors connected to Arduino and Max/MSP, 
and it is saved as CSV files. */

SELECT * FROM Soundstallation9;

-- the data has 4 columns; frequency, duration, dynamic, and sound library
-- Frequency: 50-2000 hz
-- duration: 1-10 sec.
-- dynamic (pppp-ffff): 1-10
-- sound library: 1-20 (using 20 different plugins)

-- This query identifies all instances characterized by strong dynamics and long duration (above the f). 
-- These moments correspond to periods in the music when the intensity becomes notably strong.

SELECT Frequency, sounds_lib, dynamic, duration FROM Soundstallation9
WHERE dynamic > 5 AND duration > 4
GROUP BY dynamic
ORDER BY Frequency;

-- During the performance, there were instances where distortion was audible in the high frequencies, occurring 4 times. 
-- This query aims to identify the specific frequency associated with this distortion.

SELECT Frequency 
FROM Soundstallation9 
GROUP BY Frequency
HAVING COUNT(*) = 4;

-- Count of unique frequencies recorded in the dataset
SELECT COUNT(DISTINCT Frequency) AS Unique_Frequencies
FROM Soundstallation9;


-- Average duration of sounds for each dynamic level
SELECT Dynamic, AVG(Duration) AS Avg_Duration
FROM Soundstallation9
GROUP BY Dynamic
ORDER BY Dynamic;

-- Frequency distribution by dynamic level
SELECT Dynamic, COUNT(*) AS Frequency_Count
FROM Soundstallation9
GROUP BY Dynamic
ORDER BY Dynamic;

-- Top 5 most common frequencies with their average duration
SELECT Frequency, AVG(Duration) AS Avg_Duration
FROM Soundstallation9
GROUP BY Frequency
ORDER BY COUNT(*) DESC
LIMIT 5;

-- Dynamic level distribution for a specific frequency range. The specific range that we want to add accompaniment later.
SELECT Dynamic, COUNT(*) AS Frequency_Count
FROM Soundstallation9
WHERE Frequency BETWEEN 500 AND 1000
GROUP BY Dynamic
ORDER BY Dynamic;


-- adding notes and updating it when someone works on the data
ALTER TABLE Soundstallation9
ADD COLUMN description varchar(32);

-- adding notes based on observation
UPDATE Soundstallation9
SET description = 'The dynamic level "ppp" has the lowest average frequency count. 
Investigate its correlation with the overall form and structure of the music.'
WHERE dynamic = 2;

-- adding notes for researchers
UPDATE Soundstallation9
SET description = 'check the frequency and music and find out the reason of distortion'
WHERE Frequency = 1409;

-- adiing notes for researchers
UPDATE Soundstallation9
SET description = 'check the available textures in the sound library'
WHERE Frequency < 200;

-- drop description column after the tasks are done
ALTER TABLE Soundstallation9
DROP COLUMN description;

-- VIEWS
-- This view calculates the count of records for each dynamic level.
CREATE VIEW Dynamic_Level_Count_View AS
SELECT Dynamic, COUNT(*) AS Record_Count
FROM Soundstallation9
GROUP BY Dynamic;

-- This view calculates the average duration for each frequency.
CREATE VIEW Frequency_Duration_Avg_View AS
SELECT Frequency, AVG(Duration) AS Avg_Duration
FROM Soundstallation9
GROUP BY Frequency;

-- INDEX
-- This index can improve performance when querying based on the Frequency column.
CREATE INDEX Frequency_Index ON Soundstallation9 (Frequency);




