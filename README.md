# How to deploy PhotoSite on Amazon AWS EC2
## Table of Contents
1. [Setup Amazon EC2](#1-setup-amazon-ec2)
2. [Build environment on your EC2](#2-build-environment-on-your-ec2)
  2. [Configure with ruby & ruby on rails](#configure)
3. [Run your code on EC2](#3-run-your-code-on-ec2)
4. [Adv - Why my stuffs disappeared after I stopped my EC2?! What shall I do?](#4-adv---why-my-stuffs-disappeared-after-i-stopped-my-ec2-what-shall-i-do)
5. [Adv - How to get access to my website despite the IP address of EC2 changes?](#5-adv---how-to-get-access-to-my-website-despite-the-ip-address-of-ec2-changes)
  5. [Option A - Use load balancer](#option-a---use-load-balancer)
  5. [Option B - Use Elastic IP](#option-b---use-elastic-ip)
<br>

## 1. Setup Amazon EC2
To Deploy it on AWS EC2, the first thing is to register a AWS account and bind it with a card. I just skip this part.
Then, go to EC2 and press “Launch Instance”.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_0.png" width="300px"><br>
Choose the AMI as follows. Or, any Linux AMI if you wish.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_1.png"><br>
Then, choose any instance type with “Free tier eligible”<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_2.png"><br>
Then, press “Review And Launch”. Create a new key pair whatever it’s name.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_3.png"><br>
Save it to a safe place on your local machine. It’s the **ONLY** login credential to the EC2 instance.<br>
Then, go to your *.pem folder. Typing the following command in terminal.<br>
```
chmod 400 projectr2.pem
```
Then, click on the “Connect” to copy and paste the ssh command to your local terminal in order to manage your EC2 instance through terminal.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_4.png" width="300px"><br>
Like:<br>
```
ssh -i "projectr2.pem" ec2-user@ec2-54-219-128-123.us-west-1.compute.amazonaws.com
```

## 2. Build environment on your EC2
Claim: I’m using **yum** here. Potentially, you can use **apt-get** instead in some certain version of Linux. <br>
In the ssh terminal, begin with:<br>
```
sudo yum update
```

Then, we need git to import our code into EC2:<br>
```
sudo yum install git
```

Install a Javascript runtime. Node.js at this example:
```
sudo yum install nodejs npm --enablerepo=epel
```
<a name = "configure" />
**Configure with ruby & ruby on rails**<br>
Then, import public key in order to install rvm:<br>
```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```
install rvm through curl:<br>
```
\curl -L https://get.rvm.io | bash -s stable
```
Update your terminal to use rvm shortcut command:<br>
```
source ~/.rvm/scripts/rvm
```
Check requirements before update to the newest version of ruby:<br>
```
rvm requirements
```

Now let’s install ruby:<br>
```
rvm install ruby
```

Make the newly installed ruby as our default one:<br>
```
rvm use ruby --default
```

Then, update ruby gems to the newest version:<br>
```
rvm rubygems current
```

Now, let’s install rails!<br>
```
gem install rails
```
Bing! You are all set for the EC2. Now let’s import our code into EC2.<br>

## 3. Run your code on EC2
We need to use github. Register an account and push the code to the github. Or, we can use the following code directly.https://github.com/Tony-Hu/PhotoSite<br>  
Go to your EC2 ssh terminal, and clone the code from that git repo.<br>
```
git clone https://github.com/Tony-Hu/PhotoSite
```

Then go into your cloned folder:<br>
```
cd PhotoSite
```

And install additional bundles for the rails:<br>
```
bundle install
```

Then, migrate all the data:<br>
```
rake db:migrate
```

Then, type the command to run the server on specified port:<br>
```
rails s -p 3000 -b 0.0.0.0
```
Where **p** is the port you wish to use. ``-b 0.0.0.0`` you can’t get rid of it.<br>

However, that’s not enough. If you go to **your-EC2-IP:3000**. The browser will keep looping. Let’s change the security group configuration. Scroll to the most right of your AWS EC2 list. Click on the security group bind with your EC2 instance.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_5.png"><br>
Press “Inbound” -> “Edit” at bottom. Then, press “Add rule”. with the configuration below:<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_6.png"><br>
Save. And access/refresh the link: **your-EC2-IP:3000**. Then, it’s there. Done! Notice that, DO NOT shut down your EC2 instance before you make an AMI! Otherwise, you have to redo these steps every time!<br>

## 4. Adv - Why my stuffs disappeared after I stopped my EC2?! What shall I do?
To prevent re-setup for our environment and data. We can create our own AMI.
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_7.png" width="400px"><br>
Just right click on your running EC2 instance, and go to “Image” -> ”Create Image”. Notice that, your EC2 instance will be shutdown during image creation process.<br>
After 1~10 minutes, your AMI is ready to put into use. Click on “Image” => “AMIs”
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_8.png" width="300px"><br>
You can see your just created AMI is there.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_9.png" width="300px"><br>
Let’s press “Launch” as we are configuring a new EC2 instance like we have done before. Potentially you can add this instance into the existing security group.<br>
After several minutes for setting up new instance. We are free to access that instance through ssh terminal. Let’s login and check. Oop! All your stuffs are there. just<br>
```
cd PhotoSite
```
And then, run the rails service directly,<br>
```
rails s -p 3000 -b 0.0.0.0
```
And let’s check to **that-EC2-IP:3000**. Bingo! It’s working!<br>
Now, you are free to turn off any EC2 instance if you like!.<br>

## 5. Adv - How to get access to my website despite the IP address of EC2 changes?
### Option A - Use load balancer
Although you have a way to save your configured environment and data. Your EC2 instances keep change their public IP address once we restart it. Like the example shown below:<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_10.png" width="300px"><br>
The first instance change it’s IP from ``52.53.176.23`` to ``54.183.207.43``. And it’s DNS name also get changed.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_11.png" width="300px"><br>
How to deal with this stuff? One way to deal with it is called “Load Balancer” through EC2 console.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_12.png" width="300px"><br>
Let’s create an “Application Load Balancer”.<br>
Let’s set it’s “Load Balancer Port” to ``3000``.<br>
Then select all Availability Zones.<br>
In “Configure Security Groups” page, choose the existing security group ``“launch-wizard-2”``.<br>
Then, set the port to 3000 in “Configure Routing”.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_13.png" width="400px"><br>
Then, add all instances to registered.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_14.png" width="300px"><br>
And click on finish. <br>
After several minutes, you can access your website from the following **DNS name:3000**.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_15.png" width="300px"><br>
For me, I can access my photo site through http://test-1773954556.us-west-1.elb.amazonaws.com:3000/ and http://photositeloadbalancer-1901898632.us-west-1.elb.amazonaws.com:3000/ as long as at least one of my EC2 instance is running and has rails service on.<br>

### Option B - Use [Elastic IP](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)
Go to EC2 console, Press on the Elastic IPs.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_16.png" width="200px"><br>
And press “Allocate new addresses”. Now you get an address. Right click on that address item, and choose “Associate address”. Now, you can choose the instance you would like to assign your IP with.
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_17.png" width="500px"><br>

Now, we have our instance bind with a “static” IP address. You can stop/restart your instance any time if you like without changing its public IP address.<br>
<img src="https://raw.githubusercontent.com/Tony-Hu/PhotoSite/master/tutorial_pics/2018_04_17-19_08_52_18.png" width="300px"><br>
<br>
<br>
## End
A useful EC2 RoR tutorial: https://www.youtube.com/watch?v=jFBbcleSPoY
