-- Create Database
USE master
GO

IF NOT EXISTS (
	SELECT name
	FROM sys.databases
	WHERE name = 'Lai_ChaoChun_SSD_Ticketing'
)
BEGIN
CREATE DATABASE Lai_ChaoChun_SSD_Ticketing
END
GO


-- Use Lai_ChaoChun_SSD_Ticketing Database
USE Lai_ChaoChun_SSD_Ticketing
GO


-- Drop Tables
IF OBJECT_ID('dbo.EventSeatSale', 'u') IS NOT NULL
DROP TABLE EventSeatSale
GO

IF OBJECT_ID('dbo.EventSeat', 'u') IS NOT NULL
DROP TABLE EventSeat
GO

IF OBJECT_ID('dbo.Seat', 'u') IS NOT NULL
DROP TABLE Seat
GO

IF OBJECT_ID('dbo.Row', 'u') IS NOT NULL
DROP TABLE Row
GO

IF OBJECT_ID('dbo.Section', 'u') IS NOT NULL
DROP TABLE Section
GO

IF OBJECT_ID('dbo.Sale', 'u') IS NOT NULL
DROP TABLE Sale
GO

IF OBJECT_ID('dbo.Customer', 'u') IS NOT NULL
DROP TABLE Customer
GO

IF OBJECT_ID('dbo.Event', 'u') IS NOT NULL
DROP TABLE Event
GO

IF OBJECT_ID('dbo.Venue', 'u') IS NOT NULL
DROP TABLE Venue
GO

IF OBJECT_ID('dbo.EventType', 'u') IS NOT NULL
DROP TABLE EventType
GO

IF OBJECT_ID('tempdb..#SoldSeatTempTable', 'u') IS NOT NULL
DROP TABLE #SoldSeatTempTable
GO

IF OBJECT_ID('tempdb..#AllSeatTempTable', 'u') IS NOT NULL
DROP TABLE #AllSeatTempTable
GO


--Create Tables
CREATE TABLE Customer(
    CustomerId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL
);

CREATE TABLE Sale(
    SaleId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	CustomerId UNIQUEIDENTIFIER NOT NULL,
	PaymentType VARCHAR(10) NOT NULL,
	FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
);

CREATE TABLE EventType (
    EventTypeId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    Name VARCHAR(20)
);

CREATE TABLE Venue (
	Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	State VARCHAR(50) NOT NULL,
	Capacity INT NOT NULL
);

CREATE TABLE Event(
    EventId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    EventTypeId UNIQUEIDENTIFIER NOT NULL,
    VenueId UNIQUEIDENTIFIER NOT NULL,
    Name VARCHAR(20) NOT NULL,
    StartDate DATETIME,
    EndDate DATETIME,
	FOREIGN KEY (EventTypeId) REFERENCES EventType(EventTypeId),
	FOREIGN KEY (VenueId) REFERENCES Venue(Id)
);

CREATE TABLE Section(
    SectionId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    VenueId UNIQUEIDENTIFIER NOT NULL,
    Name VARCHAR(20) NOT NULL,
	FOREIGN KEY (VenueId) REFERENCES Venue(Id)
);

CREATE TABLE Row(
    RowId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    SectionId UNIQUEIDENTIFIER NOT NULL,
    RowNumber INT NOT NULL,
	FOREIGN KEY (SectionId) REFERENCES Section(SectionId)
);

CREATE TABLE Seat(
    SeatId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    RowId UNIQUEIDENTIFIER NOT NULL,
    SeatNumber INT NOT NULL,
	BasePrice MONEY,
	FOREIGN KEY (RowId) REFERENCES Row(RowId)
);

CREATE TABLE EventSeat(
    EventSeatId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    SeatId UNIQUEIDENTIFIER NOT NULL,
	EventId UNIQUEIDENTIFIER NOT NULL,
    EventPrice MONEY
	FOREIGN KEY (SeatId) REFERENCES Seat(SeatId),
	FOREIGN KEY (EventId) REFERENCES Event(EventId)
);

