PS C:\Users\The-Biggest-Chungus\Documents\metasploitable3\chef\cookbooks\metasploitable\recipes> Get-ChildItem -Recurse .\ | Select-String "docker"

docker.rb:3:# Recipe:: docker
docker.rb:6:docker_service 'default' do
docker.rb:10:  group 'docker'
docker.rb:13:group 'docker' do
docker.rb:16:  members node[:metasploitable][:docker_users]
flags.rb:22:include_recipe 'metasploitable::docker'
flags.rb:24:directory '/opt/docker' do
flags.rb:28:cookbook_file '/opt/docker/Dockerfile' do
flags.rb:29:  source '/flags/Dockerfile'
flags.rb:33:cookbook_file '/opt/docker/7_of_diamonds.zip' do
flags.rb:38:docker_image '7_of_diamonds' do
flags.rb:40:    source '/opt/docker/'
flags.rb:43:docker_container '7_of_diamonds' do
flags.rb:50:file '/opt/docker/7_of_diamonds.zip' do

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
