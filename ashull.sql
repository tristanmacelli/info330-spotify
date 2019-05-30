USE Group8_Spotify
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