CREATE TABLE EventSeatSale(
    EventSeatId UNIQUEIDENTIFIER NOT NULL,
    SaleId UNIQUEIDENTIFIER NOT NULL,
	SalePrice MONEY,
    SaleStatus INT,
	PRIMARY KEY (EventSeatId, SaleId),
	FOREIGN KEY (EventSeatId) REFERENCES EventSeat(EventSeatId),
	FOREIGN KEY (SaleId) REFERENCES Sale(SaleId)
);


-- ALTER Tables
ALTER TABLE EventSeatSale
ADD CONSTRAINT StatusConstraint
CHECK (SaleStatus IN (0, 1, 2, 3));

ALTER TABLE Sale
ADD CONSTRAINT PaymentConstraint
CHECK (PaymentType IN ('MC', 'AMEX', 'VISA', 'CASH'));


--INSERT Seed Data
INSERT INTO Venue VALUES (NEWID(),'American Airlines Arena','Miami', 'Florida',19600)
INSERT INTO Venue VALUES (NEWID(),'American Airlines Center','Dallas','Texas',19200)
INSERT INTO Venue VALUES (NEWID(),'Amway Center','Orlando','Florida',18846)
INSERT INTO Venue VALUES (NEWID(),'AT&T Center','San Antonio','Texas',18418)
INSERT INTO Venue VALUES (NEWID(),'Bankers Life Fieldhouse','Indianapolis','Indiana',17923)
INSERT INTO Venue VALUES (NEWID(),'Barclays Center','Brooklyn','New York',17732)
INSERT INTO Venue VALUES (NEWID(),'Capital One Arena','Washington','D.C.',20356	)
INSERT INTO Venue VALUES (NEWID(),'Chase Center','San Francisco','California',18064)
INSERT INTO Venue VALUES (NEWID(),'Chesapeake Energy Arena','Oklahoma City','Oklahoma',18203)
INSERT INTO Venue VALUES (NEWID(),'FedExForum','Memphis','Tennessee',17794)
INSERT INTO Venue VALUES (NEWID(),'Fiserv Forum','Milwaukee','Wisconsin',17500)
INSERT INTO Venue VALUES (NEWID(),'Golden 1 Center','Sacramento','California',17583)
INSERT INTO Venue VALUES (NEWID(),'Little Caesars Arena','Detroit','Michigan',20332)
INSERT INTO Venue VALUES (NEWID(),'Madison Square Garden','New York City','New York',19812)
INSERT INTO Venue VALUES (NEWID(),'Moda Center','Portland','Oregon',19441)
INSERT INTO Venue VALUES (NEWID(),'Pepsi Center','Denver','Colorado',19520)
INSERT INTO Venue VALUES (NEWID(),'Rocket Mortgage FieldHouse','Cleveland','Ohio',19432)
INSERT INTO Venue VALUES (NEWID(),'Scotiabank Arena','Toronto','Ontario',19800)
INSERT INTO Venue VALUES (NEWID(),'Smoothie King Center','New Orleans','Louisiana',16867)
INSERT INTO Venue VALUES (NEWID(),'Spectrum Center','Charlotte','North Carolina',19077)
INSERT INTO Venue VALUES (NEWID(),'Staples Center','Los Angeles','California',18997)
INSERT INTO Venue VALUES (NEWID(),'State Farm Arena','Atlanta','Georgia',18118)
INSERT INTO Venue VALUES (NEWID(),'Talking Stick Resort Arena','Phoenix','Arizona',18055)
INSERT INTO Venue VALUES (NEWID(),'Target Center','Minneapolis','Minnesota',18978)
INSERT INTO Venue VALUES (NEWID(),'TD Garden','Boston','Massachusetts',18624)
INSERT INTO Venue VALUES (NEWID(),'Toyota Center','Houston','Texas',18055)
INSERT INTO Venue VALUES (NEWID(),'United Center','Chicago','Illinois',20917)
INSERT INTO Venue VALUES (NEWID(),'Vivint Smart Home Arena','Salt Lake City','Utah',18306)
INSERT INTO Venue VALUES (NEWID(),'Wells Fargo Center','Philadelphia','Pennsylvania',20478)
INSERT INTO Venue VALUES (NEWID(), 'Inglewood Basketball and Entertainment Center','Inglewood','California',18000)

