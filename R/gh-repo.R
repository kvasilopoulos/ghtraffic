#' Traffic information of a github repository
#'
#' @param owner the owner of the repo.
#' @param repo the name of the repo.
#' @param ... Name-value pairs giving API parameters.
#'
#' @importFrom gh gh
#' @importFrom dplyr mutate bind_rows
#' @importFrom purrr map reduce
#' @export
repo_traffic <- function(owner, repo, ...) {

  request <- gh::gh("/repos/:owner/:repo/traffic/views",
                    owner = owner, repo = repo, ...)

  request$views %>%
    map(as_tibble) %>%
    reduce(bind_rows) %>%
    mutate(timestamp = as.Date(.data$timestamp))
}

#' Extract the names of a username
#'
#' @param username the username.
#' @inheritParams repo_traffic
#'
#' @export
repo_names <- function(username, ...) {
  nms <- list()
  repos <- gh("GET /users/:username/repos", username = username, .limit = Inf, ...)
  vapply(repos, "[[", "", "name")
}

#' Get an overview with the sum of the traffic data of a username
#'
#' @param username the username.
#' @inheritParams repo_traffic
#'
#' @importFrom purrr map map2 reduce possibly set_names
#' @importFrom dplyr select summarize_all %>% .data
#' @importFrom tibble as_tibble add_column tibble
#' @export
repo_traffic_overview <- function(username, ...) {

  poss_rf <- possibly(repo_traffic,
                      tibble("timestamp" = "", "count" = 0, "uniques" = 0))
  nms <- repo_names(username, ...)
  rp_traffic <- map(nms, ~ .x %>%  poss_rf(username, .)) %>%
    set_names(nms)

  rp_traffic %>%
    map(~ .x[,-1]) %>%
    map(summarize_all, mean) %>%
    map2(nms, ~ add_column(.x, .y)) %>%
    reduce(bind_rows) %>%
    select(repo = .data$.y, .data$count, .data$uniques)

}

