DNS -> ALB -> http:80 -redirect-to- https:443 -> ACM(SSL Termination) -> ECS:container_port -> Autoscaling EC2 (ASG) -> RDS

#### Setup AWS profile+region for Terraform and ECR
```
export AWS_ACCESS_KEY_ID="AK................................KMZ" && \
   export AWS_SECRET_ACCESS_KEY="K7J..............................................Tnfj" && \
   export AWS_REGION="us-west-2" && \
   export TF_VAR_aws_region="us-west-2"
```
#### Apply the Terraform configs for ECR
`terraform apply -target="module.ecr"`
#### Get AWS ECR repo url from Terraform output
`export REPO=$(terraform output --raw ecr_repo_url)`
#### Login to AWS ECR
`aws ecr get-login-password | docker login --username AWS --password-stdin $REPO`
#### Build docker image & push to your ECR
```
git clone git@github.com:mrprmode/mountains.git && cd mountains
docker build -t mountains . && docker tag mountains $REPO && docker push $REPO
```
#### [Optional] Local Cleanup
`cd .. && rm -rf mountains && docker image rm $REPO && docker image rm mountains`
#### Edit `terraform.tfvars`: DB stuff that your application needs, RDS `MySQL` parameters to be set up with and the the container_port (default:80)
```
# container_port = 3000
db_username = "YuYingNan"
db_password = "ShiSheng8848"
db_database = "TheZuMountainSaga"
```
or `terraform apply -var db_username="some_name" -var db_password="some_pwd" ...........`
#### Your docker application must use the DB parameters as the following Env Variables:
```
DB_USER
DB_PWD
DB_DATABASE
DB_HOST
```
#### Apply the Terraform configs
`terraform apply`
