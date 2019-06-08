/* 
Group 8 - Spotify
Joey Ravner
Tristian Macelli
Amelia Shull
Akoly Vongdala
Kyler Griffith
*/

-- Database Itialization Code
CREATE DATABASE Group8_Spotify

CREATE TABLE [tblDEVICE_TYPE] (
	[deviceTypeID] INTEGER IDENTITY(1,1) primary key,
	[deviceTypeName] varchar(75) not null,
	[deviceTypeDescr] varchar(500) NULL
);

CREATE TABLE [tblSONG] (
	[songID] INTEGER IDENTITY(1,1) primary key,
	[songName] varchar(75) not null
);

CREATE TABLE [tblGENRE] (
	[genreID] INTEGER IDENTITY(1,1) primary key,
	[genreName] varchar(75) not null,
	[genreDescr] varchar(500) NULL
);

CREATE TABLE [tblEVENT_TYPE] (
	[eventTypeID] INTEGER IDENTITY(1,1) primary key,
	[eventTypeName] varchar(75) not null,
	[eventTypeDescr] varchar(500) NULL
);

CREATE TABLE [tblARTIST] (
	[artistID] INTEGER IDENTITY(1,1) primary key,
	[artistFName] varchar(75) not null,
	[artistLName] varchar(75) not null,
	[artistBio] varchar(500) not null,
	[artistPic] varchar(500) not null
);

CREATE TABLE [tblGROUP] (
	[groupID] INTEGER IDENTITY(1,1) primary key,
	[groupName] varchar(75) not null,
	[groupBio] varchar(500) not null,
	[groupPic] varchar(500) not null
);

CREATE TABLE [tblCUSTOMER_TYPE] (
	[custTypeID] INTEGER IDENTITY(1,1) primary key,
	[custTypeName] varchar(75) not null,
	[custTypeDescr] varchar(500) NULL
);

CREATE TABLE [tblROLE] (
	[roleID] INTEGER IDENTITY(1,1) primary key,
	[roleName] varchar(75) not null,
	[roleDescr] varchar(500) NULL
);

CREATE TABLE [tblRECORDING_RATING] (
	[recordingRatingID] INTEGER IDENTITY(1,1) primary key,
	[ratingName] varchar(75) not null
);

CREATE TABLE [tblALBUM] (
	[albumID] INTEGER IDENTITY(1,1) primary key,
	[albumName] varchar(75) not null,
	[albumPic] varchar(500) not null,
	[albumDescr] varchar(500) NULL,
	[albumLabel] varchar(75) NULL,
	[albumReleaseDate] Date not null
);

CREATE TABLE [tblPLAYLIST_TYPE] (
	[playlistTypeID] INTEGER IDENTITY(1,1) primary key,
	[playlistTypeName] varchar(75) not null
);

CREATE TABLE [tblSONG_GROUP] (
	[songGroupID] INTEGER IDENTITY(1,1) primary key,
	[songID] INT FOREIGN KEY REFERENCES tblSONG (songID) not null,
	[groupID] INT FOREIGN KEY REFERENCES tblGROUP (groupID) not null
);

CREATE TABLE [tblRECORDING] (
	[recordingID] INTEGER IDENTITY(1,1) primary key,
	[songGroupID] INT FOREIGN KEY REFERENCES tblSONG_GROUP (songGroupID) not null,
	[genreID] INT FOREIGN KEY REFERENCES tblGENRE (genreID) not null,
	[recordingRatingID] INT FOREIGN KEY REFERENCES tblRECORDING_RATING (recordingRatingID) not null,
	[recordingLength] Time not null
);

CREATE TABLE [tblCUSTOMER] (
	[custID] INTEGER IDENTITY(1,1) primary key,
	[custTypeID] INT FOREIGN KEY REFERENCES tblCUSTOMER_TYPE (custTypeID) not null,
	[custFName] varchar(75) not null,
	[custLName] varchar(75) not null,
	[custDOB] Date not null,
	[custAddress] varchar(100) not null,
	[custState] varchar(2) not null,
	[custZip] varchar(75) not null,
	[custLanguage] varchar(2) not null,
	[custPic] varchar(500) NULL
);


