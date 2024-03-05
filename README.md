Requirements:

    brew install redo

    brew install pipx

    pipx install osxphotos

    pipx install sqlite-utils

    pipx install datasette
    pipx inject datasette datasette-media datasette-json-html

    # The latest release of pyheif (i.e. on PyPI) does not support the latest
    # libheif in Homebrew.  The documented install method for macOS is to use
    # Homebrew + unreleased pyheif from its source control repository.  However,
    # at this time pyheif lags behind libheif on Homebrew and the latest
    # available source for pyheif expects libheif 1.16.2 and does not build
    # against 1.17.6 from Homebrew.
    #
    # Work around this by installing 1.16.2 with Homebrew.  This is complicated
    # by Homebrew's shift to fetching package info from an API instead of using
    # its previous long-standing "taps" system.  So we have to override that
    # default to have it use the core tap again.  It's all pretty awkward, but
    # at least it works.
    #   -trs, 5 March 2024
    brew tap --force homebrew-core
    git -C "$(brew --prefix)/Library/Taps/homebrew/homebrew-core" checkout aa976f78584cce32febca44fd4a8c275d4e9318c -- Formula/lib/libheif.rb
    HOMEBREW_NO_INSTALL_FROM_API=1 brew install libheif

    brew install libffi
    pipx inject datasette 'pyheif @ git+https://github.com/carsales/pyheif.git@2eaefe983acc01d52ca6b0094d986739cd7b32a5'

    # datasette-media doesn't use newer versions of pyheif (>=0.6.0) correctly
    # when passing data to Pillow (PIL.Image): it omits some arguments which
    # are crucial for proper decoding of some images.  Patch it!
    #   -trs, 5 March 2024
    patch -d "$(pipx environment -V PIPX_LOCAL_VENVS)"/datasette/lib/python3.*/site-packages/ < datasette-media-heic.patch
