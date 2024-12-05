
<!-- README.md is generated from README.Rmd. Please edit that file -->

# defvalues

<!-- badges: start -->
<!-- badges: end -->

The main goal of `defvalues` package is to be a tool that helps the user
to deflate values easily and quickly. The package has one main function:
`deflate_values()`. This function wraps the `deflateBR::deflate()`
function, and adds some features based in non standard evaluation
programming pattern provided by `rlang` package. This pattern allows the
user to use the function in a more intuitive way, without the need to
use the `{{ }}` operator and pass more than one variable to deflate.

## Installation

You can install the development version of `defvalues` from
[GitHub](https://github.com/) with:

``` r

# install.packages("pak")
pak::pak("fabrferreira/defvalues")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(defvalues)
## basic example code
```