CREATE TABLE [tblDEVICE] (
	[deviceID] INTEGER IDENTITY(1,1) primary key,
	[deviceTypeID]  INT FOREIGN KEY REFERENCES tblDEVICE_TYPE (deviceTypeID) not null,
	[deviceName] varchar(75) not null
);


CREATE TABLE [tblCUSTOMER_DEVICE] (
	[custDeviceID] INTEGER IDENTITY(1,1) primary key,
	[custID] INT FOREIGN KEY REFERENCES tblCUSTOMER (custID) not null,
	[deviceID] INT FOREIGN KEY REFERENCES tblDEVICE (deviceID) not null
);

CREATE TABLE [tblRECORDING_ALBUM] (
	[recordingAlbumID] INTEGER IDENTITY(1,1) primary key,
	[recordingID] INT FOREIGN KEY REFERENCES tblRECORDING (recordingID) not null,
	[albumID] INT FOREIGN KEY REFERENCES tblALBUM (albumID) not null
);

CREATE TABLE [tblGROUP_MEMBER] (
	[groupMemberID] INTEGER IDENTITY(1,1) primary key,
	[groupID] INT FOREIGN KEY REFERENCES tblGROUP (groupID) not null,
	[artistID] INT FOREIGN KEY REFERENCES tblARTIST (artistID) not null,
	[roleID] INT FOREIGN KEY REFERENCES tblROLE (roleID) not null,
);

CREATE TABLE [tblPLAYLIST] (
	[playlistID] INTEGER IDENTITY(1,1) primary key,
	[playlistTypeID] INT FOREIGN KEY REFERENCES tblPLAYLIST_TYPE (playlistTypeID) not null,
	[playlistName] varchar(75) not null,
	[playlistDescr] varchar(500) NULL
);

CREATE TABLE [tblCUSTOMER_PLAYLIST] (
	[customerPlaylistID] INTEGER IDENTITY(1,1) primary key,
	[custID] INT FOREIGN KEY REFERENCES tblCUSTOMER (custID) not null,
	[playlistID] INT FOREIGN KEY REFERENCES tblPLAYLIST (playlistID) not null,
);

CREATE TABLE [tblEVENT] (
	[eventID] INTEGER IDENTITY(1,1) primary key,
	[recordingID] INT FOREIGN KEY REFERENCES tblRECORDING (recordingID) not null,
	[eventTypeID] INT FOREIGN KEY REFERENCES tblEVENT_TYPE (eventTypeID) not null,
	[custID] INT FOREIGN KEY REFERENCES tblCUSTOMER (custID) not null,
	[eventDate] DATE not null
);

-- Store Procedures for Transaction Tables (10)
-- 1. tblPLAYLIST
CREATE PROCEDURE usp_INSERT_tblPLAYLIST
@Name varchar(75),
@Descr varchar(500),
@PlaylistTypeName varchar(75)

AS

DECLARE @PT_ID INT = (SELECT playlistTypeID 
					  FROM tblPLAYLIST_TYPE 
					  WHERE playlistTypeName = @PlaylistTypeName)

BEGIN TRAN T1
INSERT INTO tblPLAYLIST(playlistTypeID, playlistName, playlistDescr)
VALUES (@PT_ID, @Name, @Descr)
COMMIT TRAN T1
GO

-- 2. tblDEVICE
CREATE PROCEDURE usp_INSERT_tblDEVICE
@Name varchar(75),
@DeviceTypeName varchar(75)

AS

DECLARE @DT_ID INT = (SELECT deviceTypeID 
					  FROM tblDEVICE_TYPE 
					  WHERE deviceTypeName = @DeviceTypeName)

BEGIN TRAN T1
INSERT INTO tblDEVICE(deviceTypeID, deviceName)
VALUES (@DT_ID, @Name)
COMMIT TRAN T1
GO

-- 3. tblCUSTOMER
CREATE PROCEDURE usp_CREATE_CUSTOMER
@typeName varchar(75),
@fName varchar(75),
@lName varchar(75),
@dob DATE,
@address varchar(100),
@city varchar(100),
@state varchar(2),
@zip varchar(75),
@language varchar(2),
@pic varchar(500)

AS

DECLARE @CT_ID INT = (SELECT CT.custTypeID FROM tblCUSTOMER_TYPE CT
                    WHERE CT.custTypeName = @typeName)

