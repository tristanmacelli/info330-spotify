--CREATE DATABASE Group8_Spotify
USE Group8_Spotify

-- I haven't run this code yet, please don't run this code yet --
/*
CREATE TABLE [tblDEVICE_TYPE] (
	[deviceTypeID] INTEGER IDENTITY(1,1) primary key,
	[deviceTypeName] varchar(75) not null,
	[deviceTypeDescr] varchar(500) NULL
);

CREATE TABLE [tblSONG] (
	[songID] INTEGER IDENTITY(1,1) primary key,
	[songName] varchar(75) not null
);

CREATE TABLE [tblGENRE] (
	[genreID] INTEGER IDENTITY(1,1) primary key,
	[genreName] varchar(75) not null,
	[genreDescr] varchar(500) NULL
);

CREATE TABLE [tblEVENT_TYPE] (
	[eventTypeID] INTEGER IDENTITY(1,1) primary key,
	[eventTypeName] varchar(75) not null,
	[eventTypeDescr] varchar(500) NULL
);

CREATE TABLE [tblARTIST] (
	[artistID] INTEGER IDENTITY(1,1) primary key,
	[artistFName] varchar(75) not null,
	[artistLName] varchar(75) not null,
	[artistBio] varchar(500) not null,
	[artistPic] varchar(500) not null
);

CREATE TABLE [tblGROUP] (
	[groupID] INTEGER IDENTITY(1,1) primary key,
	[groupName] varchar(75) not null,
	[groupBio] varchar(500) not null,
	[groupPic] varchar(500) not null
);

CREATE TABLE [tblCUSTOMER_TYPE] (
	[custTypeID] INTEGER IDENTITY(1,1) primary key,
	[custTypeName] varchar(75) not null,
	[custTypeDescr] varchar(500) NULL
);

CREATE TABLE [tblROLE] (
	[roleID] INTEGER IDENTITY(1,1) primary key,
	[roleName] varchar(75) not null,
	[roleDescr] varchar(500) NULL
);

CREATE TABLE [tblRECORDING_RATING] (
	[recordingRatingID] INTEGER IDENTITY(1,1) primary key,
	[ratingName] varchar(75) not null
);

CREATE TABLE [tblALBUM] (
	[albumID] INTEGER IDENTITY(1,1) primary key,
	[albumName] varchar(75) not null,
	[albumPic] varchar(500) not null,
	[albumDescr] varchar(500) NULL,
	[albumLabel] varchar(75) NULL,
	[albumReleaseDate] Date not null
);

CREATE TABLE [tblPLAYLIST_TYPE] (
	[playlistTypeID] INTEGER IDENTITY(1,1) primary key,
	[playlistTypeName] varchar(75) not null
);

CREATE TABLE [tblSONG_GROUP] (
	[songGroupID] INTEGER IDENTITY(1,1) primary key,
	[songID] INT FOREIGN KEY REFERENCES tblSONG (songID) not null,
	[groupID] INT FOREIGN KEY REFERENCES tblGROUP (groupID) not null
);

CREATE TABLE [tblRECORDING] (
	[recordingID] INTEGER IDENTITY(1,1) primary key,
	[songGroupID] INT FOREIGN KEY REFERENCES tblSONG_GROUP (songGroupID) not null,
	[genreID] INT FOREIGN KEY REFERENCES tblGENRE (genreID) not null,
	[recordingRatingID] INT FOREIGN KEY REFERENCES tblRECORDING_RATING (recordingRatingID) not null,
	[recordingLength] Time not null
);

CREATE TABLE [tblCUSTOMER] (
	[custID] INTEGER IDENTITY(1,1) primary key,
	[custTypeID] INT FOREIGN KEY REFERENCES tblCUSTOMER_TYPE (custTypeID) not null,
	[custFName] varchar(75) not null,
	[custLName] varchar(75) not null,
	[custDOB] Date not null,
	[custAddress] varchar(100) not null,
	[custState] varchar(2) not null,
	[custZip] varchar(75) not null,
	[custLanguage] varchar(2) not null,
	[custPic] varchar(500) NULL
);


CREATE TABLE [tblDEVICE] (
	[deviceID] INTEGER IDENTITY(1,1) primary key,
	[deviceTypeID]  INT FOREIGN KEY REFERENCES tblDEVICE_TYPE (deviceTypeID) not null,
	[deviceName] varchar(75) not null
);


CREATE TABLE [tblCUSTOMER_DEVICE] (
	[custDeviceID] INTEGER IDENTITY(1,1) primary key,
	[custID] INT FOREIGN KEY REFERENCES tblCUSTOMER (custID) not null,
	[deviceID] INT FOREIGN KEY REFERENCES tblDEVICE (deviceID) not null
);

CREATE TABLE [tblRECORDING_ALBUM] (
	[recordingAlbumID] INTEGER IDENTITY(1,1) primary key,
	[recordingID] INT FOREIGN KEY REFERENCES tblRECORDING (recordingID) not null,
	[albumID] INT FOREIGN KEY REFERENCES tblALBUM (albumID) not null
);

CREATE TABLE [tblGROUP_MEMBER] (
	[groupMemberID] INTEGER IDENTITY(1,1) primary key,
	[groupID] INT FOREIGN KEY REFERENCES tblGROUP (groupID) not null,
	[artistID] INT FOREIGN KEY REFERENCES tblARTIST (artistID) not null,
	[roleID] INT FOREIGN KEY REFERENCES tblROLE (roleID) not null,
);

CREATE TABLE [tblPLAYLIST] (
	[playlistID] INTEGER IDENTITY(1,1) primary key,
	[playlistTypeID] INT FOREIGN KEY REFERENCES tblPLAYLIST_TYPE (playlistTypeID) not null,
	[playlistName] varchar(75) not null,
	[playlistDescr] varchar(500) NULL
);

CREATE TABLE [tblCUSTOMER_PLAYLIST] (
	[customerPlaylistID] INTEGER IDENTITY(1,1) primary key,
	[custID] INT FOREIGN KEY REFERENCES tblCUSTOMER (custID) not null,
	[playlistID] INT FOREIGN KEY REFERENCES tblPLAYLIST (playlistID) not null,
);

CREATE TABLE [tblEVENT] (
	[eventID] INTEGER IDENTITY(1,1) primary key,
	[recordingID] INT FOREIGN KEY REFERENCES tblRECORDING (recordingID) not null,
	[eventTypeID] INT FOREIGN KEY REFERENCES tblEVENT_TYPE (eventTypeID) not null,
	[custID] INT FOREIGN KEY REFERENCES tblCUSTOMER (custID) not null,
	[eventDate] DATE not null
);*/
