# nights_watch
Easy to use GuardDuty alerting with the help of Terraform and Slack

In many startups, getting started with security can be difficult. You need engineers to focus on a variety of projects, making sure your products are secure, ensure you are keeping your users safe, etc. Getting actionable alerts for issues going on in your AWS environment is just one part of the overall security program and can be a challenge in some cases. I wanted to make that process as easy as possible for teams, and have basically a “push-button” start for getting alerts in the right place. That’s where “Nights Watch” comes in! (I was thinking of names dealing with “guard” and being a GoT fan, I just chose this for the project name, I dunno…)

Before we get into details, there are a few assumptions I made with this project:

- This project uses Terraform to spin up the required components, so that may not work well in some environments that use another sort of configuration as code solution, like CloudFormation, depending on your deployment processes.
- This code assumes you have the necessary permissions on your account to deploy to AWS. If you try to run this, and run into errors, start looking into your permissions to see if you aren’t allowed to do certain things.
- You are using Slack. The output from this project is alerts going into Slack, so, if you are using any other platform to communicate, this won’t work out of the box.
- Lastly, you have valid AWS credentials in ~/.aws/credentials which is what Terraform will use to deploy the config.

With that being said, let’s dig into the details. To get started, you’ll need to pull down the source code on my Github.

```
$ git pull https://github.com/brianwarehime/nights_watch
$ cd nights_watch
```

Inside this directory you’ll see function.zip which is where the Lambda function is stored. The nights_watch.tf file contains all the Terraform configuration to set up the required services. There is also a variables.tf which initializes the variables we’ll need to use.

Before running the terraform commands, you’ll need to define at least one variable, which is for the Slack webhook that Lambda will post findings to. To generate the Slack webhook, you’ll need to navigate to https://`teamname`.slack.com/apps/manage/custom-integrations where `teamname` is your Slack team name. Next, click on Incoming Webhooks > Add Configuration. Enter the details for the channel you want these alerts to go to, and then click on Add Incoming Webhooks Integration. The URL that it generated is what you’ll want to enter into the terraform.tfvars file so it can send the GuardDuty alerts there. Just do the following:

```
$ echo 'slack_webhook = "<webhook_you_just_generated>"' >> terraform.tfvars
```

There is another variable you can enter in the terraform.tfvars file, which is event_threshold. This is used to exclude certain findings from GuardDuty that don’t meet the required severity. I recommend using a value of 2 in here to exclude noisy alerts. Feel free to play around with this value to find what works best for you though, however, any public facing instance you have will generate a large number of alerts that aren’t valuable (SSH scanning/brute-forcing, port probing, etc.) and make your channel incredibly noisy. There is a default value of 0 set in the variables.tf file, but if you want to follow my recommendation of excluding alerts with a severity of 2 or less, just do:

```
$ echo 'event_threshold = "2"' >> terraform.tfvars
```

Once you have your variables configured, you’ll now be able to start things up!

```
$ terraform init
$ terraform apply
```

After running terraform apply you’ll need to enter the region where you’ll be deploying. Follow the rest of the prompts and enter yes when asked to deploy and you’re all set!

To check that everything is working properly, navigate to https://us-east-1.console.aws.amazon.com/guardduty/home?region=us-east-1#/settings (make sure us-east-1 is the region you deployed to) and click on Generate Sample Findings. This will generate all the types of findings GuardDuty supports and send them to Slack in about ~5 minutes.

Sit back and wait for the findings to appear in your Slack channel, but please note you’ll probably get a message from Slack about rate limiting, so not every alert will come through that was tested, however, this at least indicates that every thing is working properly and you are getting alerts, which will look like this 👇

![alert](https://cdn-images-1.medium.com/max/1600/1*FrFj3hTSIr-dLko6LoF6zw.png)

That’s it! You’re all set, and now have somewhat decent coverage for AWS security issues that may impact you, and have instant alerting in Slack to respond to. Also one more note: I didn’t include many of the available fields from the alerts, since some of the fields may not be actionable directly from Slack, and in most cases you’ll need to pivot to the actual alert to get all the details you’d be interested in. If you have any feature requests for fields to add in here, or if you have any questions or issues, contact me at brian@nullsecure.org or on the Github repo.






















```
$ git pull https://github.com/brianwarehime/nights_watch
$ cd nights_watch
```

Before running the terraform commands, you'll need to define at least one variable, which is for the Slack webhook that Lambda will post findings to. To generate the Slack webhook, you'll need to navigate to https://`teamname`.slack.com/apps/manage/custom-integrations where `teamname` is your Slack team name. Next, click on Incoming Webhooks > Add Configuration. Enter the details for the channel you want these alerts to go to, and then click on Add Incoming Webhooks Integration. The URL that it generated is what you'll want to enter into the terraform.tfvars file so it can send the GuardDuty alerts there. Just do the following:

```
$ echo 'slack_webhook = "<webhook_you_just_generated>"' >> terraform.tfvars
$ terraform init
$ terraform apply
```

Those are the basic steps to get this working, however, I recommend checking out the blog post linked above for more information and recommendations.
