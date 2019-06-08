USE Group8_Spotify
SELECT * FROM tblDEVICE_TYPE

-- Can only add to your own playlist (if it's private) 
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


-- Find genre of most songs
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

-- Find user’s favorite playlist (playlist with the most liked songs in them, the user must have liked the song)
-- Takes in customer id and returns favorite playlist name
CREATE FUNCTION fn_FavoritePlaylist(@PK INT)
RETURNS VARCHAR(75)
AS
BEGIN
	DECLARE @Ret VARCHAR(75) = (
		SELECT playlistName FROM (
			SELECT TOP 1 P.playlistID, P.playlistName, COUNT(*) as Count
			FROM tblPLAYLIST P
				JOIN tblCUSTOMER_PLAYLIST CP ON P.playlistID = CP.playlistID
				JOIN tblCUSTOMER C ON CP.custID = C.custID
				JOIN tblEVENT E ON C.custID = E.custID
				JOIN tblEVENT_TYPE ET ON E.eventTypeID = ET.eventTypeID
			WHERE ET.eventTypeName = 'like' AND C.custID = @PK
			GROUP BY P.playlistID, P.PlaylistName
			ORDER BY Count DESC
		) as sbq
	)
	RETURN @Ret
END
GO

ALTER TABLE tblCUSTOMER
ADD favoritePlaylist AS (dbo.fn_FavoritePlaylist(custID))

-- Query --
-- Find all songs in a playlist that have over 50 songs
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






-- THESE ARE ADDITIONAL STORED PROCEDURES BUT AREN'T OUR MAIN ONES --

-- Insert types into tblCUSTOMER_TYPE
CREATE PROCEDURE usp_INSERT_tblCUSTOMER_TYPE
@CustTypeName varchar(75),
@CustTypeDescr varchar(500)

AS

INSERT INTO tblCUSTOMER_TYPE(custTypeName, custTypeDescr)
VALUES(@CustTypeName, @CustTypeDescr)
GO


-- Insert types into tblPLAYLIST_TYPE
CREATE PROCEDURE usp_INSERT_tblPLAYLIST_TYPE
@PlaylistTypeName varchar(75)

AS

INSERT INTO tblPLAYLIST_TYPE(playlistTypeName)
VALUES(@PlaylistTypeName)
GO

-- Insert types into tblDEVICE_TYPE
CREATE PROCEDURE usp_INSERT_tblDEVICE_TYPE
@DeviceTypeName varchar(75),
@DeviceTypeDescr varchar(500)

AS

INSERT INTO tblDEVICE_TYPE(deviceTypeName, deviceTypeDescr)
VALUES(@DeviceTypeName, @DeviceTypeDescr)
GO

-- Inserting data into tblCUSTOMER_TYPE 
EXECUTE usp_INSERT_tblCUSTOMER_TYPE
@CustTypeName = 'Premium',
@CustTypeDescr = 'Paid membership for Spotify services'
GO

EXECUTE usp_INSERT_tblCUSTOMER_TYPE
@CustTypeName = 'Free',
@CustTypeDescr = 'Free membership for Spotify services, includes ads'
GO

-- Inserting data into tblPLAYLIST_TYPE
EXECUTE usp_INSERT_tblPLAYLIST_TYPE
@PlaylistTypeName = 'Private'

EXECUTE usp_INSERT_tblPLAYLIST_TYPE
@PlaylistTypeName = 'Public'

-- Inserting data into tblDEVICE_TYPE
EXECUTE usp_INSERT_tblDEVICE_TYPE
@DeviceTypeName = 'Computer',
@DeviceTypeDescr = 'Laptop or desktop'

EXECUTE usp_INSERT_tblDEVICE_TYPE
@DeviceTypeName = 'Cell Phone',
@DeviceTypeDescr = 'Wireless phone'

EXECUTE usp_INSERT_tblDEVICE_TYPE
@DeviceTypeName = 'Tablet',
@DeviceTypeDescr = 'Handheld computer that without service'

EXECUTE usp_INSERT_tblDEVICE_TYPE
@DeviceTypeName = 'Smart Watch',
@DeviceTypeDescr = 'Small computer worn on wrist'
