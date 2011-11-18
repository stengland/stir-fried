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
#
#
# >---------------------------------------------------------------------------<
#
#            _____       _ _   __          ___                  _
#           |  __ \     (_) |  \ \        / (_)                | |
#           | |__) |__ _ _| |___\ \  /\  / / _ ______ _ _ __ __| |
#           |  _  // _` | | / __|\ \/  \/ / | |_  / _` | '__/ _` |
#           | | \ \ (_| | | \__ \ \  /\  /  | |/ / (_| | | | (_| |
#           |_|  \_\__,_|_|_|___/  \/  \/   |_/___\__,_|_|  \__,_|
#
# >----------------------------[ Initial Setup ]------------------------------<

initializer 'generators.rb', <<-RUBY
Rails.application.config.generators do |g|
end
RUBY

@recipes = ["heroku"]

def recipes; @recipes end
def recipe?(name); @recipes.include?(name) end

def say_custom(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "\033[0m" + "  #{text}" end
def say_recipe(name); say "\033[1m\033[36m" + "recipe".rjust(10) + "\033[0m" + "  Running #{name} recipe..." end
def say_wizard(text); say_custom(@current_recipe || 'wizard', text) end

def ask_wizard(question)
  ask "\033[1m\033[30m\033[46m" + (@current_recipe || "prompt").rjust(10) + "\033[0m\033[36m" + "  #{question}\033[0m"
end

def yes_wizard?(question)
  answer = ask_wizard(question + " \033[33m(y/n)\033[0m")
  case answer.downcase
    when "yes", "y"
      true
    when "no", "n"
      false
    else
      yes_wizard?(question)
  end
end

def no_wizard?(question); !yes_wizard?(question) end

def multiple_choice(question, choices)
  say_custom('question', question)
  values = {}
  choices.each_with_index do |choice,i|
    values[(i + 1).to_s] = choice[1]
    say_custom (i + 1).to_s + ')', choice[0]
  end
  answer = ask_wizard("Enter your selection:") while !values.keys.include?(answer)
  values[answer]
end

@current_recipe = nil
@configs = {}

@after_blocks = []
def after_bundler(&block); @after_blocks << [@current_recipe, block]; end
@after_everything_blocks = []
def after_everything(&block); @after_everything_blocks << [@current_recipe, block]; end
@before_configs = {}
def before_config(&block); @before_configs[@current_recipe] = block; end

# RESOURCES
# http://everydayrails.com/2011/02/28/rails-3-application-templates.html
# http://guides.rubyonrails.org/generators.html#application-templates
# https://github.com/russfrisch/Rails-HTML5-Boilerplate-Template/blob/master/rails3.rb

#sprockets info
# http://blog.nodeta.com/2011/06/14/rails-3-1-asset-pipeline-in-the-real-world/
#

#----------------------------------------------------------------------------
# INSTALLING NEW GEMS
#----------------------------------------------------------------------------
insert_into_file "Gemfile", :after => "gem 'uglifier', '>= 1.0.3'\n" do
  "  gem 'compass', :require => false\n"
end

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
# USE DALLI CAHCE STORE
#----------------------------------------------------------------------------
gsub_file('config/environments/production.rb', '# config.cache_store = :mem_cache_store', 'config.cache_store = :dalli_store')

#----------------------------------------------------------------------------
# CREATE RVMC FILE
#----------------------------------------------------------------------------
rvmrc = "rvm 1.9.2@#{app_name} --create"
create_file '.rvmrc', rvmrc

#----------------------------------------------------------------------------
# PROTECT STAGING ENV
#----------------------------------------------------------------------------
gem 'rack-private', '~> 0.1.8', :group => :staging
FileUtils.cp "config/environments/production.rb", "config/environments/staging.rb"
insert_into_file "config/environments/staging.rb", :after => "Application.configure do\n" do
  password = ask("What password would you like on the staging site? (Default: password)")
  password = 'password' if password.empty?
  <<-RUBY
  # Protect staging app
  require 'rack-private'
  config.middleware.use Rack::Private, :code => '#{password}'

  RUBY
end
#----------------------------------------------------------------------------
# SET DEFAULT ADMIN EMAIL AND PASSWORD
#----------------------------------------------------------------------------
admin_email = ask("What is the default admin email? (Default: admin@example.com)")
gsub_file 'db/seeds.rb', 'admin@example.com', admin_email unless admin_email.empty?
admin_password = ask("What is the default admin password? (Default: password)")
gsub_file 'db/seeds.rb', '"password"', "\"#{ admin_password }\"" unless admin_email.empty?

#----------------------------------------------------------------------------
# REMOVE FILES
#----------------------------------------------------------------------------
remove_file 'app/views/layouts/application.html.erb'
remove_file 'app/assets/javascripts/application.js'
remove_file 'app/assets/stylesheets/application.css'

inside('public') do
  FileUtils.rm_rf %w(404.html 422.html 500.html)
end

#----------------------------------------------------------------------------
# ADD BEEFPLATE
#----------------------------------------------------------------------------

#LAYOUT
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/index.html.erb", "app/views/layouts/application.html.erb"

#STYLESHEETS
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/application.css.scss", "app/assets/stylesheets/application.css"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/_variables.scss", "app/assets/stylesheets/_variables.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/reset.css.scss", "app/assets/stylesheets/reset.css.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/typography.css.scss", "app/assets/stylesheets/typography.css.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/skin.css.scss", "app/assets/stylesheets/skin.css.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/layout.css.scss", "app/assets/stylesheets/layout.css.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/forms.css.scss", "app/assets/stylesheets/forms.css.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/ie7.css.scss", "app/assets/stylesheets/ie7.css.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/ie8.css.scss", "app/assets/stylesheets/ie8.css.scss"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/stylesheets/ie9.css.scss", "app/assets/stylesheets/ie9.css.scss"

#JAVASCRIPTS
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/application.js", "app/assets/javascripts/application.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/base.js", "app/assets/javascripts/base.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/libs/cufon-yui.js", "vendor/assets/javascripts/libs/cufon-yui.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/libs/modernizr-2.0.min.js", "vendor/assets/javascripts/libs/modernizr-2.0.min.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/libs/jcarousellite_1.0.1.min.js", "vendor/assets/javascripts/libs/jcarousellite_1.0.1.min.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/libs/jquery.fancybox-1.3.4.js", "vendor/assets/javascripts/libs/jquery.fancybox-1.3.4.js"
get "https://raw.github.com/discoliam/beefplate/noodallplate/Site/javascripts/libs/slides.min.jquery.js", "vendor/assets/javascripts/libs/slides.min.jquery.js"

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
#run 'bundle install'

#----------------------------------------------------------------------------
# GIT
#----------------------------------------------------------------------------
after_bundler do
  git :init
  git :add => "."
  git :commit => "-a -m 'Initial Beefplate Commit'"
  git :flow => 'init'
end
#Apend gitignore
#sass cache, DS_Store, Anything else?
append_file '.gitignore', '.DS_Store'
#----------------------------------------------------------------------------


# >--------------------------------[ Heroku ]---------------------------------<

@current_recipe = "heroku"
@before_configs["heroku"].call if @before_configs["heroku"]
say_recipe 'Heroku'
gem 'heroku', :group => :development, :require => false

config = {}
config['create'] = yes_wizard?("Automatically create #{app_name}.heroku.com?") if true && true unless config.key?('create')
config['staging'] = yes_wizard?("Create staging app? (#{app_name}-staging.heroku.com)") if config['create'] && true unless config.key?('staging')
config['domain'] = ask_wizard("Specify custom domain (or leave blank):") if config['create'] && true unless config.key?('domain')
config['deploy'] = yes_wizard?("Deploy immediately?") if config['create'] && true unless config.key?('deploy')
@configs[@current_recipe] = config

heroku_name = app_name.gsub('_','')

after_everything do
  if config['create']
    say_wizard "Creating Heroku app '#{heroku_name}.heroku.com'"
    while !system("heroku create #{heroku_name} -r production -s cedar")
      heroku_name = ask_wizard("What do you want to call your app? ")
    end
    # Production setup
    system "heroku addons:add sendgrid:starter -r production"
    system "heroku addons:add memcache:5mb -r production"
    system "heroku addons:add mongohq:small -r production"
    system "heroku config:add BUNDLE_WITHOUT='development:test' -r production"
  end

  if config['staging']
    staging_name = "#{heroku_name}-staging"
    say_wizard "Creating staging Heroku app '#{staging_name}.heroku.com'"
    while !system("heroku create #{staging_name} -r staging -s cedar")
      staging_name = ask_wizard("What do you want to call your staging app?")
    end
    # Staging setup
    system "heroku addons:add sendgrid:starter -r staging"
    system "heroku addons:add memcache:5mb -r staging"
    system "heroku addons:add mongohq:free -r staging"
    system "heroku config:add BUNDLE_WITHOUT='development:test' -r staging"
    system "heroku config:add RACK_ENV='staging' -r staging"
    say_wizard "Created remotes 'production' and 'staging' for Heroku deploy."
  end

  unless config['domain'].blank?
    run "heroku addons:add custom_domains -r production"
    run "heroku domains:add #{config['domain']} -r production"
  end


  git :push => "staging master" if config['deploy']
end

@current_recipe = nil

# >-----------------------------[ Run Bundler ]-------------------------------<

say_wizard "Running Bundler install. This will take a while."
run 'bundle install'
say_wizard "Running after Bundler callbacks."
@after_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

@current_recipe = nil
say_wizard "Running after everything callbacks."
@after_everything_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}
