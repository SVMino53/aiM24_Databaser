/*

Använd dig av tabellerna från schema “music”, och utgå från:
declare @playlist varchar(max) = 'Heavy Metal Classic’;
Skriv sedan en select-sats som tar ut alla låtar från den lista som
angivits i @playlist efter följande exempel:
…
Resten av låtarna i listan
Genre Artist Album Track Length Size Composer
Heavy Metal Iron Maiden Killers Killers 05:00 6.9 MiB Steve Harris
Heavy Metal Iron Maiden Killers Wrathchild 02:54 4.0 Mib Steve Harris
Metal Black Sabbath Blach Sabbath N.I.B 06:08 

*/

SELECT 
	*
  FROM [music].[tracks] AS t
  JOIN [music].[albums] AS al
    ON t.albumid = al.albumid
  JOIN [music].[artists] AS ar
    ON al.artistid = ar.artistid
  JOIN [music].[genres] AS g
    ON t.genreid = g.genreid
  JOIN [music].[playlist_track] AS pt
    ON t.trackid = pt.trackid
  JOIN [music].[playlists] AS p
    ON pt.playlistid = p.playlistid


select 10 % 4

DECLARE @playlist nvarchar(max) = 'Heavy Metal Classic'

SELECT 
	g.Name AS Genre, 
	ar.Name AS Artist, 
	al.Title AS Album, 
	t.Name AS Track,
	ISNULL(t.composer, '-') AS Composer,
	CAST(ROUND(CAST(t.Bytes AS float) / 1048576, 1) AS nvarchar) + ' MiB' AS Size,
--	CAST(t.Milliseconds / 60000 AS VARCHAR),
--	RIGHT('0' + CAST(t.Milliseconds / 60000 AS VARCHAR), 2),
	RIGHT('0' + CAST(t.Milliseconds / 60000 AS VARCHAR), 2) + ':' + 
    RIGHT('0' + CAST((t.Milliseconds % 60000) / 1000 AS VARCHAR), 2) AS Length
  FROM [music].[tracks] AS t
  JOIN [music].[albums] AS al
    ON t.albumid = al.albumid
  JOIN [music].[artists] AS ar
    ON al.artistid = ar.artistid
  JOIN [music].[genres] AS g
    ON t.genreid = g.genreid
  JOIN [music].[playlist_track] AS pt
    ON t.trackid = pt.trackid
  JOIN [music].[playlists] AS p
    ON pt.playlistid = p.playlistid
WHERE
	p.Name = @playlist



