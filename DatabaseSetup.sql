CREATE DATABASE Group8_Spotify
USE Group8_Spotify

-- I haven't run this code yet, please don't run this code yet --
CREATE TABLE [tblDEVICE_TYPE] (
  [deviceTypeID] <type>,
  [deviceTypeName] <type>,
  [deviceTypeDescr] <type>
);

CREATE INDEX [pk] ON  [tblDEVICE_TYPE] ([deviceTypeID]);

CREATE TABLE [tblRECORDING] (
	  [recordingID] <type>,
	  [songGroupID] <type>,
	  [genreID] <type>,
	  [recordingRatingID] <type>,
	  [recordingLength] <type>
);

CREATE INDEX [pk] ON  [tblRECORDING] ([recordingID]);

CREATE INDEX [fk] ON  [tblRECORDING] ([songGroupID], [genreID], [recordingRatingID]);

CREATE TABLE [tblARTIST] (
	  [artistID] <type>,
	  [artistFName] <type>,
	  [artistLName] <type>,
	  [artistBio] <type>,
	  [artistPic] <type>
);

CREATE INDEX [pk] ON  [tblARTIST] ([artistID]);

CREATE TABLE [tblCUSTOMER_DEVICE] (
	  [custDeviceID] <type>,
	  [custID] <type>,
	  [deviceID] <type>
);

CREATE INDEX [pk] ON  [tblCUSTOMER_DEVICE] ([custDeviceID]);

CREATE INDEX [fk] ON  [tblCUSTOMER_DEVICE] ([custID], [deviceID]);

CREATE TABLE [tblCUSTOMER] (
	  [custID] <type>,
	  [custTypeID] <type>,
	  [custFName] <type>,
	  [custLName] <type>,
	  [custDOB] <type>,
	  [custAddress] <type>,
	  [custState] <type>,
	  [custZip] <type>,
	  [custLanguage] <type>,
	  [custPic] <type>
);

CREATE INDEX [pk] ON  [tblCUSTOMER] ([custID]);

CREATE INDEX [fk] ON  [tblCUSTOMER] ([custTypeID]);

CREATE TABLE [tbl_GROUP] (
	  [groupID] <type>,
	  [groupName] <type>,
	  [groupBio] <type>,
	  [groupPic] <type>
);

CREATE INDEX [pk] ON  [tbl_GROUP] ([groupID]);

CREATE TABLE [tblCUSTOMER_TYPE] (
	  [custTypeID] <type>,
	  [custTypeName] <type>,
	  [custTypeDescr] <type>
);

CREATE INDEX [pk] ON  [tblCUSTOMER_TYPE] ([custTypeID]);

CREATE TABLE [tblDEVICE] (
	  [deviceID] <type>,
	  [deviceTypeID] <type>,
	  [deviceName] <type>
);

CREATE INDEX [pk] ON  [tblDEVICE] ([deviceID]);

CREATE INDEX [fk] ON  [tblDEVICE] ([deviceTypeID]);

CREATE TABLE [tblROLE] (
	  [roleID] <type>,
	  [roleName] <type>,
	  [roleDescr] <type>
);

CREATE INDEX [pk] ON  [tblROLE] ([roleID]);

CREATE TABLE [tblGROUP_MEMBER] (
	  [groupMemberID] <type>,
	  [groupID] <type>,
	  [artistID] <type>,
	  [roleID] <type>
);

CREATE INDEX [pk] ON  [tblGROUP_MEMBER] ([groupMemberID]);

CREATE INDEX [fk] ON  [tblGROUP_MEMBER] ([groupID], [artistID], [roleID]);

CREATE TABLE [tblRECORDING_RATING] (
	  [recordingRatingID] <type>,
	  [ratingName] <type>
);

CREATE INDEX [pk] ON  [tblRECORDING_RATING] ([recordingRatingID]);

CREATE TABLE [tblALBUM] (
	  [albumID] <type>,
	  [albumName] <type>,
	  [albumPic] <type>,
	  [albumDescr] <type>,
	  [albumLabel] <type>,
	  [albumReleaseDate] <type>
);

CREATE INDEX [pk] ON  [tblALBUM] ([albumID]);

CREATE TABLE [tblPLAYLIST] (
	  [playlistID] <type>,
	  [playlistTypeID] <type>,
	  [playlistName] <type>,
	  [playlistDescr] <type>
);

CREATE INDEX [pk] ON  [tblPLAYLIST] ([playlistID]);

CREATE INDEX [fk] ON  [tblPLAYLIST] ([playlistTypeID]);

CREATE TABLE [tblPLAYLIST_TYPE] (
	  [playlistTypeID] <type>,
	  [playlistTypeName] <type>
);

CREATE INDEX [pk] ON  [tblPLAYLIST_TYPE] ([playlistTypeID]);

CREATE TABLE [tblCUSTOMER_PLAYLIST] (
	  [customerPlaylistID] <type>,
	  [custID] <type>,
	  [playlistID] <type>
);

CREATE INDEX [pk] ON  [tblCUSTOMER_PLAYLIST] ([customerPlaylistID]);

CREATE INDEX [fk] ON  [tblCUSTOMER_PLAYLIST] ([custID], [playlistID]);

CREATE TABLE [tblEVENT] (
	  [eventID] <type>,
	  [recordingID] <type>,
	  [eventTypeID] <type>,
	  [custID] <type>,
	  [eventDate] <type>
);

CREATE INDEX [pk] ON  [tblEVENT] ([eventID]);

CREATE INDEX [fk] ON  [tblEVENT] ([recordingID], [eventTypeID], [custID]);

CREATE TABLE [tblRECORDING_ALBUM] (
	  [recordingAlbumID] <type>,
	  [recordingID] <type>,
	  [albumID] <type>
);

CREATE INDEX [pk] ON  [tblRECORDING_ALBUM] ([recordingAlbumID]);

CREATE INDEX [fk] ON  [tblRECORDING_ALBUM] ([recordingID], [albumID]);

CREATE TABLE [tblSONG_GROUP] (
	  [songGroupID] <type>,
	  [songID] <type>,
	  [groupID] <type>
);

CREATE INDEX [pk] ON  [tblSONG_GROUP] ([songGroupID]);

CREATE INDEX [fk] ON  [tblSONG_GROUP] ([songID], [groupID]);

CREATE TABLE [tblEVENT_TYPE] (
	  [eventTypeID] <type>,
	  [eventTypeName] <type>,
	  [eventTypeDescr] <type>
);

CREATE INDEX [pk] ON  [tblEVENT_TYPE] ([eventTypeID]);

CREATE TABLE [tblGENRE] (
	  [genreID] <type>,
	  [genreName] <type>,
	  [genreDescr] <type>
);

CREATE INDEX [pk] ON  [tblGENRE] ([genreID]);

CREATE TABLE [tblSONG] (
	  [songID] <type>,
	  [songName] <type>
);

CREATE INDEX [pk] ON  [tblSONG] ([songID]);
