# Apple (iCloud) Photos library

Making my favorites from my Apple Photos library appear on my photoframe.

## Usage

Regenerate everything:

    redo

or regenerate individual files piecemeal:

    redo favorites.csv
    redo datasette/photos.db

Serve with Datasette:

    datasette --host localhost --port 3000 datasette/

View the favorites table:

    http://localhost:3000/photos/favorites

Note the "preview" column at the far right.  It uses the datasette-media
endpoint (see next example) configured in `datasette/metadata.yaml`.

View a full-size photo:

    http://localhost:3000/-/media/favorites/CABCDD46-3EF6-4729-B0E2-A70F3872C560?format=JPEG

View a smaller photo:

    http://localhost:3000/-/media/favorites/CABCDD46-3EF6-4729-B0E2-A70F3872C560?format=JPEG&h=200

Fetch a list of URLs for all favorites:

    http://localhost:3000/photos/favorites-urls.csv?_stream=on

This list is used during random photo selection for the photoframe, mixed into
a similar list of Flickr URLs.

## Requirements

Run macOS with Photos.app set to sync from iCloud and download and keep
originals.

Install a bunch of tools:

    brew install redo

    brew install moreutils

    brew install pipx

    pipx install osxphotos

    pipx install sqlite-utils

    pipx install datasette
    pipx inject datasette datasette-media datasette-json-html

Now, work around all-too-typical software fuckery.

The latest release of pyheif (i.e. on PyPI) does not support the latest libheif
in Homebrew.  The documented install method for macOS is to use Homebrew +
unreleased pyheif from its source control repository.  However, at this time
pyheif lags behind libheif on Homebrew and the latest available source for
pyheif expects libheif 1.16.2 and does not build against 1.17.6 from Homebrew.

Work around this by installing 1.16.2 with Homebrew.  This is complicated
by Homebrew's shift to fetching package info from an API instead of using
its previous long-standing "taps" system.  So we have to override that
default to have it use the core tap again.  It's all pretty awkward, but
at least it works.

    brew tap --force homebrew-core
    git -C "$(brew --prefix)/Library/Taps/homebrew/homebrew-core" checkout aa976f78584cce32febca44fd4a8c275d4e9318c -- Formula/lib/libheif.rb
    HOMEBREW_NO_INSTALL_FROM_API=1 HOMEBREW_NO_AUTO_UPDATE=1 brew install libheif
    brew pin libheif
    brew untap homebrew/core

    brew install libffi
    pipx inject datasette 'pyheif @ git+https://github.com/carsales/pyheif.git@2eaefe983acc01d52ca6b0094d986739cd7b32a5'

datasette-media doesn't use newer versions of pyheif (>=0.6.0) correctly
when passing data to Pillow (PIL.Image): it omits some arguments which
are crucial for proper decoding of some images.  Oops.  Patch it.

    patch -d "$(pipx environment -V PIPX_LOCAL_VENVS)"/datasette/lib/python3.*/site-packages/ < datasette-media-heic.patch

Are we having fun yet?