BEGIN TRAN T1
INSERT INTO tblCUSTOMER(custTypeID, custFname, custLname, custDOB, custAddress, custState, custZip, custLanguage, custPic, custCity)
VALUES(@CT_ID, @fName, @lName, @dob, @address, @state, @zip, @language, @pic, @city)
COMMIT TRAN T1
GO

-- 4. tblCUSTOMER_PLAYLIST
CREATE PROCEDURE usp_CREATE_CUSTOMER_PLAYLIST
@fName varchar(75),
@lName varchar(75),
@dob DATE,
@address varchar(100),
@playlistName varchar(75),
@playlistTypeName varchar(75)

AS

DECLARE @C_ID INT = (SELECT C.custID FROM tblCUSTOMER C
                    WHERE C.custFName = @fName 
                    AND C.custLname = @lName AND C.custDOB = @dob 
                    AND C.custAddress = @address)

DECLARE @PT_ID INT = (SELECT PT.playlistTypeID FROM tblPLAYLIST_TYPE PT
                        WHERE PT.playlistTypeName = @playlistTypeName)

DECLARE @P_ID INT = (SELECT P.playlistID FROM tblPLAYLIST P
                    WHERE P.playlistName = @playlistName AND P.playlistTypeID = @PT_ID)

BEGIN TRAN T1
INSERT INTO tblCUSTOMER_PLAYLIST(custID, playlistID)
VALUES(@C_ID, @P_ID)
COMMIT TRAN T1
GO

-- 5. tblEVENT
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

BEGIN TRAN T1
INSERT INTO tblEVENT (recordingID, eventTypeID, custID, eventDate)
VALUES (@R_ID, @ET_ID, @C_ID, @eventDate)
COMMIT TRAN T1
GO

-- 6. tblCUSTOMER_DEVICE
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

BEGIN TRAN T1
INSERT INTO tblCUSTOMER_DEVICE (custID, deviceID)
VALUES (@C_ID, @D_ID)
COMMIT TRAN T1
GO

-- 7. tblRECORDING
CREATE PROCEDURE usp_INSERT_RECORDING
@GenreName varchar (100),
@SongName varchar(100),
@GroupName varchar(100),
@RatingName varchar(100),
@RecordLength time(7)

AS 

DECLARE @songGroupID INT
DECLARE @genreID INT
DECLARE @recordingRatingID INT

SET @songGroupID = (SELECT SG.songGroupID 
					FROM tblSONG S
					JOIN tblSONG_GROUP SG ON S.songID = SG.songID
					JOIN tblRECORDING R ON SG.songGroupID = R.songGroupID
					WHERE S.songName = @SongName)

SET @genreID = (SELECT G.genreID
				FROM tblGENRE G 
				WHERE G.genreName = @GenreName)
				
SET @recordingRatingID = (SELECT RR.recordingRatingID 
						 FROM tblRECORDING_RATING RR
						 WHERE RR.ratingName = @RatingName)

BEGIN TRAN G1
INSERT INTO tblRECORDING(songGroupID,genreID, recordingRatingID, recordingLength)
VALUES (@songGroupID, @genreID, @recordingRatingID, @RecordLength)
COMMIT TRAN G1
GO

-- 8. tblRECORDING_ALBUM
CREATE PROCEDURE usp_INSERT_RECORDING_ALBUM
@AlbumName varchar (200),
@AlbumDescr varchar(200),
@AlbumDate DATE,
@RecordLength time(7)

AS 

DECLARE @recordingID INT
DECLARE @albumID INT

SET @recordingID = (SELECT R.recordingID 
					FROM tblRECORDING R
					WHERE R.recordingLength = @RecordLength)

SET @albumID = (SELECT A.albumID 
				FROM tblALBUM A
				WHERE A.albumName = @AlbumName
				AND A.albumDescr = @albumDescr
				AND A.albumReleaseDate = @AlbumDate)
				
BEGIN TRAN G1
INSERT INTO tblRECORDING_ALBUM(recordingID, albumID)
VALUES(@recordingID, @albumID)
COMMIT TRAN G1
GO

-- 9. tblSONG_GROUP
CREATE PROCEDURE usp_INSERT_tblSONG_GROUP
@SongName varchar(75),
@GroupName varchar(75)

AS

DECLARE @SongID INT = (
	SELECT songID
	FROM tblSONG 
	WHERE songName = @SongName
)
DECLARE @GroupID INT = (
	SELECT groupID
	FROM tblGROUP
	WHERE groupName = @GroupName
)

