library(RPostgreSQL)
library(DBI)
library(stringr)

pw<- {
  "test123"
}

get_connection <- function() {
  con <-dbConnect(dbDriver("PostgreSQL"), 
                 dbname="diary", 
                 host="host.docker.internal", 
                 port=5432, 
                 user="test_user",
                 password=pw)
  return (con)
}

get_all_posts <- function() {
  conn <- get_connection()
  res <- dbGetQuery(conn,' select * from "post"')
  dbDisconnect(conn)
  return (res)
}

get_post_by_id <- function(id) {
  conn <- get_connection()
  res <- dbGetQuery(conn,str_interp(' select * from "post" where id = ${id}'))
  dbDisconnect(conn)
  return(res)
}

insert_post <- function(post) {
  conn <- get_connection()
  rs <- dbSendStatement(
    conn,
    str_interp("INSERT INTO post (text_post, date_posted, headline) 
               VALUES ('${post$description}', now(), '${post$headline}')")
  )
  dbHasCompleted(rs)
  dbGetRowsAffected(rs)
  dbClearResult(rs)
  dbDisconnect(conn)
}

get_last_post <- function() {
  conn <- get_connection()
  res <- dbGetQuery(conn,str_interp('select * from "post" 
                                    order by id desc limit 1'))
  dbDisconnect(conn)
  return(res)
}

