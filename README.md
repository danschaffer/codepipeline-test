# codepipeline-test

Sample project to test deploying a dummy web site through codepipeline with
codebuild.  The buildspec.yml instructs codepipeline to deploy the website to
an s3 bucket.  By creating a oauth token each update to the repo triggers a
run of codepipeline to redeploy the site.
