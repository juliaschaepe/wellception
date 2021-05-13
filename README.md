# Access sherlock GPU-enabled notebooks locally
## Setup
1. Clone this repository locally. Navigate to a location on your local machine where you want to clone the repository. Use the command `git clone https://github.com/juliaschaepe/wellception.git`.
2. Navigate to the `params_deepcell.sh` file in the forward folder. Edit the first line of the file to include your suid `FORWARD_USERNAME="jschaepe"`. Next, pick a port to use.  If someone else is port forwarding using that port already, this script will not work. If you pick a random number in the range 49152-65335, you should be good. Edit `params_deepcell.sh` to include your chosen port `PORT="59339"`.
3. Copy the `organoid_processor.ipynb` to your sherlock account with scp using the following command `scp organoid_processor.ipynb jschaepe@login.sherlock.stanford.edu:~/<location_for_file>`, replacing jschaepe with your suid. You will also need a file `organoid_resnet50.h5` in order to run the organoid-trained deepcell model. Contact me to have it sent since it is a large file (303.2 MB). Be sure that it is fully downloaded by checking the file size before using scp to copy it up to Sherlock.
4. You will also need to at the minimum configure your ssh to recognize sherlock as a valid host. There is a script that will generate recommended ssh configuration snippets to put in your `~/.ssh/config` file. Here is how you can generate this configuration for Sherlock:

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

If you don't have a file in the location `~/.ssh/config` then you can generate it programatically, but do not run this command if there is content in the file that you might overwrite!

```bash
bash hosts/sherlock_ssh.sh >> ~/.ssh/config
``` 
5. Login to your sherlock account. Load python3.6 by running the command `ml python/3.6.1`. Pip install deepcell by running `pip install --user deepcell`.
6. If you have not set up notebook authentification before, you will need to set a password via `jupyter notebook password` on your sherlock account. Make sure to pick a secure password! If you run into an error of invalid password, navigate to `~/.jupyter` on your sherlock account and look at the `jupyter_notebook_config.json` file. If your hashed password starts with `argon2`, you will need to rehash this password yourself by opening an ipython session in Sherlock by with `ipython` and then using the following commands:
```
from notebook.auth import passwd
password=‘your_password’
passwd(password, ‘sha1’)
```
Copy the output of this last command (e.g. `sha1:eb13d589486a:b852385152418fc49e9f2089262d402ce02d1bfe`). Open `jupyter_notebook_config.json`, delete only what is in the double parentheses to look like this `"password": ""` and then paste your output so it looks like this `"password": "sha1:eb13d589486a:b852385152418fc49e9f2089262d402ce02d1bfe"`. Be sure not to edit anything outside of the double parentheses or add any spaces.

## Running a job to access deepcell notebook
1. Navigate to the forward folder. Run the command `bash start_deepcell.sh py3-tensorflow`. Enter your sherlock password when prompted. This requests GPU resources on sherlock, runs a tensorflow container, and starts a jupyter notebook which is then port forwarded to your local machine. You can follow the instructions on your local terminal and copy the port link, for example `http://localhost:59338/`, and paste it in your browser. This now interfaces like a typical jupyter notebook.
2. Open `organoid_processor.ipynb`. Run the first cell that loads libraries. If there are any errors loading libraries, you can pip install that library in sherlock like in Setup part 4. You should also see a print output indicating that tensorflow registered a GPU, for example `[PhysicalDevice(name='/physical_device:GPU:0', device_type='GPU')]` from the first cell.
## Changing sherlock jobs 
1. If you need to change the parameters of your sherlock job, for example how long you need the GPU for, you can edit the `params_deepcell.sh` file to reflect that. For processing an entire experiment, you will likely need at least a day `24:00:00`. The maximum time that you can request on Sherlock is 2 days, `48:00:00`.