DECLARE @VenueId UNIQUEIDENTIFIER = (SELECT Id FROM Venue WHERE Name = 'Staples Center');
INSERT INTO EventType VALUES (NEWID(), 'Concert');
INSERT INTO EventType VALUES (NEWID(), 'Basketball Game');
INSERT INTO EventType VALUES (NEWID(), 'Hockey Game');

DECLARE @ConcertId UNIQUEIDENTIFIER = (SELECT EventTypeId FROM EventType WHERE Name = 'Concert');

INSERT INTO Event VALUES 
(NEWID(),  @ConcertId, @VenueId, 'Beyonce', '2021-04-12 18:00:00.000','2021-04-12 22:00:00.000'),
(NEWID(),  @ConcertId, @VenueId, 'Lady Gaga', '2021-05-17 18:00:00.000','2021-05-17 22:00:00.000'),
(NEWID(),  @ConcertId, @VenueId, 'Disney on Ice', '2019-12-20 16:00:00.000','2019-12-20 19:00:00.000');

INSERT INTO Section VALUES 
(NEWID(), @VenueId, 'UPPERMEZ_10'),
(NEWID(), @VenueId, 'LOWERBOWL_01');

DECLARE @SectionId UNIQUEIDENTIFIER = (SELECT SectionId FROM Section WHERE Name = 'LOWERBOWL_01');

INSERT INTO Row VALUES 
(NEWID(), @SectionId, '01'),
(NEWID(), @SectionId, '02'),
(NEWID(), @SectionId, '03'),
(NEWID(), @SectionId, '04'),
(NEWID(), @SectionId, '05');

DECLARE @RowId UNIQUEIDENTIFIER = (SELECT RowId FROM Row WHERE RowNumber = '01');
DECLARE @RowId2 UNIQUEIDENTIFIER = (SELECT RowId FROM Row WHERE RowNumber = '02');

INSERT INTO Seat VALUES 
(NEWID(), @RowId, '01', 29.88),
(NEWID(), @RowId, '02', 29.88),
(NEWID(), @RowId, '03', 29.88),
(NEWID(), @RowId, '04', 29.88),
(NEWID(), @RowId, '05', 29.88),
(NEWID(), @RowId, '06', 29.88),
(NEWID(), @RowId, '07', 29.88),
(NEWID(), @RowId, '08', 29.88),
(NEWID(), @RowId2, '01', 26.28),
(NEWID(), @RowId2, '02', 26.28),
(NEWID(), @RowId2, '03', 26.28),
(NEWID(), @RowId2, '04', 26.28),
(NEWID(), @RowId2, '05', 26.28),
(NEWID(), @RowId2, '06', 26.28),
(NEWID(), @RowId2, '07', 26.28),
(NEWID(), @RowId2, '08', 26.28);

INSERT INTO Customer VALUES
(NEWID(),'Steve', 'Rogers'),
(NEWID(),'Carol', 'Danvers'),
(NEWID(),'Peter', 'Parker')

INSERT INTO Sale VALUES
(NEWID(), (SELECT CustomerId FROM Customer WHERE LastName = 'Rogers'), 'MC'),
(NEWID(), (SELECT CustomerId FROM Customer WHERE LastName = 'Danvers'), 'CASH');


DECLARE @Beyonce UNIQUEIDENTIFIER = (SELECT EventId FROM Event WHERE Name = 'Beyonce');
INSERT INTO EventSeat
SELECT NEWID(), SeatId, @Beyonce, 68.00
FROM Seat;


DECLARE @RogersSaleId UNIQUEIDENTIFIER = (SELECT SaleId 
										FROM Sale S INNER JOIN Customer C ON S.CustomerId = C.CustomerId
										WHERE firstName = 'Steve' AND LastName = 'Rogers');
