
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ghtraffic

<!-- badges: start -->

<!-- badges: end -->

The goal of ghtraffic is to access github traffic data using github api.

## Installation

Development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("kvasilopoulos/ghtraffic")
```

# Usage

Make sure you have the necessary setup with github user and token.

``` r
library(gh)
gh_whoami()
#> {
#>   "name": "Kostas Vasilopoulos",
#>   "login": "kvasilopoulos",
#>   "html_url": "https://github.com/kvasilopoulos",
#>   "scopes": "gist, repo, user",
#>   "token": "04..."
#> }
```

And the you can send the request to find the traffic data for the
`ghtraffic` repo from the `kvasilopoulos` user.

``` r
library(ghtraffic)
repo_traffic("kvasilopoulos", "ghtraffic")
#> # A tibble: 1 x 3
#>   timestamp  count uniques
#>   <date>     <int>   <int>
#> 1 2019-07-04     3       1
```

## Next Steps

Build on infrastructure to be able to set up a tracker into the repo, in
order to be able to track traffic data for more than 2 weeks.

-----

Please note that the ‘ghtraffic’ project is released with a [Contributor
Code of Conduct](.github/CODE_OF_CONDUCT.md). By contributing to this
project, you agree to abide by its terms
