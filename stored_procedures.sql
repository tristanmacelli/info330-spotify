/*
 * 
 * Stored Produres compiled into one doc
 * 
 */
-- Insert into tblSONG_GROUP
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

INSERT INTO tblSONG_GROUP(songID, groupID)
VALUES(@SongID, @GroupID)
GO


-- Insert into tblGROUP_MEMBER
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

INSERT INTO tblGROUP_MEMBER(groupID, artistID, roleID)
VALUES(@GroupID, @ArtistID, @RoleID)
GO

-- Insert into tblEVENT
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
  SELECT recordingID
  FROM tblRECORDING R
    JOIN tblSONG_GROUP SG ON R.songGroupID = SG.songGroupID
    JOIN tblSONG S ON SG.songID = S.songID
    JOIN tblGROUP G ON SG.groupID = G.groupID
    JOIN tblRECORDING_ALBUM RA ON R.recordingID = RA.recordingID
    JOIN tblALBUM ON RA.albumID = A.albumID
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

-- Insert into tblCUSTOMER_DEVICE
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


-- Instert into tblCUSTOMER
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

-- Insert into tblCUSTOMER_PLAYLIST
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


-- Insert into tblPLAYLIST
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

-- Insert into tblDEVICE
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


-- Insert into tblRECORDING
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

-- Insert into tblRECORDING_ALBUM
CREATE PROCEDURE usp_INSERT_RECORDING_ALBUM
@AlbumName varchar (75),
@AlbumLabel varchar(75),
@AlbumRelease DATE,
@SongName varchar(75),
@RecordingGenre varchar(75)

AS 

DECLARE @recordingID INT
DECLARE @albumID INT

SET @recordingID = (SELECT R.recordingID 
					FROM tblRECORDING R
						JOIN tblSONG_GROUP SG ON R.songGroupID = SG.songGroupID
						JOIN tblSONG S ON SG.songID = S.songID
						JOIN tblGENRE G ON R.genreID = G.genreID
					WHERE S.songName = @SongName
					AND G.genreName = @RecordingGenre)

SET @albumID = (SELECT A.albumID 
				FROM tblALBUM A
				WHERE A.albumName = @AlbumName
				AND A.albumReleaseDate = @AlbumRelease
				AND A.albumLabel = @AlbumLabel)
				
BEGIN TRAN G1
INSERT INTO tblRECORDING_ALBUM(recordingID, albumID)
VALUES(@recordingID, @albumID)
COMMIT TRAN G1

/*
 * 
 * Additional stored procedures 
 * 
 */ 

-- Insert types into tblCUSTOMER_TYPE
-- Data entered
CREATE PROCEDURE usp_INSERT_tblCUSTOMER_TYPE
@CustTypeName varchar(75),
@CustTypeDescr varchar(500)

AS

INSERT INTO tblCUSTOMER_TYPE(custTypeName, custTypeDescr)
VALUES(@CustTypeName, @CustTypeDescr)
GO


-- Insert types into tblPLAYLIST_TYPE
-- Data entered
CREATE PROCEDURE usp_INSERT_tblPLAYLIST_TYPE
@PlaylistTypeName varchar(75)

AS

INSERT INTO tblPLAYLIST_TYPE(playlistTypeName)
VALUES(@PlaylistTypeName)
GO

-- Insert types into tblDEVICE_TYPE
-- Data entered
CREATE PROCEDURE usp_INSERT_tblDEVICE_TYPE
@DeviceTypeName varchar(75),
@DeviceTypeDescr varchar(500)

AS

INSERT INTO tblDEVICE_TYPE(deviceTypeName, deviceTypeDescr)
VALUES(@DeviceTypeName, @DeviceTypeDescr)
GO

-- Insert into tblSONG
-- Data entered
CREATE PROCEDURE usp_INSERT_tblSONG
@songName varchar(75)

AS

INSERT INTO tblSONG (songName)
VALUES (@songName)
GO


-- Insert into tblGROUP
-- Data entered
CREATE PROCEDURE usp_INSERT_tblGROUP
@groupName varchar(75),
@groupBio varchar(500),
@groupPic varchar(500)

AS

INSERT INTO tblGROUP (groupName, groupBio, groupPic)
VALUES (@groupName, @groupBio, @groupPic)
GO


-- Insert into tblALBUM
-- Data entered
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


-- Insert into tblRECORDING_RATING
-- Data entered 
CREATE PROCEDURE usp_INSERT_tblRECORDING_RATING
@Name varchar(75)

AS

BEGIN TRAN T1
INSERT INTO tblRECORDING_RATING(ratingName)
VALUES (@Name)
COMMIT TRAN T1
GO

