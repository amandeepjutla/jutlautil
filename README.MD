# jutlautil

Package for simple utilities that I find myself using in multiple projects.

## set_anchor 
Finds working directory for a project. Looks in current directory for a file called `.anchor`; if it doesn't find it, goes to parent directory and looks again. Keeps doing this until it either finds the file or runs out of directories to search. Analogous to R's `here` package. 
