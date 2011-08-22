#----------------------------------------------------------------------------
# STIR FRIED
# A Rails Template for Noodall
#
# Adds Beefplate (https://github.com/discoliam/beefplate/tree/noodallplate) to new Noodall projects. Sets up Sprockets and other stuff like that.
#
# Written by:
# Liam Richardson - Front End Developer - Beef
# Steve England - Development Director - Beef
# James Ede - Head Off Front End - Beef
#
# discoliam.com
# wearebeef.co.uk
#----------------------------------------------------------------------------


# RESOURCES
# http://everydayrails.com/2011/02/28/rails-3-application-templates.html
# http://guides.rubyonrails.org/generators.html#application-templates
# https://github.com/russfrisch/Rails-HTML5-Boilerplate-Template/blob/master/rails3.rb

#sprockets info
# http://blog.nodeta.com/2011/06/14/rails-3-1-asset-pipeline-in-the-real-world/


#----------------------------------------------------------------------------
# INSTALLING NEW GEMS
#----------------------------------------------------------------------------
gem "sass"
gem "compass"
gem "sprockets"

#----------------------------------------------------------------------------
# GEM CONFIGURATION
#----------------------------------------------------------------------------
# CONFIG FOR SASS, COMPASS, SPROCKETS (scss location, css location, output styles, compression, debug info)

#
# COMPASS OPTIONS NEEDED
# enviroment          =   rails
# css_dir             =   stylehseets
# sass_dir            =   app/assets/stylesheets
# fonts_dir           =   public/fonts
# preferred_syntax    =   :scss

# SASS OPTIONS NEEDED

# DEVELOPMENT / STAGING
# 
# :style = :expanded
# :syntax = :scss
# :debug_info -= :true
# 
# PRODUCTION
# 
# :style = :compressed
# :syntax = :scss
# 
# Also in production, stylesheets should be compressed into one application stylesheet

#----------------------------------------------------------------------------
# CREATE RVMC FILE
#----------------------------------------------------------------------------
# create_file ".rvmrc", "rvm gemset use #{app_name}"

#----------------------------------------------------------------------------
# UPDATE GIT IGNORE
#----------------------------------------------------------------------------
#sass cache, DS_Store, Anything else? 

#----------------------------------------------------------------------------
# REMOVE FILES
#----------------------------------------------------------------------------
run 'rm app/views/layouts/application.html.erb'
run 'rm public/images/rails.png'
run 'rm public/javascripts/application.js'

run 'rm app/assets/javascripts/application.js'
run 'rm app/assets/stylesheets/application.css'


inside('public') do
  FileUtils.rm_rf %w(404.html 422.html 500.html)
end

#----------------------------------------------------------------------------
# CREATE ASSETS FOLDER
#----------------------------------------------------------------------------
run 'mkdir app/assets'
run 'mkdir app/assets/stylesheets'
run 'mkdir app/assets/javascripts'
run 'mkdir app/assets/javascripts/libs'
run 'mkdir app/assets/javascripts/src'


#----------------------------------------------------------------------------
# ADD BEEFPLATE
#----------------------------------------------------------------------------

#LAYOUT
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/index.html", "app/views/layouts/application.html.erb"

#STYLESHEETS
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/reset.css", "app/assets/stylesheets/reset.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/typography.css", "app/assets/stylesheets/typography.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/skin.css", "app/assets/stylesheets/skin.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/layout.css", "app/assets/stylesheets/layout.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/forms.css", "app/assets/stylesheets/forms.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/ie7.css", "app/assets/stylesheets/ie7.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/ie8.css", "app/assets/stylesheets/ie8.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/ie9.css", "app/assets/stylesheets/ie9.scss"

#JAVASCRIPTS
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/application.js", "app/assets/javascripts/applications.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/libs/cufon-yui.js", "app/assets/javascripts/libs/cufon-yui.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/libs/modernizr-2.0.min.js", "app/assets/javascripts/libs/modernizr-2.0.min.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/libs/jquery-1.6.2.min.js", "app/assets/javascripts/libs/jquery-1.6.2.min.js"
# get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/libs/jcarousellite_1.0.1.min.js", "app/assets/javascripts/libs/jcarousellite_1.0.1.min.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/libs/jquery.fancybox-1.3.4.j'", "app/assets/javascripts/libs/jquery.fancybox-1.3.4.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/libs/slides.min.jquery.js", "app/assets/javascripts/libs/slides.min.jquery.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/src/base.js", "app/assets/javascripts/src/base.js"

#IMAGES
get "https://github.com/discoliam/beefplate/raw/noodallplate/Site/images/404-search.png", "public/images/404-search.png"

#ERRORS
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/404.html", "public/404.html"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/422.html", "public/422.html"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/500.html", "public/500.html"

#META
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/humans.txt", "public/humans.txt"

#----------------------------------------------------------------------------
# TIDYING UP COMANDS
#----------------------------------------------------------------------------
run 'bundle install'

#----------------------------------------------------------------------------
# GIT
#----------------------------------------------------------------------------
# git :init
# git :add => "."
# git :commit => "-a -m 'Initial Beefplate Commit'"




# how to append stuff
#append_file 'public/stylesheets/application.css', '@import url("scaffold.css");