library('rsconnect')

build_folder_name = '.build'

sys_files = c('*.Rproj', 'build.R', build_folder_name)
app_files = c('plumber.R', 'app.R', 'report-1.Rmd', 'report-2.Rmd')

exclude_patterns = paste(sys_files, app_files, sep = '|', collapse = '|')

copy_source = grep(
  exclude_patterns,
  list.files(include.dirs = TRUE),
  invert = TRUE,
  value = TRUE
)

build_main <- function(app_file) {
  app_name = tools::file_path_sans_ext(app_file)
  app_dir = file.path(build_folder_name, app_name)
  
  message(sprintf('Build started for app. AppName=%s, AppDirectory=%s', app_name, app_dir))
  
  dir_exists <- dir.create(app_dir, showWarnings = FALSE)
  if (!dir_exists) {
    message(sprintf('App directory already exists. Not creating it. AppDirectory=%s', app_dir))
  } else {
    message(sprintf('App directory does not exist yet. Creating it. AppDirectory=%s', app_dir))
  }
  
  build_copy_apps(app_file, app_dir)
  
  build_write_manifest(app_file, app_dir)
  message(sprintf('Build completed for app. AppName=%s, AppDirectory=%s', app_name, app_dir))
}

build_copy_apps <- function(app_file, app_dir) {
  lapply(copy_source, function(c) {
    message(sprintf('Copying shared file / folder from source to target. Source=%s, TargetFolder=%s', c, app_dir))
    file.copy(copy_source, app_dir, recursive = TRUE)
  })
  
  message(sprintf('Copying app file from source to target. Source=%s, TargetFolder=%s', app_file, app_dir))
  file.copy(app_file, app_dir)
}

build_write_manifest <- function(app_file, app_dir) {
  # Eventually we will need to stop using writeManifest's infer app mode since that restricts us to using the default file names
  app_primary_doc = app_file
  message(sprintf('Writing manifest for app. AppDirectory=%s, AppPrimaryDoc=%s', app_dir, app_primary_doc))
  writeManifest(appDir = app_dir, appPrimaryDoc = app_primary_doc)
}

message(sprintf('Deleting existing build folder'))
unlink('build', recursive = TRUE)
dir.create(build_folder_name, showWarnings = FALSE)

lapply(app_files, build_main)
