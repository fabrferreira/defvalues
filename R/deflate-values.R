#' Deflate nominal values to real values
#'
#' Deflate nominal values to real values based on several consumer price indices.
#' This function wraps the `deflate()` function from the `deflateBR` package,
#' using *Non Standard Evaluation* programming pattern provided by
#' `rlang` package.
#'
#' @param .data Tibble or data.frame containing the necessary information to
#' deflate the values.
#' @param date_format Format of the date inserted by the user. It can be "year"
#' or "dd/mm/yyyy".
#' @param nominal_dates Name of the column containing the nominal dates.
#' @param real_date String with the date in which the user wants to deflate the
#' values.
#' @param index Price index used to deflate the values. It can be `ipca`, `igpm`,
#' `igpdi`, `ipc` or `inpc`.
#' @param ... Name of the column ou a vector containing the names of the columns
#' that user want to deflate.
#'
#' @export
deflate_values <- function(.data,
                           date_format,
                           nominal_dates,
                           real_date,
                           index,
                           ...) {
  # Check if the date format is valid

  date_format <- rlang::arg_match(date_format, c("ano", "dd/mm/yyyy"))

  # Manipulate the column informed in `date_format` according to the type


  if (date_format == "ano") {
    .data <- .data |>
      dplyr::mutate({{ nominal_dates }} := lubridate::make_date(
        year = !!rlang::ensym(nominal_dates),
        month = 1,
        day = 31
      ))
  }

  if (date_format == "dd/mm/yyyy") {
    .data <- .data |>
      dplyr::mutate({{ nominal_dates }} := lubridate::dmy({{ nominal_dates }}))
  }

  # Collect dots into a list

  cols <- rlang::list2(...)

  # Deflate the values based on the user's input

  values_deflated <- .data |>
    dplyr::mutate(dplyr::across(
      !!!cols,
      ~ deflateBR::deflate(
        nominal_values = .x,
        nominal_dates = !!rlang::ensym(nominal_dates),
        real_date = real_date,
        index = index
      ),
      .names = "{.col}_deflacionado"
    ))

  # Return the tibble with the deflated values

  return(values_deflated)
}
