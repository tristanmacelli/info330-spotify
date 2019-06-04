USE Group8_Spotify

SELECT * FROM tblCUSTOMER_PLAYLIST

GO
-- Transaction table stored procedure tblCustomer
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

-- Transaction table stored procedure tblCUSTOMER_PLAYLIST
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



