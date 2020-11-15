source("diaryService.R")
library(stringr)


#* @filter cors
cors <- function(req, res) {
  print("cors filter")
  res$setHeader("Access-Control-Allow-Origin", "*") # Or whatever
  res$setHeader("Access-Control-Allow-Methods",'DELETE, POST, GET, OPTIONS')
  res$setHeader("Access-Control-Allow-Headers", "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With")
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods","*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200 
    return(list())
  } else {
    plumber::forward()
  }
}




#* @serializer unboxedJSON
#* @get /posts/<id>
get_post <- function(id, res){ 
  print("get post by id")
  post_optional = get_post_info(id)
  if (length(post_optional) == 0) {
    msg <- str_interp("There is no post with id ${id}")
    res$status <- 404
    return(list(error=jsonlite::unbox(msg)))
  }
  return(post_optional)
}

#* @get /posts
get_all_posts <- function() {
  print("get all posts")
  get_posts()
}

#* @serializer unboxedJSON
#* @post /posts
add_new_post <- function(res, req) {
  print("add new post")
  body = req$body
  if (length(body) != 2) {
    msg <- str_interp("Invalid request body")
    res$status <- 400 # Bad request
    return(list(error=jsonlite::unbox(msg)))
  }
  if (is.null(body$headline)) {
    msg <- str_interp("Please, add headline")
    res$status <- 400 # Bad request
    return(list(error=jsonlite::unbox(msg)))
  }
  if (is.null(body$description)) {
    msg <- str_interp("Please, add description")
    res$status <- 400 # Bad request
    return(list(error=jsonlite::unbox(msg)))
  }
  add_post(body)
  
}
