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


EXEC usp_INSERT_tblPLAYLIST_BY_CUST
@Name = '',
@Descr = '',
@PlaylistTypeName = 'Private',
@CustFName = '',
@CustLName = ''
@DOB = '1997-09-28'

EXEC usp_INSERT_tblEVENT
@groupName = 'Justin Bieber',
@songName = 'Love Yourself'),
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

-- restriction --


-- query --
