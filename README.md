# chess:
My (UNFINISHED) solution to the [final exercise of the Ruby Programming Unit](https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project), from the Odin Project.

The instructions, in a nutshell, are to build a "... command line Chess game where two players can play against each other. The game should be properly constrained."

I chose not to produce a command line app, but instead went for a more graphical approach using the ruby2D gem, because while this gem is still a little rough around the edges (only at v 0.7), it is way more pleasant to look at, and can produce a much more user-friendly interface (with a little more work). So far, I have been very impressed with the ease-of-use of this gem.

Current state (31/10/18): Pieces constrained to legal moves (including taking), except for; not constrained by check (kinda important issue) and en-passant not yet implemented. Detecting check will hopefully lead to detection of pins (and, of course, checkmate), and then a working game will be possible, though I expect it will take some work to optimize / make efficient.

### Interesting issues to address:
  * Detecting 3-fold repetition (store and scan checksums on hashes of positions?)
  * Brute force calculation of legal moves only when player lifts piece, or by continually updating a list of all legal moves for each side (and working out how to minimize the updating process by calculating how every/any move does / might _not_ affect some other pieces)?
  * 50-move draw rule

### Features I want to add:
  * file ui, for saving a loading of both unfinished and finished games, in both app native and PGN formats.
  * step back / fwd through game (in progress, or completed)
  * ui niceties (e.g. coordinates on/off, piece points count, highlight King when in check, verbose mode, etc.)
  * Try doing more than just an 'AI' that plays a random move (as suggested in the 'Optional Extension'), but instead use a brute force look-ahead of a few ply (will still be an awful opponent!).

### Resources used:

  * ruby2D gem: Tom Black: This entire project is open source under the MIT license. [web page](http://www.ruby2d.com/learn/get-started/)
  * Chess Mérida: Freeware. True Type Font by Armando H. Marroquin for diagrams and figurine notation. [source](https://marcelk.net/chess/pieces/merida/320/)
