terraform {
    backend "s3" {
        bucket = "resume-backend-state"
        key = "terraform.tfstate"
        region = "eu-west-1"
        use_lockfile = true
        encrypt = true      
    }
}

# notes:
# this set up is great since it is only myself that effect changes on state.
# however, in a situation where i work in a team, then the standard setup would be s3 + dynamodb
