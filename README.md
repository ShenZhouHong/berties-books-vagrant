# IS53064A: DB&Web Bertie's Books Template with Vagrant.
This git project contains the starter code for IS53064A Database & Web's *Bertie's Books* project. It has been modified to use the [Vagrant](https://www.vagrantup.com/) development environment provisioning tool, in order to simplify the setup of the project's development environment.

The Bertie's Books project is a nodejs project that requires Node, NPM, and MySQL. It can be difficult for new students to download and configure these dependencies, particularly if they have different operating systems. This repository aims to simplify the effort, by providing an Ubuntu 22.04 ("Jammy Jellyfish") virtual machine with all of the dependencies pre-configured, so that the student can start programming immediately. 

In order to do so, this project makes use of Vagrant, a tool which is used to define a reproducible virtual machine environment in a configuration file (called an `Vagrantfile`), and then recreate the same environment on different computers. All work can be then done inside the virtual machine, which allows the student to abstract away operating system specific quirks and incompatibilities.

## Setup
In order to use this project, first clone the repository onto your local machine.

```
git clone https://github.com/ShenZhouHong/berties-books-vagrant.git
cd berties-books-vagrant
```


### Define secrets in `.env` file

All secrets (e.g. passwords) in this project are managed using an `.env` file. `.env` stands for *env*ironment variable, denoting variables that are available to a script or program from its execution environment.

By placing secrets in an external `.env` file, we can avoid hardcoding secrets in many places throughout the codebase. Additionally, these secrets can be placed outside of version control, allowing greater security.

Hence, in order to begin, we must first define the `.env` file. Open the empty `.env` file and fill in the secrets. An example is provided below:

```bash
MYSQL_HOST="localhost"
MYSQL_USERNAME="appuser"
MYSQL_PASSWORD="PUT-YOUR-MYSQL-APP-PASSWORD-HERE"
MYSQL_DATABASE="myBookshop"
MYSQL_ROOT_PW="PUT-YOUR-MYSQL-ROOT-PASSWORD-HERE"
```

Please make sure to fill out the `.env` file! Otherwise the subsequent steps *will not work*.

### Install dev dependencies
Next, we must install the Vagrant provisioning tool. More detailed [operating system specific instructions](https://www.vagrantup.com/downloads) can be found on the Vagrant webpage.

#### For Ubuntu and Debian

On Ubuntu and Debian, we may install Virtualbox and Vagrant in one step using apt:

```bash
sudo apt update
sudo apt install -y vagrant virtualbox
```

#### For Mac OS

For Mac OS, we must first install Virtualbox **verison 6.1**. It is very important to *not* install Virtualbox 7.0, as Vagrant does not support it on Mac OS machines. 

Visit the Virtualbox 6.1 builds page at the link below:

* [Virtualbox 6.1 Builds](https://www.virtualbox.org/wiki/Download_Old_Builds_6_1)

Click on the link that says **OS X Hosts**. This should initialise a download. Install Virtualbox using the package file inside the `.dmg`.

After installation, you may have to open your Security Settings, and allow Kernel drivers for Mac OS to be installed. To do so, navigate to your Preferences > Security & Privacy Setting, and follow the on-screen instructions.

Once Virtualbox is properly installed, we may install Vagrant with Homebrew:

```zsh
brew install vagrant
```

### Initialise development VM

Once Vagrant is installed and available on the local machine, we will be able to initialise the development environment. The VM is defined in the `Vagrantfile`. We do this by running the following command:

```bash
vagrant up
```

Vagrant will automatically provision the environment, by running a bash script called `./setup.sh` located in the project's root directory. This bash script completes the following actions:

* It downloads `nodejs`, `npm`, and `mysql`
* Installs nodejs-specific dependencies in the project directory (located on the virtual machine as `/vagrant/`) using `npm install`.
* Configures the MySQL root user with a password specified in `.env`
* Sets up the project databases.

## Accessing Development Virtual Machine

After the Vagrant VM is provisioned (using the above steps), we may access over SSH via:

```bash
vagrant ssh
```

By default, the project directory (i.e. where the files in the git repository are located) is mounted at the `/vagrant` directory. Change directory to the location with:

```bash
cd /vagrant
```

From here, you may immediately run the nodejs project. The MySQL database connection has already been configured using parameters in the `.env` file.

```bash
nodejs index.js
```

Now your project should be available at port 8000 on localhost. This is accessible over the web browser of the local machine:

```
http://localhost:8000/
```

## Exiting, Stopping, and Destroying the Development VM

Here is a quick command reference for managing virtual machines with Vagrant. For more information, see the [Vagrant command reference](https://www.vagrantup.com/docs/cli).

### Exiting SSH session
In order to exit out of the SSH session with the Vagrant VM, simply run:

```bash
exit
```

This will exit the SSH session and leave the user in the local machine's shell. To re-enter the VM, simply run `vagrant ssh` again.

Note: for the following commands, you must run them in the local machine's context, i.e. once you have exited the vagrant VM's SSH session.

### Suspending the virtual machine

In order to *suspend* the VM, run:

```bash
vagrant suspend
```

This command effectively freezes the VM at that instant in time, saving its memory to disk. It can then be resumed.

### Resuming the virtual machine

```bash
vagrant resume
```

This command *resumes* a suspended VM. You can then `vagrant ssh` into it again. It is good to use `vagrant suspend` and `vagrant resume`, since this will skip the downloading packages and provisioning step, which can take a lot of time.

### Destroying the virtual machine

If for any reason, the Vagrant VM must be reset to its original state, as defined in the `Vagrantfile` and `setup.sh`, you may *destroy* the VM using:

```bash
vagrant destroy
```

All data that is *outside* the `/vagrant/` directory will be lost. In order to recreate the VM, you must run `vagrant up` again.

## Further Reference

* https://www.vagrantup.com/docs
* https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-22-04
