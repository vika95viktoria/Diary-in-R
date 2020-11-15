FROM rocker/r-ver:3.5.0

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev \
  libpq-dev \
  curl

# install plumber
RUN R -e "install.packages(c('plumber','DBI', 'RPostgreSQL', 'stringr'))"

# copy everything from the current directory into the container
COPY / /

# open port 8000 to traffic
EXPOSE 8000

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "server.R"]