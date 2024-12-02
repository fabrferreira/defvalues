#' Deflaciona valores nominais em reais
#'
#' Deflaciona valores nominais em valores reais com base em diversos
#' índices de preços ao consumidor. Esta função envelopa a função `deflate()`
#' do pacote `deflateBR`.
#'
#' @param .data Tibble ou data.frame contendo as informações necessárias
#' para o deflacionamento dos valores.
#' @param date_format Formato da data inserida pelo usuário.
#' Pode ser "ano" ou "dd/mm/yyyy".
#' @param nominal_dates Nome da coluna que contém as datas nominais.
#' @param real_date String com a data na qual o usuário deseja deflacionar
#' os valores.
#' @param index Índice de preços utilizado para deflacionar os valores.
#' Pode ser `ipca`, `igpm`, `igpdi`, `ipc` ou `inpc`.
#' @param ... Vetor com o nome das colunas que contêm os valores a
#' serem deflacionados.
#'
#' @export
def_valores <- function(.data,
                        date_format,
                        nominal_dates,
                        real_date,
                        index,
                        ...) {

  # Checa o formato da data inserida pelo usuário

  date_format <- rlang::arg_match(date_format, c("ano", "dd/mm/yyyy"))

  # Manipula a coluna informada em `date_format` em função do tipo

  if (date_format == "ano") {

    .data <- .data |>
      dplyr::mutate(
        {{ nominal_dates }} := lubridate::make_date(year = !!rlang::ensym(nominal_dates), month = 1, day = 31)
      )
  }

  if (date_format == "dd/mm/yyyy") {

    .data <- .data |>
      dplyr::mutate(
        {{ nominal_dates }} := lubridate::dmy({{ nominal_dates }})
      )
  }

  # Coleta `...` em uma lista

  cols <- rlang::list2(...)

  # Deflaciona os valores com base nas informações fornecidas pelo usuário

  values_deflated <- .data |>
    dplyr::mutate(
      dplyr::across(
        !!!cols,
        ~ deflateBR::deflate(
          nominal_values = .x,
          nominal_dates = !!rlang::ensym(nominal_dates),
          real_date = real_date,
          index = index
        ),
        .names = "{.col}_deflacionado"
      )
    )

  # Retorna o tibble com os valores deflacionados

  return(values_deflated)
}
