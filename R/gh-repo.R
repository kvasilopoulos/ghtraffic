
#' @importFrom gh gh
#' @importFrom dplyr as_tibble mutate
#' @importFrom purrr map reduce
#' @export
repo_traffic <- function(owner, repo, ...) {

  request <- gh::gh("/repos/:owner/:repo/traffic/views",
                    owner = owner, repo = repo, ...)

  request$views %>%
    map(as_tibble) %>%
    reduce(bind_rows) %>%
    mutate(timestamp = as.Date(timestamp))
}

#' @export
repo_names <- function(username, ...) {
  nms <- list()
  repos <- gh("GET /users/:username/repos", username = username, .limit = Inf, ...)
  vapply(repos, "[[", "", "name")
}


#' @importFrom purrr map map2 reduce possibly set_names
#' @importFrom dplyr select
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
    select(repo = .y, count, uniques)

}

