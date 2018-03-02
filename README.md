# MovieOrganizer

Automatically organize movies, tv shows and home videos.

I use [Plex](https://www.plex.tv/) as the centerpiece of my home entertainment center, which requires that I rip my BluRay movies and TV shows, and copy them into a certain location so my [Plex server](https://www.plex.tv/downloads/) can recognize them.

MovieOrganizer makes the job of organizing my ripped movies, tv shows and home videos as simple as:

```bash
movie_organizer

Starting MovieOrganizer...
Processing [/Users/midwire/Downloads/The Matrix (1990).mp4] - MovieOrganizer::Movie
    target dir: [ssh://username@plex_server/media/movies/The Matrix (1990)]
    target file: [ssh://username@plex_server/media/movies/The Matrix (1990)/The Matrix (1990).mp4]

...
```

## Features

* Copies media to remote hosts
* Can differentiate between most Movies, TV Shows and Home Video if they are named properly, and copy each to the appropriately configured directory
* Uses [The Movie Database](https://www.themoviedb.org) for movie identification

## Caveats

Note that this is beta software. I wrote it as a hack because I got tired of constantly copying my media over to Plex by hand.  Having said that, it works but there are edge cases that are probably not covered. If you find a bug or problem, please file an issue and I'll address it ASAP.

## Installation

    $ gem install movie_organizer

## Configuration

Create a file in your home directory named `.movie_organizer.yml` as follows:

```yaml
---
:space_warning: 20GB
:new_media_directories:
- "/Users/midwire/media_rips" # <- new media directory
:tv_shows:
  :directory: "/Volumes/Genesis/TV Series" # <- a local directory
:movies:
  :tmdb_key: df08efec9f01985d401a3cfedf5628a2 # <- use your own API key (this one is fake)
  :directory: ssh://plex_admin@plex.local/media/media1/movies # <- remote directory
:videos:
  :directory: "ssh://plex_admin@plex.local/media/media1/Family Videos" # <- remote directory
```

**NOTE:** If you want to use a remote host, you will need to configure passwordless logins using your ssh-key, which is outside the scope of this document.  If you don't know how, please do a search for

Remote hosts are specified in this format:

```bash
ssh://username@hostname/path/to/remote/destination
```

## Usage

You should be able to simply run `movie_organizer`

Here are the command line options:

```bash
Options:
  -s, --source-dir=<s>           Source directories containing media files. Colon (:) separated. (Default: /Users/midwire/media_rips)
  -d, --dry-run                  Do not actually move or copy files
  -p, --preserve-episode-name    Preserve episode names if they exist (experimental)
  -v, --verbose                  Be verbose with output
  -h, --help                     Show this message
```

## Attribution

### The Movie Database

<img src="tmdb-logo-primary-green.png" alt="TMDB Logo" style="float:left; padding: 0 10px 0 0;"/> We are profoundly pleased to have access to [The Movie Database](https://www.themoviedb.org) API. This product uses the TMDb API but is not endorsed or certified by TMDb.