INSERT INTO EventSeatSale
SELECT ES.EventSeatId, @RogersSaleId, ES.EventPrice + Seat.BasePrice, 1
FROM EventSeat ES, (SELECT SeatId, BasePrice FROM Seat WHERE RowId = @RowId2 AND SeatNumber IN (1,2,3,4)) AS Seat
WHERE ES.EventId = @Beyonce AND ES.SeatId = Seat.SeatId;


DECLARE @counter INT = 1;
DECLARE @ASCII INT = 65;
WHILE @counter <= 100
BEGIN
	INSERT iNTO Customer VALUES (NEWID(), 
								'Test'+ CAST(@counter AS VARCHAR(3)), 
								CONCAT(CHAR(@ASCII),'name',CAST(@counter AS VARCHAR(3))));
	SET @ASCII += 1;

	IF @counter%26 = 0
	BEGIN
		SET @ASCII = 65;
	END;

	SET @counter += 1;
END;


INSERT INTO Venue VALUES (NEWID(), 'Test Venue', 'Vancouver', 'BC', 19000)


SET @counter = 1;
WHILE @counter <= 20
BEGIN
	INSERT INTO Section VALUES (NEWID(),
								(SELECT Id FROM Venue WHERE Name = 'Test Venue'), 
								'SEC' + CAST(@counter AS VARCHAR(2)));

	SET @counter += 1;
END;


DECLARE @secNum INT = 1;
DECLARE @rowNum INT = 1;
DECLARE @seatNum INt = 1;
WHILE @secNum <= 15
BEGIN
	WHILE @rowNum <= 50
	BEGIN
		INSERT INTO Row
		SELECT NEWID(), SectionId, @rowNum
		FROM Section
		WHERE Name = 'SEC' + CAST(@secNum AS VARCHAR(2));

		
		WHILE @seatNum <= 25
		BEGIN
			INSERT INTO Seat
			SELECT NEWID(), RowId, @seatNum, NULL
			FROM Row R INNER JOIN Section S ON R.SectionId = S.SectionId
			WHERE Name = 'SEC' + CAST(@secNum AS VARCHAR(2)) AND RowNumber = @rowNum;

			SET @seatNum += 1;
		END

		SET @rowNum += 1;
		SET @seatNum = 1;
	END

	SET @secNum += 1;
	SET @rowNum = 1;
END


SET @secNum = 16;
SET @rowNum = 1;
SET @seatNum = 1;
WHILE @secNum <= 18
BEGIN
	WHILE @rowNum <= 5
	BEGIN
		INSERT INTO Row
		SELECT NEWID(), SectionId, @rowNum
		FROM Section
		WHERE Name = 'SEC' + CAST(@secNum AS VARCHAR(2));

		
		WHILE @seatNum <= 10
		BEGIN
			INSERT INTO Seat
			SELECT NEWID(), RowId, @seatNum, NULL
			FROM Row R INNER JOIN Section S ON R.SectionId = S.SectionId
			WHERE Name = 'SEC' + CAST(@secNum AS VARCHAR(2)) AND RowNumber = @rowNum;

			SET @seatNum += 1;
		END

		SET @rowNum += 1;
		SET @seatNum = 1;
	END

	SET @secNum += 1;
	SET @rowNum = 1;
END


SET @secNum = 19;
SET @seatNum = 1;
WHILE @secNum <= 20
BEGIN

	INSERT INTO Row
	SELECT NEWID(), SectionId, 1
	FROM Section
	WHERE Name = 'SEC' + CAST(@secNum AS VARCHAR(2));

	
	WHILE @seatNum <= 50
	BEGIN
		INSERT INTO Seat
		SELECT NEWID(), RowId, @seatNum, NULL
		FROM Row R INNER JOIN Section S ON R.SectionId = S.SectionId
		WHERE Name = 'SEC' + CAST(@secNum AS VARCHAR(2)) AND RowNumber = @rowNum;

		SET @seatNum += 1;
	END

	SET @secNum += 1;
	SET @seatNum = 1;
