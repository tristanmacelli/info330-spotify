USE Group8_Spotify

EXEC usp_CREATE_CUSTOMER
@typeName = 'Free',
@fName = '',
@lName = '',
@dob = '1997-09-28',
@address = '12345 67th AVE NE',
@city = 'Seattle',
@state = 'WA',
@zip = '98105',
@language = 'EN',
@pic = 'https://www.pic.com'


EXEC usp_INSERT_tblPLAYLIST_AND_tblCUSTOMER_PLAYLIST
@PlaylistName = '',
@Descr = '',
@PlaylistTypeName = 'Public',
@CustFName = '',
@CustLName = '',
@DOB = '1997-09-28'


EXEC usp_INSERT_tblEVENT
@groupName = 'Justin Bieber',
@songName = 'Love Yourself',
@albumName = 'Purpose (Deluxe)',
@eventTypeName = 'addToPlaylist',
@playlistName = '',
@custFName = '',
@custLName = '',
@custDOB = '',
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

ALTER TABLE tblCUSTOMER -- Won't Alter
ADD CONSTRAINT ck_noExplicitUnder18
CHECK (dbo.fn_noExplicitUnder18 = 0)
GO


-- Query --
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
GO


