namespace :bundle do
  desc "Bundle install"
  task :install => environment do
    sh 'bundle install --path=~/.gem/ruby/1.8"
  end
end
