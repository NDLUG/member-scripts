# Notre Dame Linux User Group --- Script Repository

Members can collaborate and share scripts here that might be too short for their own repository, but that they want to share with everyone.
On February 27th 2019, we're going to give a talk on a little bit of the idea behind this, and let people present for a few minutes about the various scripts they've added.

## Ways to use these scripts

After cloning this repository, you can use the scripts directly from this directory.
But if you're using it very often, it might be tiresome to `cd` here or use longer paths to the scripts.

You can add this directory to your path [like so](https://www.techrepublic.com/article/how-to-add-directories-to-your-path-in-linux/).

You can add a soft link from somewhere already in your path to here [like so](https://www.cyberciti.biz/faq/creating-soft-link-or-symbolic-link/).
Soft links look like a copy of the file, but if the original is changed, it will change the link as well.
That way, if you want to get updates to these scripts, you can just `git pull` here, and all of your links should point to the updated scripts, no hassle.
_(Assuming that the commit didn't rename the script you linked to)_

## How to contribute: Pull Requests

Open source thrives when many people contribute to the development of code.  In order to facilitate the collaboration on code between many different groups and individuals, you can "fork" this package, clone your copy, make changes, and then do a pull request so we can merge your improvements in, or if your code isn't quite ready, we'll help you fix any issues on the pull request discussion page.  See [here](https://www.digitalocean.com/community/tutorials/how-to-create-a-pull-request-on-github) for a few more details.

Contributions of many types are welcome.
 - Add a helpful script you made that you use frequently, and think others could gain use from!
 - Find a bug in an existing script here?  If you can fix it, send us a pull request so we get the updated version too!
 - Do you think that some script needs better documentation on usage, or installation, or anything like that?  Docs are super important to open source, and contributions like these help a ton.
 - For now the files here don't have a lot of structure, which works now when they're all simple, and there's few of them.  But if we have more scripts soon, we'll need a way of organizing this repository.  If you make a pull request to start the convention and it's a reasonable one, we'll merge it in and make sure contributions thereafter follow something similar.
 - Even if it isn't listed here, go for it -- we'll help you out with feedback if anything needs to be changed. (:
