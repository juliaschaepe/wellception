# Access sherlock GPU-enabled notebooks locally
## Setup
1. Clone this repository locally. Navigate to a location on your local machine where you want to clone the repository. Use the command `git clone https://github.com/juliaschaepe/wellception.git`.
2. Navigate to the `params_deepcell.sh` file in the forward folder. Edit the first line of the file to include your suid `FORWARD_USERNAME="jschaepe"`.
3. Copy the `organoid_processor.ipynb` to your sherlock account with scp using the following command `scp organoid_processor.ipynb jschaepe@login.sherlock.stanford.edu:~/<location_for_file>`, replacing jschaepe with your suid.
4. You will also need to at the minimum configure your ssh to recognize sherlock as
a valid host. There is a script that will generate recommended ssh configuration snippets to put in your `~/.ssh/config` file. Here is how you can generate this configuration for Sherlock:

```bash
bash hosts/sherlock_ssh.sh
```
```
Host sherlock
    User put_your_username_here
    Hostname sh-ln01.stanford.edu
    GSSAPIDelegateCredentials yes
    GSSAPIAuthentication yes
    ControlMaster auto
    ControlPersist yes
    ControlPath ~/.ssh/%l%r@%h:%p
```

If you don't have a file in the location `~/.ssh/config` then you can generate it programatically:

```bash
bash hosts/sherlock_ssh.sh >> ~/.ssh/config
```

Do not run this command if there is content in the file that you might overwrite! 
One downside is that you will be foregoing sherlock's load
balancing since you need to be connecting to the same login machine at each
step.
5. Login to your sherlock account. Load python3.6 by running the command `ml python/3.6.1`. Pip install deepcell by running `pip install --user deepcell`.
6. If you have not set up notebook authentification before, you will need to set a password via `jupyter notebook password` on your sherlock account. Make sure to pick a secure password!
## Running a job to access deepcell notebook
1. Navigate to the forward folder. Run the command `bash start_deepcell.sh py3-tensorflow`. Enter your sherlock password when prompted. This requests GPU resources on sherlock, runs a tensorflow container, and starts a jupyter notebook which is then port forwarded to your local machine. You can follow the instructions on your local terminal and copy the port link, for example `http://localhost:59338/`, and paste it in your browser. This now interfaces like a typical jupyter notebook.
2. Open `organoid_processor.ipynb`. Run the first cell that loads libraries. If there are any errors loading libraries, you can pip install that library in sherlock like in Setup part 4. You should also see a print output indicating that tensorflow registered a GPU, for example `[PhysicalDevice(name='/physical_device:GPU:0', device_type='GPU')]` from the first cell.
## Changing sherlock jobs 
1. If you need to change the parameters of your sherlock job, for example how long you need the GPU for, you can edit the `params_deepcell.sh` file to reflect that.
