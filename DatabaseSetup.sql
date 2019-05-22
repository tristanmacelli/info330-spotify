CREATE DATABASE Group6_Spotify
USE Group6_Spotify

-- I haven't run this code yet, please don't run this code yet --
CREATE TABLE [tblDEVICE_TYPE] (
  [deviceTypeID] INT,
  [deviceTypeName] varchar(50),
  [deviceTypeDescr] varchar(250)
);

CREATE INDEX [pk] ON  [tblDEVICE_TYPE] ([deviceTypeID]);

CREATE TABLE [tblRECORDING] (
  [recordingID] INT,
  [songID] INT,
  [genreID] INT,
  [recordingLength] numeric(100, 2)
);

CREATE INDEX [pk] ON  [tblRECORDING] ([recordingID]);

CREATE INDEX [fk] ON  [tblRECORDING] ([songID], [genreID]);

CREATE TABLE [tblARTIST] (
  [artistID] INT,
  [artistFName] varchar(50),
  [artistLName] varchar(50),
  [artistBio] varchar(500),
  [artistPic] varchar(100)
);

CREATE INDEX [pk] ON  [tblARTIST] ([artistID]);

CREATE TABLE [tblCUSTOMER_DEVICE] (
  [custDeviceID] INT,
  [custID] INT,
  [deviceID] INT
);

CREATE INDEX [pk] ON  [tblCUSTOMER_DEVICE] ([custDeviceID]);

CREATE INDEX [fk] ON  [tblCUSTOMER_DEVICE] ([custID], [deviceID]);

CREATE TABLE [tblCUSTOMER] (
  [custID] INT,
  [custTypeID] INT,
  [custFName] varchar(50),
  [custLName] varchar(50),
  [custDOB] Date,
  [custAddress] varchar(75),
  [custState] varchar(5),
  [custZip] varchar(50),
  [custLanguage] varchar(50),
  [custPic] varchar(100)
);

CREATE INDEX [pk] ON  [tblCUSTOMER] ([custID]);

CREATE INDEX [fk] ON  [tblCUSTOMER] ([custTypeID]);

CREATE TABLE [tblCUSTOMER_TYPE] (
  [custTypeID] INT,
  [custTypeName] varchar(50),
  [custTypeDecr] varchar(250)
);

CREATE INDEX [pk] ON  [tblCUSTOMER_TYPE] ([custTypeID]);

CREATE TABLE [tblDEVICE] (
  [deviceID] INT,
  [deviceTypeID] INT,
  [deviceName] varchar(50)
);

CREATE INDEX [pk] ON  [tblDEVICE] ([deviceID]);

CREATE INDEX [fk] ON  [tblDEVICE] ([deviceTypeID]);

CREATE TABLE [tblROLE] (
  [roleID] INT,
  [roleName] varchar(50),
  [roleDescr] varchar(250)
);

CREATE INDEX [pk] ON  [tblROLE] ([roleID]);

CREATE TABLE [tblSONG_ARTIST_ROLE] (
  [songArtistRoleID] INT,
  [artistID] INT,
  [roleID] INT,
  [songID] INT
);

CREATE INDEX [pk] ON  [tblSONG_ARTIST_ROLE] ([songArtistRoleID]);

CREATE INDEX [fk] ON  [tblSONG_ARTIST_ROLE] ([artistID], [roleID], [songID]);

CREATE TABLE [tblALBUM] (
  [albumID] INT,
  [albumName] varchar(50),
  [albumPic] varchar(100),
  [albumDescr] varchar(250)
);

CREATE INDEX [pk] ON  [tblALBUM] ([albumID]);

CREATE TABLE [tblEVENT] (
  [eventID] INT,
  [custID] INT,
  [recordingID] INT,
  [eventTypeID] INT,
  [eventDate] Date
);

CREATE INDEX [pk] ON  [tblEVENT] ([eventID]);

CREATE INDEX [fk] ON  [tblEVENT] ([custID], [recordingID], [eventTypeID]);

CREATE TABLE [tblRECORDING_ALBUM] (
  [recordingAlbumID] INT,
  [recordingID] INT,
  [albumID] INT
);

CREATE INDEX [pk] ON  [tblRECORDING_ALBUM] ([recordingAlbumID]);

CREATE INDEX [fk] ON  [tblRECORDING_ALBUM] ([recordingID], [albumID]);

CREATE TABLE [tblEVENT_TYPE] (
  [eventTypeID] INT,
  [eventTypeName] varchar(50),
  [eventTypeDecr] varchar(250)
);

CREATE INDEX [pk] ON  [tblEVENT_TYPE] ([eventTypeID]);

CREATE TABLE [tblGENRE] (
  [genreID] INT,
  [genreName] varchar(50),
  [genreDescr] varchar(250)
);

CREATE INDEX [pk] ON  [tblGENRE] ([genreID]);

CREATE TABLE [tblSONG] (
  [songID] INT,
  [songName] varchar(50)
);

CREATE INDEX [pk] ON  [tblSONG] ([songID]);