END


DECLARE @BasketballId UNIQUEIDENTIFIER = (SELECT EventTypeId FROM EventType WHERE Name = 'Basketball Game');
SET @VenueId = (SELECT Id FROM Venue WHERE Name = 'Test Venue');
INSERT INTO Event VALUES (NEWID(),  @BasketballId, @VenueId, 'Test Event', '2022-06-05 17:00:00.000','2022-06-05 20:00:00.000');


DECLARE @TestEventId UNIQUEIDENTIFIER = (SELECT EventId FROM Event WHERE Name = 'Test Event');
INSERT INTO EventSeat
SELECT NEWID(), Seat.SeatId, @TestEventId, NULL
FROM Seat
	 INNER JOIN Row R ON R.RowId = Seat.RowId
	 INNER JOIN Section ON Section.SectionId = R.SectionId
	 INNER JOIN Venue V ON V.Id = Section.VenueId
	 INNER JOIN Event E ON E.VenueId = V.Id
WHERE E.EventId = @TestEventId


DECLARE @lastPaymentType VARCHAR(10)
DECLARE @customerId UNIQUEIDENTIFIER

DECLARE @getCustomer CURSOR
SET @getCustomer = CURSOR FOR
SELECT CustomerId FROM Customer
WHERE FirstName LIKE 'Test%'
ORDER BY CAST(SUBSTRING(FirstName, 5, 3) AS INT);

OPEN @getCustomer
	FETCH NEXT FROM @getCustomer INTO @customerId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @lastPaymentType = 
		CASE
			WHEN @lastPaymentType = 'MC' THEN 'AMEX'
			WHEN @lastPaymentType = 'AMEX' THEN 'VISA'
			WHEN @lastPaymentType = 'VISA' THEN 'CASH'
			WHEN @lastPaymentType = 'CASH' THEN 'MC'
			ELSE 'MC'
		END

		INSERT INTO Sale VALUES  (NEWID(), @customerId, @lastPaymentType);

		FETCH NEXT
		FROM @getCustomer INTO @customerId
	END

	CLOSE @getCustomer

	DEALLOCATE @getCustomer


DECLARE @custCounter INT = 1;
DECLARE @seatCounter INT;
DECLARE @seatId UNIQUEIDENTIFIER;

WHILE @custCounter <= 24
BEGIN
	SET @seatCounter = @custCounter
	WHILE @seatCounter <= (@custCounter + 1)
	BEGIN
		INSERT INTO EventSeatSale
		SELECT ES.EventSeatId, Sale.SaleId, NULL, NULL
		FROM EventSeat ES
			 INNER JOIN Seat ON Seat.SeatId = ES.SeatId
			 INNER JOIN Row R ON R.RowId = Seat.RowId
			 INNER JOIN Section ON Section.SectionId = R.SectionId,
			 Sale
			 INNER JOIN Customer C ON Sale.CustomerId = C.CustomerId
		WHERE Section.Name = 'SEC1' AND 
			  R.RowNumber = @custCounter AND 
			  Seat.SeatNumber = @seatCounter AND
			  C.FirstName = 'Test' + CAST(@custCounter AS VARCHAR(2));

		SET @seatCounter += 1;
	END

	SET @custCounter += 1;
END


SET @custCounter = 25;
SET @seatCounter = 1;

WHILE @custCounter <= 49
BEGIN
	INSERT INTO EventSeatSale
	SELECT ES.EventSeatId, Sale.SaleId, NULL, NULL
	FROM EventSeat ES
		 INNER JOIN Seat ON Seat.SeatId = ES.SeatId
		 INNER JOIN Row R ON R.RowId = Seat.RowId
		 INNER JOIN Section ON Section.SectionId = R.SectionId,
		 Sale
		 INNER JOIN Customer C ON Sale.CustomerId = C.CustomerId
	WHERE Section.Name = 'SEC1' AND 
		  R.RowNumber = 25 AND 
		  Seat.SeatNumber = @seatCounter AND
		  C.FirstName = 'Test' + CAST(@custCounter AS VARCHAR(2));

	SET @custCounter += 1;
	SET @seatCounter += 1;
