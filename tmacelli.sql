USE Group8_Spotify
GO

/*
	Transaction Table Stored Procedures (tblPLAYLIST & tblDEVICE)
*/

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

/*
	Lookup Table Stored Procedures (tblALBUM & tblRECORDING_RATING)
*/

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


/*
	Business Rule
	Description: Can’t add the same recording to a playlist more than once
*/

CREATE FUNCTION ck_NoPlaylistDuplicates()
RETURNS INT
AS
BEGIN
DECLARE @Ret INT = 0
		IF EXISTS(SELECT *
			  FROM tblPLAYLIST P
			  	JOIN tblCUSTOMER_PLAYLIST CP ON P.playlistID = CP.playlistID
				JOIN tblCUSTOMER C ON CP.custID = C.custID
				JOIN tblEVENT E ON C.custID = E.custID
				JOIN tblEVENT_TYPE ET ON E.eventTypeID = ET.eventTypeID
				JOIN tblRECORDING R ON E.recordingID = R.recordingID
			  WHERE (SELECT SUBSTRING(ET.eventTypeName, 14 , LEN(ET.eventTypeName))) IN (SELECT P.playListID FROM tblPLAYLIST P)
			  GROUP BY P.playlistID				  
		)
		BEGIN
			SET @Ret = 1
		END
	RETURN @Ret
END
GO

/*
	Computed Column: Album Rating
	Uses the ratings from each of the recordings in the album to determine the overall rating of the album
*/

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

/*
	Find all premium customers who registered between 2010 and 2014, who are also at least 18 years old 
*/
SELECT C.custID, C.custFName, C.custLName
FROM tblCUSTOMER C
	JOIN tblCUSTOMER_TYPE CT ON C.custTypeID = CT.custTypeID
	JOIN tblEVENT E ON C.custID = E.custID
	JOIN tblEVENT_TYPE ET ON E.eventTypeID = ET.eventTypeID
WHERE CT.custTypeName = 'Premium'
	AND ET.eventTypeName = 'register'
	AND E.eventDate BETWEEN 'January 1, 2010' AND 'December 31, 2014'
	AND C.custDOB <= (SELECT GetDate()) - 18	
GROUP BY C.custID, C.custFName, C.custLName

EXECUTE usp_INSERT_tblRECORDING_RATING
@Name = 'Explicit'

EXECUTE usp_INSERT_tblRECORDING_RATING
@Name = 'Clean'

GO