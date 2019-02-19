# ruby-bowling

A console program to validate and render bowling score card

## How to use
1 Install the ruby framework

2 Run `ruby-bowling` in the `bin` folder or `main.rb` in the `src` folder

Example:

```
cd bin
./ruby-bowling
```
This will read the `game.txt` file in the `src` folder

### Advance use

If you want to exec the test and documentation please install `bundle`

* Read custom input file (see example files [here](https://github.com/DFOXpro/ruby-bowling/tree/master/fixtures))
```
./ruby-bowling --input-file my\ custom\ game.txt
```
* Build source docs (You can see it [here](https://dfoxpro.github.io/ruby-bowling/))
```
cd bin
./document_me.sh
```
* Test the source (You can see the results [here](https://dfoxpro.github.io/ruby-bowling/results.html))
```
cd bin
./test_me.sh
```
* Any other extra option see the help
```
./ruby-bowling --help
```

## Known issues

* all given routes are relative to `src` folder

## Licence
MPL v2.0