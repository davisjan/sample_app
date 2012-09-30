namespace :bundle do
  desc "Bundle install"
  task :install do 
    sh "bundle install --path=~/.gem/ruby/1.8 --without staging:production"
  end
end
