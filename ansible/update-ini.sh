USER=$1

touch /tmp/nodes.json

aws ec2 describe-instances \
    --region us-west-2 \
    --filters "Name=tag:Name,Values=k8s-node*" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value, PublicIpAddress:PublicIpAddress}" \
    --output json | jq -r '[.[][]] | sort_by(.Name)' > /tmp/nodes.json

# Create [all] Group
echo -e "[all]" >> /tmp/project.ini

for i in $(jq -r '.[].Name' /tmp/nodes.json); do
    IP=$(jq -r --arg i "$i" '.[] | select(.Name == $i) | .PublicIpAddress' /tmp/nodes.json)
    LINE="$i ansible_host=$IP ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
    echo $LINE >> /tmp/project.ini
done

echo -e "\n" >> /tmp/project.ini

# Create [kube_masters] Group
echo "[kube_masters]" >> /tmp/project.ini

IP=$(jq -r --arg i "$i" '.[] | select(.Name == "k8s-node-1") | .PublicIpAddress' /tmp/nodes.json)
LINE="k8s-node-1 ansible_host=$IP ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
echo $LINE >> /tmp/project.ini

echo -e "\n" >> /tmp/project.ini

# Create [kube_workers] Group
echo "[kube_workers]" >> /tmp/project.ini

for i in $(jq -r '.[].Name' /tmp/nodes.json | grep -v k8s-node-1); do
    IP=$(jq -r --arg i "$i" '.[] | select(.Name == $i) | .PublicIpAddress' /tmp/nodes.json)
    LINE="$i ansible_host=$IP ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
    echo $LINE >> /tmp/project.ini
done
