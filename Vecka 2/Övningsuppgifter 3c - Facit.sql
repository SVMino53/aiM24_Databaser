/*

Av alla audiospår, vilken artist har längst total speltid?

*/

select * from music.media_types
select * from music.tracks

SELECT 
    *
FROM 
    music.artists AS ar
JOIN 
    music.albums AS al ON al.ArtistId = ar.ArtistId
JOIN
    music.tracks AS tr ON tr.AlbumId = al.AlbumId
JOIN 
	music.media_types as me ON tr.MediaTypeId = me.MediaTypeId




SELECT
    ar.name AS Artist,
    SUM(tr.MilliSeconds) AS "TotalTime(milliseconds)",
    SUM(tr.MilliSeconds)/1000 AS "TotalTime(Seconds)"
FROM 
    music.artists AS ar
JOIN 
    music.albums AS al ON al.ArtistId = ar.ArtistId
JOIN
    music.tracks AS tr ON tr.AlbumId = al.AlbumId
JOIN 
	music.media_types as me ON tr.MediaTypeId = me.MediaTypeId
WHERE
	me.Name NOT LIKE '%video%'
GROUP BY
    ar.name



SELECT TOP 1
    ar.name AS Artist,
    SUM(tr.MilliSeconds) AS "TotalTime(milliseconds)",
    SUM(tr.MilliSeconds)/1000 AS "TotalTime(Seconds)"
FROM 
    music.artists AS ar
JOIN 
    music.albums AS al ON al.ArtistId = ar.ArtistId
JOIN
    music.tracks AS tr ON tr.AlbumId = al.AlbumId
JOIN 
	music.media_types as me ON tr.MediaTypeId = me.MediaTypeId
WHERE
	me.Name NOT LIKE '%video%'
GROUP BY
    ar.name
ORDER BY "TotalTime(milliseconds)" DESC

/*

Vad är den genomsnittliga speltiden på den artistens låtar?

*/

SELECT
    AVG(tr.Milliseconds) as [AveragePlaytime(milliseconds)]
FROM 
    music.artists AS ar
JOIN 
    music.albums AS al ON al.ArtistId = ar.ArtistId
JOIN
    music.tracks AS tr ON tr.AlbumId = al.AlbumId
JOIN 
	music.media_types as me ON tr.MediaTypeId = me.MediaTypeId
WHERE
	ar.Name LIKE 'Iron Maiden'

/*

Vad är den sammanlagda filstorleken för all video?

*/

SELECT 
	SUM(CAST(tr.Bytes as BIGINT)) AS [TotalSize(bytes)]
FROM 
    music.artists AS ar
JOIN 
    music.albums AS al ON al.ArtistId = ar.ArtistId
JOIN
    music.tracks AS tr ON tr.AlbumId = al.AlbumId
JOIN 
	music.media_types as me ON tr.MediaTypeId = me.MediaTypeId
WHERE
	me.Name LIKE '%video%'


/*

Vilket är det högsta antal artister som finns på en enskild spellista?

*/

SELECT
  *
FROM
  music.playlists AS playlists
JOIN
  music.playlist_track AS playlist_track ON playlists.PlaylistId = playlist_track.PlaylistId
JOIN
  music.tracks AS tracks ON playlist_track.TrackId = tracks.TrackId
JOIN
  music.albums AS albums ON tracks.AlbumId = albums.AlbumId
JOIN
  music.artists AS artists ON albums.ArtistId = artists.ArtistId





SELECT TOP 1
  playlists.Name AS Spellista,
  COUNT(DISTINCT artists.ArtistId) AS [Antal artister]
FROM
  music.playlists AS playlists
JOIN
  music.playlist_track AS playlist_track ON playlists.PlaylistId = playlist_track.PlaylistId
JOIN
  music.tracks AS tracks ON playlist_track.TrackId = tracks.TrackId
JOIN
  music.albums AS albums ON tracks.AlbumId = albums.AlbumId
JOIN
  music.artists AS artists ON albums.ArtistId = artists.ArtistId
GROUP BY
  playlists.Name
ORDER BY
  [Antal artister] DESC;


/*

Vilket är det genomsnittliga antalet artister per spellista?

*/

SELECT
  playlists.Name AS Spellista,
  COUNT(DISTINCT artists.ArtistId) AS [Antal artister]
FROM
  music.playlists AS playlists
JOIN
  music.playlist_track AS playlist_track ON playlists.PlaylistId = playlist_track.PlaylistId
JOIN
  music.tracks AS tracks ON playlist_track.TrackId = tracks.TrackId
JOIN
  music.albums AS albums ON tracks.AlbumId = albums.AlbumId
JOIN
  music.artists AS artists ON albums.ArtistId = artists.ArtistId
GROUP BY
  playlists.Name
ORDER BY
  [Antal artister] DESC;


with temptabell as 

(
SELECT
  playlists.Name AS Spellista,
  COUNT(DISTINCT artists.ArtistId) AS [Antal artister]
FROM
  music.playlists AS playlists
JOIN
  music.playlist_track AS playlist_track ON playlists.PlaylistId = playlist_track.PlaylistId
JOIN
  music.tracks AS tracks ON playlist_track.TrackId = tracks.TrackId
JOIN
  music.albums AS albums ON tracks.AlbumId = albums.AlbumId
JOIN
  music.artists AS artists ON albums.ArtistId = artists.ArtistId
GROUP BY
  playlists.Name
)

select * from temptabell


GO


with temptabell as 

(
SELECT
  playlists.Name AS Spellista,
  COUNT(DISTINCT artists.ArtistId) AS [Antal artister]
FROM
  music.playlists AS playlists
JOIN
  music.playlist_track AS playlist_track ON playlists.PlaylistId = playlist_track.PlaylistId
JOIN
  music.tracks AS tracks ON playlist_track.TrackId = tracks.TrackId
JOIN
  music.albums AS albums ON tracks.AlbumId = albums.AlbumId
JOIN
  music.artists AS artists ON albums.ArtistId = artists.ArtistId
GROUP BY
  playlists.Name
)

select 
	avg([Antal artister]) as [Average artists per playlist]
from 
	temptabell