BEGIN TRAN T1
INSERT INTO tblSONG_GROUP(songID, groupID)
VALUES(@SongID, @GroupID)
COMMIT TRAN T1
GO

-- 10. tblGROUP_MEMBER
CREATE PROCEDURE usp_INSERT_tblGROUP_MEMBER
@GroupName varchar(75),
@ArtistFName varchar(75),
@ArtistLName varchar(75),
@RoleName varchar(75)

AS

DECLARE @GroupID INT = (
	SELECT groupID
	FROM tblGROUP
	WHERE groupName = @GroupName
)
DECLARE @ArtistID INT = (
	SELECT artistID
	FROM tblARTIST
	WHERE artistFName = @ArtistFName 
		AND artistLName = @ArtistLName
)
DECLARE @RoleID INT = (
	SELECT roleID
	FROM tblROLE
	WHERE roleName = @RoleName
)

BEGIN TRAN T1
INSERT INTO tblGROUP_MEMBER(groupID, artistID, roleID)
VALUES(@GroupID, @ArtistID, @RoleID)
COMMIT TRAN T1
GO

-- Business Rules (5)
-- 1. No users under the age of 13.
REATE FUNCTION ck_noAccountUnder13()
RETURNS INT
AS
BEGIN
DECLARE @ret INT = 0
IF EXISTS (SELECT *
            FROM tblCUSTOMER C
            WHERE C.custDOB > (SELECT GetDate() - (365.25 * 13)))
            BEGIN
                SET @ret = 1
            END
RETURN @ret
END
GO

ALTER TABLE tblCUSTOMER
ADD CONSTRAINT ck_noAccountUnder13
CHECK (dbo.ck_noAccountUnder13() = 0)
GO

-- 2. Users can't create a private playlist with a free account type.
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

ALTER TABLE tblPLAYLIST
ADD CONSTRAINT ck_noPrivatePlaylistFreeUsers
CHECK (dbo.fn_noPrivateFreeUsers() = 0)
GO

-- 3. User must be 18 to listen to explicit songs/albums.
CREATE FUNCTION fn_noExplicitUnder18 ()
RETURNS INT
AS
BEGIN

  DECLARE @Ret INT = 0

  IF EXISTS (
    SELECT C.custDOB
    FROM tblCUSTOMER C
      JOIN tblEvent E ON C.custID = E.custID
      JOIN tblRECORDING R ON E.recordingID = R.recordingID
      JOIN tblRECORDING_RATING RR ON R.recordingRatingID = RR.recordingRatingID
      JOIN tblRECORDING_ALBUM RA ON R.recordingID = RA.recordingID
      JOIN tblALBUM A ON RA.albumID = A.albumID
    WHERE A.AlbumRating  = 'Explicit'
      AND RR.ratingName = 'Explicit'
      AND C.custDOB >= (SELECT GETDATE() - (365.25 * 18))
  ) BEGIN
    SET @Ret = 1
  END

	RETURN @Ret
END
GO

ALTER TABLE tblCUSTOMER
ADD CONSTRAINT ck_noExplicitUnder18
CHECK (dbo.fn_noExplicitUnder18() = 0)
GO

-- 4. Users can only add to their own playlists.
CREATE FUNCTION fn_RestrictPlaylistAdditions()
RETURNS INT
AS
BEGIN
	DECLARE @Ret INT = 0
	IF EXISTS (
		SELECT *
		FROM tblPLAYLIST_TYPE PT
			JOIN tblPLAYLIST P ON PT.playlistTypeID = P.playlistTypeID
			JOIN tblCUSTOMER_PLAYLIST CP ON P.playListID = CP.playListID
			JOIN tblCUSTOMER C ON CP.custID = C.custID
		WHERE PT.playlistTypeName = 'Private'
			AND 'addToPlayList' + CAST(P.playListID AS VARCHAR(100)) IN (
				SELECT ET.eventTypeName
				FROM tblEVENT_TYPE ET
					JOIN tblEVENT E ON ET.eventTypeID = E.eventTypeID
					JOIN tblCUSTOMER C2 ON E.custID = C2.custID
				WHERE ET.eventTypeName LIKE 'addToPlayList%' + CAST(P.playlistID AS VARCHAR(100))
				AND C.custID != C2.custID
			)
			
	)
	BEGIN
		SET @Ret = 1
	END
	RETURN @Ret