END


SET @custCounter = 50;
SET @seatCounter = 1;

WHILE @custCounter <= 75
BEGIN
	INSERT INTO EventSeatSale
	SELECT ES.EventSeatId, Sale.SaleId, NULL, NULL
	FROM EventSeat ES
		 INNER JOIN Seat ON Seat.SeatId = ES.SeatId
		 INNER JOIN Row R ON R.RowId = Seat.RowId
		 INNER JOIN Section ON Section.SectionId = R.SectionId,
		 Sale
		 INNER JOIN Customer C ON Sale.CustomerId = C.CustomerId
	WHERE Section.Name = 'SEC19' AND 
		  R.RowNumber = 1 AND 
		  Seat.SeatNumber = @seatCounter AND
		  C.FirstName = 'Test' + CAST(@custCounter AS VARCHAR(2));

	SET @custCounter += 1;
	SET @seatCounter += 1;
END

-- DELETE Statements
DELETE FROM Sale
WHERE SaleId NOT IN (SELECT SaleId FROM EventSeatSale)


-- SELECT Statements
--SELECT V.Name AS Venue, E.Name AS Event, 
--	   CONVERT(VARCHAR, E.StartDate, 107) AS [Event Date],
--	   CONVERT(VARCHAR, E.StartDate, 108) AS [Start Time]
--FROM Event E INNER JOIN Venue V ON E.VenueId = V.Id
--WHERE E.StartDate > GETDATE();


--SELECT E.Name AS Event, Section.Name AS Section, R.RowNumber AS Row, COUNT(SeatNumber) AS [Seat Number]
--INTO #SoldSeatTempTable
--FROM EventSeatSale ESS
--	 INNER JOIN EventSeat ES ON ESS.EventSeatId = ES.EventSeatId
--	 INNER JOIN Seat ON Seat.SeatId = ES.SeatId
--	 RIGHT JOIN Row R ON R.RowId = Seat.RowId
--	 INNER JOIN Section ON Section.SectionId = R.SectionId,
--	 Event E
--WHERE E.EventId = @Beyonce
--GROUP BY E.Name, Section.Name, R.RowNumber


--SELECT E.Name AS Event, Section.Name AS Section, RowNumber AS Row, COUNT(SeatNumber) AS [Seat Number]
--INTO #AllSeatTempTable
--FROM Event E
--INNER JOIN EventSeat ES ON E.EventId = ES.EventId
--INNER JOIN Seat ON Seat.SeatId = ES.SeatId
--INNER JOIN Row R ON R.RowId = Seat.RowId
--INNER JOIN Section ON Section.SectionId = R.SectionId
--WHERE E.EventId = @Beyonce
--GROUP BY E.Name, Section.Name, RowNumber;

--SELECT ASTT.Event, ASTT.Section, ASTT.Row, ASTT.[Seat Number] - SSTT.[Seat Number] AS [Available Seats]
--FROM #AllSeatTempTable ASTT 
--	 INNER JOIN #SoldSeatTempTable SSTT ON ASTT.Event = SSTT.Event AND 
--												ASTT.Section = SSTT.Section AND 
--												ASTT.Row = SSTT.Row


--SELECT C.FirstName + ' ' + C.LastName AS [Customer], 
--	   E.Name AS Event, 
--	   Section.Name AS Section, 
--	   R.RowNumber AS Row,
--	   CONCAT(MIN(Seat.SeatNumber),' - ',MAX(Seat.SeatNumber))  AS Seats,
--	   FORMAT(SUM(ES.EventPrice + Seat.BasePrice), 'C') AS [Sale Price],
--	   Sale.PaymentType
--FROM EventSeatSale ESS
--	 INNER JOIN Sale ON Sale.SaleId = ESS.SaleId
--	 INNER JOIN Customer C ON C.CustomerId = Sale.CustomerId
--	 INNER JOIN EventSeat ES ON ESS.EventSeatId = ES.EventSeatId
--	 INNER JOIN Seat ON Seat.SeatId = ES.SeatId
--	 INNER JOIN Row R ON R.RowId = Seat.RowId
--	 INNER JOIN Section ON Section.SectionId = R.SectionId
--	 INNER JOIN Event E ON E.EventId = ES.EventId
--GROUP BY C.FirstName, C.LastName, E.Name, Section.Name, R.RowNumber, Sale.PaymentType


