# Compboost Talk

## Initialize

Clone the repo by also initializing the `compboost` submodule. This is necessary since it includes the actual version of compboost and the benchmark wich we will also use in the slides.

**SSH:**
```
git clone --recursive git@github.com:schalkdaniel/2018_reisensburg.git
```

**HTTPS:**
```
git clone --recursive https://github.com/schalkdaniel/2018_reisensburg.git
```

## Rendering The Talk

To get the pdf the following steps are executed automatically:

1. Build and load compboost using `devtools::load_all()`.
2. Make the drake plan to access the benchmark images.
3. The ordinary `Rnw` stuff should be straight forward.
