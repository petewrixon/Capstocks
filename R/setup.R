renv::use('plyr',
          'readr',
          'readxl',
          'testthat',
          'tibble',
          'tidyr',
          'forecast',
          'stringr',
          'sqldf',
          'cellranger',
          'RSQLite',
          'writexl',
          'futile.logger',
          'doSNOW',
          'assertr',
          'tempdisagg',
          'purrrlyr',
          'data.table',
          'forcats')

devtools::install_github(repo = 'https://github.com/ONSdigital/Capstocks_source_files.git', ref = "HEAD", subdir = '/capstock')
devtools::install_github(repo = 'https://github.com/ONSdigital/Capstocks_source_files.git', ref = "HEAD", subdir = '/pimir')

devtools::install_github(repo = 'https://github.com/ONSdigital/Capstocks_source_files.git', ref = "HEAD", subdir = '/pimIO')

devtools::install_github(repo = 'https://github.com/ONSdigital/Capstocks_source_files.git', ref = "HEAD", subdir = '/prepim')

library(capstock, pimir)
