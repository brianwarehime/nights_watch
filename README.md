# nights_watch
Easy to use GuardDuty alerting with the help of Terraform and Slack

There is a blog post written about the process for getting started, but if you just want to know the basic pieces to get started, here's what you need to do:

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
