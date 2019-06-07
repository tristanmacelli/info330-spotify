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
GO

-- business rule - no users under age of 13
CREATE FUNCTION ck_noAccountUnder13()
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

-- complex query select the top 100 most listened to songs
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

-- computed column, get the total # of listening time for a group
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
