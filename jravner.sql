-- Joey's SQL Code
USE Group8_Spotify
GO
-- Transactional Table Stored Procedures
-- tblEVENT, tblCUSTOMER_DEVICE
CREATE PROCEDURE usp_INSERT_tblEVENT
@groupName varchar(75),
@songName varchar(75),
@albumName varchar(75),
@eventTypeName varchar(75),
@custFName varchar(75),
@custLName varchar(75),
@custDOB DATE,
@eventDate DATE

AS

DECLARE @C_ID INT = (
  SELECT custID
  FROM tblCUSTOMER
  WHERE custFName = @custFName
    AND custLName = @custLName
    AND custDOB = @custDOB
)
DECLARE @R_ID INT = (
  SELECT R.recordingID
  FROM tblRECORDING R
    JOIN tblSONG_GROUP SG ON R.songGroupID = SG.songGroupID
    JOIN tblSONG S ON SG.songID = S.songID
    JOIN tblGROUP G ON SG.groupID = G.groupID
    JOIN tblRECORDING_ALBUM RA ON R.recordingID = RA.recordingID
    JOIN tblALBUM A ON RA.albumID = A.albumID
  WHERE S.songName = @songName
    AND G.groupName = @groupName
    AND A.albumName = @albumName
)
DECLARE @ET_ID INT = (
  SELECT eventTypeID
  FROM tblEVENT_TYPE
  WHERE eventTypeName = @eventTypeName
)

INSERT INTO tblEVENT (recordingID, eventTypeID, custID, eventDate)
VALUES (@R_ID, @ET_ID, @C_ID, @eventDate)
GO

CREATE PROCEDURE usp_INSERT_tblCUSTOMER_DEVICE
@custFName varchar(75),
@custLName varchar(75),
@custDOB DATE,
@deviceName varchar(75)

AS

DECLARE @D_ID INT = (
  SELECT deviceID
  FROM tblDEVICE
  WHERE deviceName = @deviceName
)
DECLARE @C_ID INT = (
  SELECT custID
  FROM tblCUSTOMER
  WHERE custFName = @custFName
    AND custLName = @custLName
    AND custDOB = @custDOB
)

INSERT INTO tblCUSTOMER_DEVICE (custID, deviceID)
VALUES (@C_ID, @D_ID)
GO

-- Look-Up Table Stored Procedures
-- tblSONG, tblGROUP
CREATE PROCEDURE usp_INSERT_tblSONG
@songName varchar(75)

AS

INSERT INTO tblSONG (songName)
VALUES (@songName)
GO

CREATE PROCEDURE usp_INSERT_tblGROUP
@groupName varchar(75),
@groupBio varchar(500),
@groupPic varchar(500)

AS

INSERT INTO tblGROUP (groupName, groupBio, groupPic)
VALUES (@groupName, @groupBio, @groupPic)
GO

--Business Rule
/* DESCRIPTION:
Can’t create a private playlist with a free account type.
Spotify has a restriction on playlist type. Customers who are Free listeners
do not have the ability to make a playlist private.
*/
-- Code:
CREATE FUNCTION fn_noPrivateFreeUsers ()
RETURNS INT
AS
BEGIN

  DECLARE @Ret INT = 0

  IF EXISTS (
    SELECT *
    FROM tblCUSTOMER C
      JOIN tblCUSTOMER_PLAYLIST CP ON C.custID = CP.custID
      JOIN tblPLAYLIST P ON CP.playlistID = P.playlistID
      JOIN tblPLAYLIST_TYPE PT ON P.playlistTypeID = PT.playlistTypeID
      JOIN tblCUSTOMER_TYPE CT ON C.custTypeID = CT.custTypeID
    WHERE CT.custTypeName  = 'Free'
      AND PT.playlistTypeName = 'Private'
  ) BEGIN
    SET @Ret = 1
  END

RETURN @Ret
END
GO

ALTER TABLE tblPLAYLIST -- Won't Alter
ADD CONSTRAINT ck_noPrivatePlaylistFreeUsers
CHECK (dbo.fn_noPrivateFreeUsers() = 0)
GO

-- Computed Column
-- Time listened / user
CREATE FUNCTION fn_timeListenedPerUser (@PK INT)
RETURNS Time
AS
BEGIN

DECLARE @Ret Time = (
  SELECT SUM(R.recordingLength) --Can't Sum Time
  FROM tblCUSTOMER C
    JOIN tblEVENT E ON C.custID = E.custID
    JOIN tblRECORDING R ON E.recordingID = R.recordingID
  WHERE C.custID = @PK
)

RETURN @Ret
END
GO

ALTER TABLE tblCUSTOMER
ADD custTotalTimeListened AS (dbo.fn_timeListenedPerUser(custID))
GO

-- Query
-- Write the SQL query to list the top 3 groups who has the most listened
    -- between 2012 and 2015, in Jazz.
SELECT TOP 3 G.groupName, COUNT(E.eventID) AS Listens
FROM tblGROUP G
  JOIN tblSONG_GROUP SG ON G.groupID = SG.groupID
  JOIN tblRECORDING R ON SG.songGroupID = R.songGroupID
  JOIN tblGENRE GR ON R.genreID = GR.genreID
  JOIN tblEVENT E ON R.recordingID = E.recordingID
  JOIN tblEVENT_TYPE ET ON E.eventTypeID = ET.eventTypeID
WHERE G.genreName = 'Jazz'
  AND E.eventDate BETWEEN 'January 1, 2012' AND 'December 31, 2015'
GROUP BY G.groupName
GO

-- Add to Look Up Tables
EXEC usp_INSERT_tblSONG
@songName = 'Love Yourself'

EXEC usp_INSERT_tblSONG
@songName = 'Drop It Like Its Hot'

EXEC usp_INSERT_tblSONG
@songName = 'I Like It'

EXEC usp_INSERT_tblSONG
@songName = 'Goosebumps'

EXEC usp_INSERT_tblSONG
@songName = 'Foreword'


-- Need to run group code
EXEC usp_INSERT_tblGROUP
@groupName  = 'Justin Bieber',
@groupBio  = '',
@groupPic  = ''

EXEC usp_INSERT_tblGROUP
@groupName = 'Travis Scott',
@groupBio = '',
@groupPic = ''

EXEC usp_INSERT_tblGROUP
@groupName = 'Snoop Dogg',
@groupBio = '',
@groupPic = ''

EXEC usp_INSERT_tblGROUP
@groupName  = 'Cardi B',
@groupBio = '',
@groupPic  = ''

EXEC usp_INSERT_tblGROUP
@groupName = 'Drake Graham',
@groupBio  = '',
@groupPic = ''

EXEC usp_INSERT_tblGROUP
@groupName = 'Justin Bieber',
@groupBio  = '',
@groupPic = ''