--SELECT C.FirstName + ' ' + C.LastName AS [Customer], 
--	   E.Name AS Event, 
--	   Section.Name AS Section, 
--	   R.RowNumber AS Row,
--	   STRING_AGG(Seat.SeatNumber, ',') WITHIN GROUP (ORDER BY Seat.SeatNumber) AS Seats,
--	   FORMAT(SUM(ES.EventPrice + Seat.BasePrice), 'C') AS [Sale Price],
--	   Sale.PaymentType
--FROM EventSeatSale ESS
--	 INNER JOIN Sale ON Sale.SaleId = ESS.SaleId
--	 INNER JOIN Customer C ON C.CustomerId = Sale.CustomerId
--	 INNER JOIN EventSeat ES ON ESS.EventSeatId = ES.EventSeatId
--	 INNER JOIN Seat ON Seat.SeatId = ES.SeatId
--	 INNER JOIN Row R ON R.RowId = Seat.RowId
--	 INNER JOIN Section ON Section.SectionId = R.SectionId
--	 INNER JOIN Event E ON E.EventId = ES.EventId
--GROUP BY C.FirstName, C.LastName, E.Name, Section.Name, R.RowNumber, Sale.PaymentType


---------------------------- Question 1 ----------------------------------
DROP FUNCTION IF EXISTS fnGetFullName
GO

CREATE FUNCTION fnGetFullName(@firstName VARCHAR(20), @lastName VARCHAR(20))
	RETURNS VARCHAR(41) AS
	BEGIN
		RETURN @firstName + ' ' + @lastName;
	END
GO

SELECT dbo.fnGetFullName('Steven','Lai') AS [Full Name]

------------------------------ Question 2 ----------------------------------
DROP FUNCTION IF EXISTS fnGetTicketLabels
GO

CREATE FUNCTION fnGetTicketLabels(@saleId UNIQUEIDENTIFIER)
	RETURNS TABLE AS
	RETURN
		SELECT E.Name + ': ' + CAST(Section.Name AS VARCHAR(20)) + 
				' - Row ' + CAST(R.RowNumber AS VARCHAR(5)) + 
				' - Seat ' + CAST(Seat.SeatNumber AS VARCHAR(5)) AS Result
		FROM EventSeatSale ESS
			 JOIN EventSeat ES ON ES.EventSeatId = ESS.EventSeatId
			 JOIN Seat ON Seat.SeatId = ES.SeatId
			 JOIN Row R ON R.RowId = Seat.RowId
			 JOIN Section ON Section.SectionId = R.SectionId
			 JOIN Event E ON E.EventId = ES.EventId
		WHERE ESS.SaleId = @saleId
GO

DECLARE @saleIdParam UNIQUEIDENTIFIER = (SELECT SaleId 
										 FROM Sale
										 INNER JOIN Customer C ON C.CustomerId = Sale.CustomerId
										 WHERE C.FirstName = 'Steve' AND C.LastName = 'Rogers');
SELECT * 
FROM fnGetTicketLabels(@saleIdParam)
ORDER BY Result;

------------------------------ Question 3 ----------------------------------
DROP FUNCTION IF EXISTS fnGetBlock
GO

