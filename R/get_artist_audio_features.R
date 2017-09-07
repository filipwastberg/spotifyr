#' Get features and popularity for an artist's entire discography on Spotify
#'
#' This function returns the popularity and audio features for every song and album for a given artist on Spotify
#' @param artist_name String of artist name
#' @param access_token Spotify Web API token. Defaults to spotifyr::get_spotify_access_token()
#' @keywords track audio features discography
#' @export
#' @examples
#' radiohead_features <- get_artist_audio_features('radiohead')

get_artist_audio_features <- function(artist_name, access_token = get_spotify_access_token()) {
  
  ### grabs first result using spotifyr::get_artists()
  artist <- get_artists(artist_name) %>% 
    slice(1) %>% 
    select(artist_uri) %>% 
    .[[1]]
  
  albums <- get_albums(artist) %>% select(-c(base_album_name, base_album, num_albums, num_base_albums, album_rank))
  album_popularity <- get_album_popularity(albums)
  tracks <- get_album_tracks(albums)
  track_features <- get_track_audio_features(tracks)
  track_popularity <- get_track_popularity(tracks)
  
  tots <- albums %>% 
    left_join(album_popularity, by = 'album_uri') %>% 
    left_join(tracks, by = 'album_name') %>% 
    left_join(track_features, by = 'track_uri') %>% 
    left_join(track_popularity, by = 'track_uri')
  
  return(tots)
}