# 7 of Diamonds
include_recipe 'metasploitable::docker'

directory '/opt/docker' do
  mode '0770'
end

cookbook_file '/opt/docker/Dockerfile' do
  source '/flags/Dockerfile'
  mode '0700'
end

cookbook_file '/opt/docker/7_of_diamonds.zip' do
  source '/flags/7_of_diamonds.zip'
  mode '0700'
end

docker_image '7_of_diamonds' do
    action :build_if_missing
    source '/opt/docker/'
end

docker_container '7_of_diamonds' do
    action :run_if_missing
    restart_policy 'always'
    tty true
    open_stdin true
end

file '/opt/docker/7_of_diamonds.zip' do
  action :delete
end


---

"run_list": [
        "apt::default",
        "metasploitable::users",
        "metasploitable::mysql",
        "metasploitable::apache_continuum",
        "metasploitable::apache",
        "metasploitable::php_545",
        "metasploitable::phpmyadmin",
        "metasploitable::proftpd",
        "metasploitable::docker",
        "metasploitable::samba",
        "metasploitable::sinatra",
        "metasploitable::unrealircd",
        "metasploitable::chatbot",
        "metasploitable::payroll_app",
        "metasploitable::readme_app",
        "metasploitable::cups",
        "metasploitable::drupal",
        "metasploitable::knockd",
        "metasploitable::iptables",
        "metasploitable::flags",
        "metasploitable::ifnames"
      ]
    }


---

  drupal.rb:73:  source 'flags/5_of_hearts.png'
drupal.rb:78:  source 'flags/5_of_hearts.png'
flags.rb:3:# Recipe:: flags
flags.rb:15:  source 'flags/10_of_clubs.wav'
flags.rb:29:  source '/flags/Dockerfile'
flags.rb:34:  source '/flags/7_of_diamonds.zip'
flags.rb:54:# Easy mode flags
flags.rb:59:  source 'flags/flag_images/10 of spades.png'
flags.rb:77:  source 'flags/flag_images/8 of clubs.png'
flags.rb:85:  source 'flags/flag_images/3 of hearts.png'
flags.rb:97:  source 'flags/my_recordings_do_not_open.iso'
flags.rb:107:# Hard mode flags
flags.rb:117:    source 'flags/five_of_diamonds'
flags.rb:122:    source 'flags/five_of_diamonds_srv'
flags.rb:132:    source 'flags/2_of_spades.pcapng'
flags.rb:144:    mysql -h 127.0.0.1 --user="root" --password="sploitme" super_secret_db <
#{File.join(Chef::Config[:file_cache_path], 'cookbooks', 'metasploitable', 'files', 'flags', 'super_secret_db.sql')}
flags.rb:151:    source 'flags/joker.png'
knockd.rb:26:  lines "-I FORWARD 1 -p tcp -m tcp --dport #{node[:flags][:five_of_diamonds][:vuln_port]} -j DROP"