CREATE FUNCTION fnGetBlock(@saleId UNIQUEIDENTIFIER)
	RETURNS VARCHAR(50) AS
	BEGIN
		DECLARE @result VARCHAR(50);
		
		SET @result = (
			SELECT E.Name + ': ' + CAST(Section.Name AS VARCHAR(20)) + 
				' - Row ' + CAST(R.RowNumber AS VARCHAR(5)) + 
				' - (' + STRING_AGG(Seat.SeatNumber, ',') WITHIN GROUP (ORDER BY Seat.SeatNumber) + 
				')'
			FROM EventSeatSale ESS
				 JOIN EventSeat ES ON ES.EventSeatId = ESS.EventSeatId
				 JOIN Seat ON Seat.SeatId = ES.SeatId
				 JOIN Row R ON R.RowId = Seat.RowId
				 JOIN Section ON Section.SectionId = R.SectionId
				 JOIN Event E ON E.EventId = ES.EventId
			WHERE ESS.SaleId = @saleId
			GROUP BY E.Name, Section.Name, R.RowNumber);

		RETURN @result;
	END
GO

DECLARE @saleIdParam UNIQUEIDENTIFIER = (SELECT SaleId 
										 FROM Sale
										 INNER JOIN Customer C ON C.CustomerId = Sale.CustomerId
										 WHERE C.FirstName = 'Steve' AND C.LastName = 'Rogers');
SELECT dbo.fnGetBlock(@saleIdParam) AS Result

------------------------------ Question 4 ----------------------------------
DROP PROC IF EXISTS upcomingEventInfo
GO

CREATE PROC upcomingEventInfo AS
	SELECT V.Name AS [Venue Name], E.Name AS [Event Name], 
		   CONVERT(VARCHAR, E.StartDate, 107) AS Date, 
		   CONVERT(VARCHAR, E.StartDate, 108) AS [Start Time],
		   COUNT(ES.SeatId) AS [Available Seats]
	FROM EventSeatSale ESS
		 RIGHT JOIN EventSeat ES ON ES.EventSeatId = ESS.EventSeatId
		 INNER JOIN Seat ON Seat.SeatId = ES.SeatId
		 INNER JOIN Event E ON E.EventId = ES.EventId
		 INNER JOIN Venue V ON V.Id = E.VenueId
	WHERE E.StartDate > GETDATE() AND ESS.EventSeatId IS NULL
	GROUP BY V.Name, E.Name, E.StartDate
GO

EXEC upcomingEventInfo;

------------------------------ Question 5 ----------------------------------
DROP PROC IF EXISTS ticketInfo
GO

CREATE PROC ticketInfo(@eventId UNIQUEIDENTIFIER) AS
	-- a
	SELECT C.CustomerId, dbo.fnGetBlock(Sale.SaleId) AS TicketBlock
	FROM Customer C
		 INNER JOIN Sale ON Sale.CustomerId = C.CustomerId
		 INNER JOIN EventSeatSale ESS ON ESS.SaleId = Sale.SaleId
		 INNER JOIN EventSeat ES ON ES.EventSeatId = ESS.EventSeatId
		 INNER JOIN Event E ON E.EventId = ES.EventId
	WHERE E.EventId = @eventId
	GROUP BY C.CustomerId, dbo.fnGetBlock(Sale.SaleId)
	ORDER BY TicketBlock

	-- b
	SELECT Section.Name AS Section, R.RowNumber AS Row, COUNT(Seat.SeatId) AS [Seat Count]
	FROM EventSeatSale ESS
		 RIGHT JOIN EventSeat ES ON ES.EventSeatId = ESS.EventSeatId
		 INNER JOIN Seat ON Seat.SeatId = ES.SeatId
		 INNER JOIN Row R ON R.RowId = Seat.RowId
		 INNER JOIN Section ON Section.SectionId = R.SectionId
		 INNER JOIN Event E ON E.EventId = ES.EventId
	WHERE ESS.EventSeatId IS NULL AND E.EventId = @eventId
	GROUP BY Section.Name, R.RowNumber
	ORDER BY Section.Name, R.RowNumber, [Seat Count]
GO

DECLARE @eventIdParam UNIQUEIDENTIFIER = (SELECT EventId 
										  FROM Event
										  WHERE Name = 'Beyonce'
										  GROUP BY EventId);

EXEC ticketInfo @eventIdParam;