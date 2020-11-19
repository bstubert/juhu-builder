PWD:=$(shell pwd)

sync_repo:
	repo init -u https://git.seco.com/pub/i.mx/yocto/seco-yocto-manifest.git -m seco-imx-4.19.35-1.0.0.xml && \
	repo sync

build_docker:
	docker build --build-arg "host_uid=$(shell id -u)" \
	--build-arg "host_gid=$(shell id -g)" -t dr-yocto .

run_container:
	docker run -it --rm \
	-v ${PWD}:/public/Work dr-yocto

ssh_aws_ami:
	ssh -i ~/Documents/Yocto-builder-key-pair.pem \
	ubuntu@ec2-54-146-204-211.compute-1.amazonaws.com


# TODO: find running instance id so that we can ssh into it
# list_running_instances:
# 	aws ec2 describe-instances \
# 	--filters "Name=image-id, Values=ami-0989a20e0b5746898" \
# 	--filters "Name=state.name, Values=running" \
# 	--query "Reservations[].Instances[].InstanceId"

# start_new_aws_yocto-builder_instance:
# 	aws ec2 run-instances --image-id ami-0989a20e0b5746898 --instance-type m5.2xlarge

start_yocto-builder_ami:
	aws ec2 start-instances --instance-ids i-073ef69a8d3a27779

# TODO: RUN INSIDE CONTAINER
# run_source_setup:
# 	source seco-setup.sh -m seco-sbc-a62 -r 1G_4x256M \
# 	-d seco-imx-x11 -b build -f docker,chromium
