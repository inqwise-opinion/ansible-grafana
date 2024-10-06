# vagrant up --provider=aws
# vagrant destroy -f && vagrant up --provider=aws

MAIN_SCRIPT_URL = "https://raw.githubusercontent.com/inqwise/ansible-automation-toolkit/default/main_amzn2023.sh"
TOPIC_NAME = "errors"
ACCOUNT_ID = "992382682634"
AWS_REGION = "il-central-1"
NODE_COUNT = 1
MAIN_SH_ARGS = <<MARKER
-e "playbook_name=ansible-grafana discord_message_owner_name=#{Etc.getpwuid(Process.uid).name}"
MARKER
Vagrant.configure("2") do |config|
  (1..NODE_COUNT).each do |i|
    config.vm.define "node#{i}" do |subconfig|
      subconfig.vm.provision "shell", inline: <<-SHELL
    # set -euxo pipefail
    # echo "start vagrant file"
    # source /deployment/ansibleenv/bin/activate
    # cd /deployment/playbook
    # export ANSIBLE_VERBOSITY=0
    # export ANSIBLE_DISPLAY_SKIPPED_HOSTS=false
    # export VAULT_PASSWORD=#{`op read "op://Security/ansible-vault inqwise-opinion-stg/password"`.strip!}
    # echo "$VAULT_PASSWORD" > vault_password
    # bash main.sh #{MAIN_SH_ARGS}
    # rm vault_password

    set -euxo pipefail
    echo "start vagrant file"
    python3 -m venv /tmp/ansibleenv
    source /tmp/ansibleenv/bin/activate
    aws s3 cp s3://resource-opinion-stg/get-pip.py - | python3
    cd /vagrant
    export VAULT_PASSWORD=#{`op read "op://Security/ansible-vault inqwise-opinion-stg/password"`.strip!}
    echo "$VAULT_PASSWORD" > vault_password
    export ANSIBLE_VERBOSITY=0
    if [ ! -f "main.sh" ]; then
    echo "Local main.sh not found. Download main.sh script from URL..."
    curl -s https://raw.githubusercontent.com/inqwise/ansible-automation-toolkit/default/main_amzn2023.sh -o main.sh
    fi
    bash main.sh #{MAIN_SH_ARGS}
    rm vault_password
      SHELL

  config.vm.provider :aws do |aws, override|
  	override.vm.box = "dummy"
    override.ssh.username = "ec2-user"
    override.ssh.private_key_path = "~/.ssh/id_rsa"
    aws.aws_dir = ENV['HOME'] + "/.aws/"
    aws.aws_profile = "opinion-stg"
  
    aws.keypair_name = Etc.getpwuid(Process.uid).name
    override.vm.allowed_synced_folder_types = [:rsync]
    override.vm.synced_folder ".", "/vagrant", type: :rsync, rsync__exclude: ['.git/','inqwise/'], disabled: false
    common_collection_path = ENV['COMMON_COLLECTION_PATH'] || '~/git/ansible-common-collection'
    stacktrek_collection_path = ENV['STACKTREK_COLLECTION_PATH'] || '~/git/ansible-stack-trek'
    override.vm.synced_folder common_collection_path, '/vagrant/collections/ansible_collections/inqwise/common', type: :rsync, rsync__exclude: '.git/', disabled: false
    override.vm.synced_folder stacktrek_collection_path, '/vagrant/collections/ansible_collections/inqwise/stacktrek', type: :rsync, rsync__exclude: '.git/', disabled: false            
    
        aws.region = AWS_REGION
        aws.security_groups = ["sg-020afd8fd0fa9fd0b","sg-0ff15e7ac38d283c1"]
            # public-ssh, grafana
        aws.ami = "ami-0b864da052af97955"
        aws.instance_type = "t4g.small"
        aws.subnet_id = "subnet-0f46c97c53ea11e2e"
        aws.associate_public_ip = true
        aws.iam_instance_profile_name = "bootstrap-role"
        aws.tags = {
          Name: "grafana-test#{i}-#{Etc.getpwuid(Process.uid).name}",
          private_dns: "grafana-test-#{Etc.getpwuid(Process.uid).name}",
	  playbookname: "ansible-grafana",
	  version: "latest",
	  app: "grafana",
        }
      end
    end
  end
end
