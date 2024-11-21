USER=$1
KEY_PATH=$2
INI_PATH=$3
NODES_FILE=$4

touch $NODES_FILE

aws ec2 describe-instances \
    --region us-west-2 \
    --filters "Name=tag:Name,Values=k8s-node*" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value, PublicIpAddress:PublicIpAddress}" \
    --output json | jq -r '[.[][]] | sort_by(.Name)' > $NODES_FILE

# Create [all] Group
echo -e "[all]" >> $INI_PATH

for i in $(jq -r '.[].Name' $NODES_FILE); do
    IP=$(jq -r --arg i "$i" '.[] | select(.Name == $i) | .PublicIpAddress' $NODES_FILE)
    LINE="$i ansible_host=$IP ansible_user=$USER ansible_ssh_private_key_file=$KEY_PATH ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
    echo $LINE >> $INI_PATH
done

echo -e "\n" >> $INI_PATH

# Create [kube_masters] Group
echo "[kube_masters]" >> $INI_PATH

IP=$(jq -r --arg i "$i" '.[] | select(.Name == "k8s-node-1") | .PublicIpAddress' $NODES_FILE)
LINE="k8s-node-1 ansible_host=$IP ansible_user=$USER ansible_ssh_private_key_file=$KEY_PATH ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
echo $LINE >> $INI_PATH

echo -e "\n" >> $INI_PATH

# Create [kube_workers] Group
echo "[kube_workers]" >> $INI_PATH

for i in $(jq -r '.[].Name' $NODES_FILE | grep -v k8s-node-1); do
    IP=$(jq -r --arg i "$i" '.[] | select(.Name == $i) | .PublicIpAddress' $NODES_FILE)
    LINE="$i ansible_host=$IP ansible_user=$USER ansible_ssh_private_key_file=$KEY_PATH ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
    echo $LINE >> $INI_PATH
done