END
GO

ALTER TABLE tblEVENT
ADD CONSTRAINT ck_RestrictPlaylistAdditions
CHECK (dbo.fn_RestrictPlaylistAdditions() = 0)
GO

-- 5. Free users cannot have more than 3 devices linked to their account.
CREATE FUNCTION fn_restrictDevicesFreeUsers()
RETURNS INT
AS
BEGIN
DECLARE @Ret INT = 0
		IF EXISTS(SELECT C.custID
				  FROM tblCUSTOMER_DEVICE CD
					JOIN tblCUSTOMER C ON CD.custID = C.custID
					JOIN tblCUSTOMER_TYPE CT ON C.custTypeID = CT.custTypeID
				  WHERE CT.custTypeName = 'Free'
				  GROUP BY C.custID
				  HAVING COUNT(*) > 3
		)
		BEGIN
			SET @Ret = 1
		END
	RETURN @Ret
END
GO

ALTER TABLE tblCUSTOMER_DEVICE
ADD CONSTRAINT ck_numDevicesFreeUsers
CHECK (dbo.fn_restrictDevicesFreeUsers() = 0)
GO

-- Computed Columns (5)
-- 1. Time Listened per User
CREATE FUNCTION fn_timeListenedPerUser (@PK INT)
RETURNS numeric(8,2)
AS
BEGIN

