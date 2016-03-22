#' A function to connect to the RAM legacy stock assessment database 
#' @param auth.list a list including authorization arguments including host, user, password, dbname, port (provided at link above)
#' @param drv.name database driver to use for DBI ('PostgreSQL' on mac/linux)
#' @details constructs a databse connection using DBI-compliant connection via RPostgreSQL package
#' returns list of connection and driver.
#' (latest connection info:
#' http://ramlegacy.marinebiodiversity.ca/ram-legacy-stock-assessment-database/accessing-the-live-database)
#' before using be sure to read the fair use policy:
#' http://ramlegacy.marinebiodiversity.ca/ram-legacy-stock-assessment-database/ram-legacy-stock-assessment-database-fair-use-policy
#' @import RPostgreSQL
#' @examples \dontrun{
#' # Can add lines to your .Rprofile file to store connection info provided at http://ramlegacy.marinebiodiversity.ca/ram-egacy-stock-assessment-database/accessing-the-live-database
#' options(RAM.auth =  alist(host="nautilus-vm.mathstat.dal.ca", user="srdbuser", password="srd6us3r!", dbname="srdb", port="5432"))
#' ## make a connection
#' c <- ConnectRAM()
#' CloseRAM(c)
#'}
#' @export

ConnectRAM<-function(auth.list=getOption("RAM.auth", stop("Need to provide a list of authorization args with elements host, user, password, dbname, port")), drv.name = "PostgreSQL")
  {
    require(RPostgreSQL)
    drv <- dbDriver(drv.name) ## loads the PostgreSQL driver
    if (!is.null(auth.list)) {
      parmsNames <- names(auth.list)
      for (.i in seq(length(parmsNames)))
        assign(parmsNames[.i], auth.list[[.i]])
    }
    con<-dbConnect(drv=drv, host=host, user=user, password=password, dbname=dbname,port=port)
    return(list(connection=con, driver=drv))
  }

#' A function to send SQL queries to the RAM legacy stock assessment database 
#' @param query a valid SQL query executable against RAM Legacy DB
#' @param con.drv a list containing a non-expired connection to and driver for RAM legacy DB
#' @details Runs SQL query against srdb (RAM Legacy DB) and returns result
#' before using be sure to read the fair use policy:
#' http://ramlegacy.marinebiodiversity.ca/ram-legacy-stock-assessment-database/ram-legacy-stock-assessment-database-fair-use-policy
#' @import RPostgreSQL
#' @examples \dontrun{
#' ## make a connection
#' c <- ConnectRAM()  #running without argumetns requires RAM.auth list set as global option
#' lme.df<-QueryRAM("select * from srdb.lmerefs", c)
#' CloseRAM(c)
#' }
#' @export

QueryRAM<-function(query, con.drv=NULL){
  cat("WARNING: currently\n (1) no error checking for SQL query,\n (2) no checking to make sure query is resonable size!\n (2 is more of a problem than 1)\n")
  # con.drv should be a list of connection and driver as returned by ConnectRAM
  new.connect = FALSE
  if(is.null(con.drv)){
    con.drv = ConnectRAM()
    new.connect = TRUE
  }
  rs = dbGetQuery(con.drv$connection, query)
  if(new.connect)
    CloseRAM(con.drv)
  return(rs)
}

#' A function to close connection to the RAM legacy DB
#' @param con.drv a list containing a non-expired connection to and driver for RAM legacy DB
#' @details closes databse connection using DBI-compliant connection via RPostgreSQL package
#' @import RPostgreSQL
#' @examples \dontrun{
#' ## make a connection
#' c <- ConnectRAM() #running without argumetns requires RAM.auth list set as global option
#' CloseRAM(c)
#' }
#' @export

CloseRAM<-function(con.drv=NULL){
  ## need error check
  dbDisconnect(con.drv$connection)  ## Closes the connection
  dbUnloadDriver(con.drv$driver)  ## Frees all the resources on the driver
  return(NULL)
}

## TODO: use ASYNCH version submit a statment
#rs <-dbSendQuery(con, "select * from srdb.stock where commonname='menhaden'")

## fetch all elements from the result set
#fetch(rs,n=-1)

## generate a list of forage fish name parts
#c('sard', 'pilch', 'herr', 'anch', 'chub mackerel', 'menhaden')

