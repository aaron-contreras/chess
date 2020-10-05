# TERMINAL CHESS

My take on this classic, built with Ruby.

## Requirements
- [Ruby](https://www.ruby-lang.org/en/) >= 2.6.5
- [Bundler](https://bundler.io/) >= 2.1.2

## Installation
- Clone the repo locally.
- `cd` into it.
- Run `bundle install`

## Playing
- From the repo's root directory, run `bundle exec ruby chess_game_client.rb`
- If at any point the Chess board's colors are **not visible**
  1. Go to the `Options menu`
  2. Select `Switch terminal color mode`
  3. Select a color mode that is supported by your terminal
  
## Demo


## Thoughts & notes

### Gems used
- [tty-prompt](https://github.com/piotrmurach/tty-prompt)
  - Great for creating navigation menus and validating input.
- [tty-screen](https://github.com/piotrmurach/tty-screen)
  - Detects screen dimensions of the terminal.
- [tty-box](https://github.com/piotrmurach/tty-box)
  - Prints and aligns "textboxes" nicely.
- [paint](https://github.com/janlelis/paint)
  - Liked it better than 'colorize'. Gives more control over the colors you'd like to display
- [figlet](https://github.com/tim/figlet)
  - Creates pretty cool titles.
- [oj](https://github.com/ohler55/oj)
  - Found this great JSON serializer, give it a try as well!
