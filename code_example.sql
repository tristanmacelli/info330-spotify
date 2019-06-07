USE Group8_Spotify

EXEC usp_CREATE_CUSTOMER
@typeName = 'Free',
@fName = 'Robbie',
@lName = 'Lin',
@dob = '1997-09-28',
@address = '12345 67th AVE NE',
@city = 'Seattle',
@state = 'WA',
@zip = '98105',
@language = 'EN',
@pic = 'https://www.pic.com'



EXEC usp_INSERT_tblPLAYLIST_AND_tblCUSTOMER_PLAYLIST
@PlaylistName = 'Robbies Playlist',
@Descr = 'Cool music for a cool dude',
@PlaylistTypeName = 'Public',
@CustFName = 'Robbie',
@CustLName = 'Lin',
@DOB = '1997-09-28'


EXEC usp_INSERT_tblEVENT
@groupName = 'Justin Bieber',
@songName = 'Love Yourself',
@albumName = 'Purpose (Deluxe)',
@eventTypeName = 'addToPlaylist',
@playlistName = 'Robbies Playlist',
@custFName = 'Robbie',
@custLName = 'Lin',
@custDOB = '1997-09-28',
@eventDate = '2019-06-04'

-- computed columns --
SELECT * FROM tblALBUM

ALTER TABLE tblALBUM
ADD rating AS (dbo.fn_AlbumRating(albumID))

SELECT * FROM tblALBUM

ALTER TABLE tblALBUM
ADD genre AS (dbo.fn_ComputeAlbumGenre(albumID))

SELECT * FROM tblALBUM

--ALTER TABLE tblALBUM DROP COLUMN rating
--ALTER TABLE tblALBUM DROP COLUMN genre

-- Restriction/Business Rule --
-- Must be >=18 to listen to explicit song/album --
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

--- SELECT dbo.fn_noExplicitUnder18 ()

ALTER TABLE tblCUSTOMER 
ADD CONSTRAINT ck_noExplicitUnder18
CHECK (dbo.fn_noExplicitUnder18() = 0)
GO


-- Testing --
-- Restriction/Business Rule --
-- Must be 13 or older to have an account --
CREATE FUNCTION fn_noAccountUnder13 ()
RETURNS INT
AS
BEGIN

  DECLARE @Ret INT = 0

  IF EXISTS (
    SELECT C.custDOB
    FROM tblCUSTOMER C
    WHERE C.custDOB >= (SELECT GETDATE() - (365.25 * 13))
  ) BEGIN
    SET @Ret = 1
  END

RETURN @Ret
END
GO

ALTER TABLE tblCUSTOMER 
ADD CONSTRAINT ck_noAccountUnder13
CHECK (dbo.fn_noAccountUnder13 () = 0)

-- Example of baby
EXEC usp_CREATE_CUSTOMER
@typeName  = 'Free',
@fName = 'Baby',
@lName = 'McBaby',
@dob = '2019-06-05',
@address = 'Baby land',
@city = 'Smol baby',
@state = 'Ba',
@zip = '1234',
@language = 'EN',
@pic = 'picOfBaby.com'

-- Query --
/*
 * addToPlaylist234
	Find all premium customers who are at least 18 years old, and have 'Love Yourself' in a playlist
*/
SELECT C.custID, C.custFName, C.custLName
<<<<<<< HEAD
FROM tblCUSTOMER C
	JOIN tblCUSTOMER_TYPE CT ON C.custTypeID = CT.custTypeID
	JOIN tblEVENT E ON C.custID = E.custID
	JOIN tblEVENT_TYPE ET ON E.eventTypeID = ET.eventTypeID
WHERE CT.custTypeName = 'Premium'
	AND ET.eventTypeName = 'register'
	AND E.eventDate BETWEEN 'January 1, 2010' AND 'December 31, 2019'
	AND C.custDOB <= (SELECT GETDATE() - (365.25 * 18))	
GROUP BY C.custID, C.custFName, C.custLName
GO

select * from tblEVENT
=======
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
>>>>>>> 6618f939e2931e23112f583718a7ba23829e52e0
