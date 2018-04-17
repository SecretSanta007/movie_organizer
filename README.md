# MovieOrganizer

Automatically organize movies, tv shows ~~and home videos~~. **NOTE: home videos are temporarily disabled for now**

I use [Plex](https://www.plex.tv/) as the centerpiece of my home entertainment center, which requires that I rip my BluRay movies and TV shows, and copy them into a certain location so my [Plex server](https://www.plex.tv/downloads/) can recognize them.

MovieOrganizer makes the job of organizing my ripped movies, tv shows ~~and home videos~~ as simple as:

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
* Can differentiate between most Movies, TV Shows ~~and Home Video~~ if they are named properly, and copy each to the appropriately configured directory. See [Plex Media Preparation](https://support.plex.tv/articles/categories/media-preparation/)
* Uses [The Movie Database](https://www.themoviedb.org) for movie identification
* Uses [The TV DB](https://www.thetvdb.com/) for TV show identification

## Caveats

Note that this is beta software. I wrote it as a hack because I got tired of constantly copying my media over to Plex by hand.  It does a decent job of recognizing and grooming media filenames but it is not perfect. There are edge cases that are not covered for really wonky filenames.  If you find a bug or problem, please file an issue and I'll address it ASAP.

## Installation

    $ gem install movie_organizer

## Configuration

Sign up for an account at [The Movie Database](https://www.themoviedb.org/) and get an API key.
Sign up for an account at [The TV DB](https://www.thetvdb.com/) and get an API key.

Create a file in your home directory named `.movie_organizer.yml` as follows:

```yaml
---
:new_media_directories:
- "/Users/midwire/media_rips" # <- new media (source) directory
:tv_shows:
  :directory: "/Volumes/Genesis/TV Series" # <- a local directory
:movies:
  :tmdb_key: df08efec9f01985d401a3cfedf5628a2 # <- use your own API key (this one is fake)
  :directory: ssh://plex_admin@plex.local/media/media1/movies # <- remote directory
:videos:
  :tvdb_key: df08efec9f01985d401a3cfedf5628a2 # <- use your own API key (this one is fake)
  :directory: "ssh://plex_admin@plex.local/media/media1/Family Videos" # <- remote directory
```

**NOTE:** If your Plex media is on a remote host, you will need to configure passwordless logins using your ssh-key, which is outside the scope of this document.  If you don't know how, please do a search for `ssh public key authentication`.

You can also set your api keys, `TMDB_KEY` and `TVDB_KEY` as environment variables, in which case they will be used instead of the corresponding settings in your `.movie_organizer.yml` file. In other words, the environment variables override the .yml file.  Useful for testing.

Remote hosts are specified in this format:

```bash
ssh://username@hostname/path/to/remote/destination
```

## Usage

If you have the yaml configuration settings configured correctly, you should be able to simply run `movie_organizer`. However, it tries to prompt for most missing settings.

Here are the command line options:

```bash
Options:
  -s, --source-dir=<s>    Source directories containing media files. Colon (:) separated.
  -c, --copy              Copy instead of Move files
  -d, --dry-run           Do not actually move or copy files
  -v, --verbose           Be verbose with output
  -h, --help              Show this message
```

## TODO

* Consolidate and better manage regular expressions
* Handle multi-part movies and videos `Beetlejuice (1996)-part1.mp4`, `Beetlejuice (1996)-part2.mp4`, etc.

## Attribution

### The Movie Database

<img src="tmdb-logo-primary-green.png" alt="TMDB Logo" style="float:left; padding: 0 10px 0 0;"/> We are pleased to have access to [The Movie Database](https://www.themoviedb.org) API. This product uses the TMDb API but is not endorsed or certified by TMDb.

### The TV DB

We are also pleased to have access to [The TV DB](https://www.tvdb.com) API. Please help by contributing TV Show information and artwork.