DECLARE @Ret numeric(8,2) = (
  SELECT (CAST(SUM(DATEDIFF(SECOND, '0:00:00', recordingLength)) AS numeric(8,2)) / 60)
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

-- 2. Playlist Length
CREATE FUNCTION fn_PlayListLength(@PK INT)
RETURNS NUMERIC(8,2)
AS 
BEGIN
	DECLARE @Ret NUMERIC(8,2) = (SELECT (CAST(SUM(DATEDIFF(SECOND, '0:00:00', R.recordingLength)) AS numeric(8,2)) / 60)
	FROM tblPLAYLIST P 
		JOIN tblCUSTOMER_PLAYLIST CP ON P.playlistID = CP.playlistID
		JOIN tblCUSTOMER C ON CP.custID = C.custID
		JOIN tblEVENT E ON C.custID = E.custID
		JOIN tblRECORDING R ON E.recordingID = R.recordingID
	WHERE P.playlistID = @PK)

RETURN @Ret
END
GO 

ALTER TABLE tblPLAYLIST
ADD PlayListLength AS (dbo.fn_PlayListLength(playlistID))
GO

-- 3. Find Album Genre
CREATE FUNCTION fn_ComputeAlbumGenre(@PK INT)
RETURNS varchar(75)
AS
BEGIN
	DECLARE @Ret varchar(75) = (
		SELECT genreName FROM (
		SELECT TOP 1 G.genreName, COUNT(*) as Count
		FROM tblALBUM A
			JOIN tblRECORDING_ALBUM RA ON A.albumID = RA.albumID
			JOIN tblRECORDING R ON RA.recordingID = R.recordingID
			JOIN tblGENRE G ON R.genreID = G.genreID
		WHERE A.albumID = @PK
		GROUP BY G.genreName
		ORDER BY Count DESC
		) as sbq
	)
	RETURN @Ret
END
GO

ALTER TABLE tblALBUM
ADD albumGenre AS (dbo.fn_ComputeAlbumGenre(albumID))
GO

-- 4. Find Album Rating
CREATE FUNCTION fn_AlbumRating(@PK INT)
RETURNS varchar(8)
AS
BEGIN
DECLARE @Ret varchar(8) = (
			SELECT ratingName FROM (
				SELECT TOP 1 RR.ratingName, COUNT(*) as AlbumRating
				FROM tblALBUM A
					JOIN tblRECORDING_ALBUM RA ON A.albumID = RA.albumID
					JOIN tblRECORDING R ON RA.recordingID = R.recordingID
					JOIN tblRECORDING_RATING RR ON R.recordingRatingID = RR.recordingRatingID
				WHERE A.albumID = @PK
				GROUP BY RR.ratingName
				ORDER BY AlbumRating DESC
			) as rating
		)
	RETURN @Ret
END
GO

ALTER TABLE tblALBUM
ADD albumRating AS (dbo.fn_AlbumRating(albumID))
GO

-- 5. Total Listening Time per Group
CREATE FUNCTION fn_timeListenedGroup(@PK INT)
RETURNS NUMERIC(8,2)
AS
BEGIN
    DECLARE @Ret numeric(8,2) = (SELECT (CAST(SUM(DATEDIFF(SECOND, '0:00:00', R.recordingLength)) AS numeric(8,2)) / 60)
                                FROM tblGROUP G
                                    JOIN tblSONG_GROUP SG ON G.groupID = SG.groupID
                                    JOIN tblRECORDING R ON SG.songGroupID = R.songGroupID
                                    JOIN tblEVENT E ON R.recordingID = E.recordingID
                                    JOIN tblEVENT_TYPE ET ON E.eventTypeID = ET.eventTypeID
                                WHERE G.groupID = @PK AND ET.eventTypeName = 'play')
RETURN @Ret
END
GO

ALTER TABLE tblGROUP
ADD totalTimeListenedTo AS (dbo.fn_timeListenedGroup(groupID))
GO

-- Queries (5)
-- 1. Select the top 100 most listened to songs.
SELECT TOP 100 S.songName, COUNT(E.eventID) AS "# of plays"
FROM tblSONG S
    JOIN tblSONG_GROUP SG ON S.SongID = SG.songID
    JOIN tblRECORDING R ON SG.songGroupID = R.songGroupID
    JOIN tblEVENT E ON R.recordingID = E.recordingID
    JOIN tblEVENT_TYPE ET ON E.eventTypeID = ET.eventTypeID
WHERE ET.eventTypeName = 'play'
GROUP BY S.songName
ORDER BY COUNT(E.eventID) DESC
GO

-- 2. Determine the most popular/most listened to song by Justin Bieber in the year 2019
SELECT TOP 1 A.ArtistFname, A.ArtistLName, S.SongName, COUNT(ET.eventTypeName) AS Listens
FROM tblARTIST A 
	JOIN tblGROUP_MEMBER GM ON A.artistID = A.artistID
	JOIN tblGROUP G ON GM.groupID = G.groupID
	JOIN tblSONG_GROUP SG ON G.groupID = SG.groupID
	JOIN tblSONG S ON SG.songID = S.songID
	JOIN tblRECORDING R ON SG.songGroupID = R.songGroupID
	JOIN tblEVENT E ON R.recordingID = E.recordingID
	JOIN tblEVENT_TYPE ET ON E.eventTypeID = ET.eventTypeID
WHERE A.artistFName = 'Justin'
  AND A.artistLName = 'Bieber'
  AND E.eventDate BETWEEN 'January 1, 2019' AND 'December 31, 2019'
  AND ET.eventTypeName = 'play'
GROUP BY A.artistFName, A.ArtistLName, S.SongName
GO

-- 3. Find all premium customers who are at least 18 years old, and have 'Love Yourself' in a playlist
SELECT C.custID, C.custFName, C.custLName
FROM tblEVENT_TYPE ET
	JOIN tblEVENT E ON ET.eventTypeID = E.eventTypeID
	JOIN tblRECORDING R ON E.recordingID = R.recordingID
	JOIN tblSONG_GROUP SG ON R.songGroupID = SG.songGroupID
	JOIN tblSONG S on SG.songID = S.songID	
	JOIN tblCUSTOMER C ON E.custID = C.custID
WHERE S.songName = 'Love Yourself' AND (SELECT SUBSTRING(ET.eventTypeName, 14 , LEN(ET.eventTypeName))) IN (
	 (
		SELECT P.playListID 
		FROM tblPLAYLIST P
			JOIN tblCUSTOMER_PLAYLIST CP ON P.playlistID = CP.playlistID
			JOIN tblCUSTOMER C ON CP.custID = C.custID
			JOIN tblCUSTOMER_TYPE CT ON C.custTypeID = CT.custTypeID
		WHERE C.custDOB <= (SELECT GETDATE() - (365.25 * 18)) AND CT.custTypeName = 'Premium'
	)
)
GO

-- 4. Write the SQL query to list the top group who has the most listened between 2012 and 2019, in Pop.
SELECT G.groupName, COUNT(E.eventID) AS Listens
FROM tblGROUP G
  JOIN tblSONG_GROUP SG ON G.groupID = SG.groupID
  JOIN tblRECORDING R ON SG.songGroupID = R.songGroupID
  JOIN tblGENRE GR ON R.genreID = GR.genreID
  JOIN tblEVENT E ON R.recordingID = E.recordingID
  JOIN tblEVENT_TYPE ET ON E.eventTypeID = ET.eventTypeID
WHERE GR.genreName = 'Pop'
  AND ET.eventTypeName = 'play'
  AND E.eventDate BETWEEN 'January 1, 2012' AND 'December 31, 2019'
GROUP BY G.groupName
GO

-- 5. Find all songs in a playlist that have over 50 songs
		-- Can change number to 1 or 2 to test
SELECT S.songName
FROM tblSONG S 
	JOIN tblSONG_GROUP SG ON S.songID = SG.songID
	JOIN tblRECORDING R ON SG.songGroupID = R.songGroupID
	JOIN tblEVENT E ON R.recordingID = E.recordingID
	JOIN tblEVENT_TYPE ET ON E.eventTypeID = ET.eventTypeID
WHERE ET.eventTypeName IN
	(
		SELECT ET2.eventTypeName
		FROM tblEVENT_TYPE ET2 
			JOIN tblEVENT E2 ON ET2.eventTypeID = E2.eventTypeID
		WHERE ET2.eventTypeName LIKE 'addToPlaylist%'
		GROUP BY ET2.eventTypeName
		HAVING COUNT(E2.eventID) > 50
	)
GROUP BY S.SongName
GO

-- Lookup Table Stored Procedures
CREATE PROCEDURE usp_INSERT_tblSONG
@songName varchar(75)

AS

BEGIN TRAN T1
INSERT INTO tblSONG (songName)
VALUES (@songName)
COMMIT TRAN T1
GO

CREATE PROCEDURE usp_INSERT_tblGROUP
@groupName varchar(75),
@groupBio varchar(500),
@groupPic varchar(500)

AS

BEGIN TRAN T1
INSERT INTO tblGROUP (groupName, groupBio, groupPic)
VALUES (@groupName, @groupBio, @groupPic)
COMMIT TRAN T1
GO

CREATE PROCEDURE usp_INSERT_tblALBUM
@Name varchar(75),
@Pic varchar(500),
@Descr varchar(500),
@Label varchar(75),
@Release Date

AS

BEGIN TRAN T1
INSERT INTO tblALBUM(albumName, albumPic, albumDescr, albumLabel, albumReleaseDate)
VALUES (@Name, @Pic, @Descr, @Label, @Release)
COMMIT TRAN T1
GO

CREATE PROCEDURE usp_INSERT_tblRECORDING_RATING
@Name varchar(75)

AS

BEGIN TRAN T1
INSERT INTO tblRECORDING_RATING(ratingName)
VALUES (@Name)
COMMIT TRAN T1
GO

CREATE PROCEDURE usp_INSERT_tblCUSTOMER_TYPE
@CustTypeName varchar(75),
@CustTypeDescr varchar(500)

AS

BEGIN TRAN T1
INSERT INTO tblCUSTOMER_TYPE(custTypeName, custTypeDescr)
VALUES(@CustTypeName, @CustTypeDescr)
COMMIT TRAN T1
GO

CREATE PROCEDURE usp_INSERT_tblPLAYLIST_TYPE
@PlaylistTypeName varchar(75)

AS

BEGIN TRAN T1
INSERT INTO tblPLAYLIST_TYPE(playlistTypeName)
VALUES(@PlaylistTypeName)
COMMIT TRAN T1
GO

CREATE PROCEDURE usp_INSERT_ARTIST
@Fname varchar (30),
@Lname varchar(30),
@Bio varchar(1000),
@Pic varchar(500)

AS 

BEGIN TRAN T1
INSERT INTO tblARTIST(artistFName, artistLName, artistBio, artistPic)
VALUES (@Fname, @Lname, @Bio, @Pic)
COMMIT TRAN T1
GO

CREATE PROCEDURE usp_INSERT_GENRE
@GName varchar (100),
@GDescr varchar(500)

AS 

BEGIN TRAN T1
INSERT INTO tblGENRE(genreName, genreDescr)
VALUES (@GName, @GDescr)
COMMIT TRAN T1
GO