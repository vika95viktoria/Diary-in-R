source('diaryRepository.R')

get_post_info <- function(id) {
  result <- get_post_by_id(id)
  if (length(result) > 0) {
    return (transform_post(result))
  }
}

get_posts <- function() {
  return(get_all_posts())
}

add_post <- function(post) {
  insert_post(post)
  return(transform_post(get_last_post()))
}

transform_post <-function(result) {
  return (list(id = result$id[1], text_post = result$text_post[1], 
               date_posted = result$date_posted[1], 
               headline = result$headline[1]))
}