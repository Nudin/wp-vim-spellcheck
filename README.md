# Generate spell files for Vim based on Wikipedia.

For a lot of us Spell checkers are a great invention, but False
positives (words marked as wrong even through they are correct) are
annoying.

Vim has the awesome feature, that you can enable multiple spell files
("dictionaries") at once. This little script gets a list of all
page titles of all Wikipedia articles. You can load them additionally
to the default spell files. Depending on the text you are writing,
this can decrease the number of false positives greatly, but might
also increase the number of false negatives.

**Usage:**

    $ ./wp-dict.sh [lang]

Then copy the resulting .spl-file to the "spell" subdirectory of one
of the directories in your 'runtimepath', on most systems
*~/.vim/spell/* for your user or something like
*/usr/share/vim/vim74/spell/* for global installation.
For Neovim you can also use *~/.local/share/nvim/site/spell/* instead.

To activate additional to the default language you can use something
like:

    :set spelllang=en,enwp

**Tipp:** if you are writing texts with mixed languages or switch the
language often you can specify even more spell files:

    :set spelllang=en,de,enwp,dewp

**Note:** This is in early development. I sort out a lot of words that
could cause problems but probably won't. And  I have no idea if it works for
languages with alphabets not based on the latin alphabet!

