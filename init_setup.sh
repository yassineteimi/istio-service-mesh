echo [$(date)]: "START"
export _VERSION_=3.8
echo [$(date)]: "creating environment with python ${_VERSION_}"
#conda create --prefix ./env python=${_VERSION_} -y
python3 -m venv ./env
echo [$(date)]: "activate environment"
#conda init
#conda activate ./env
source ./env/bin/activate
echo [$(date)]: "install requirements"
pip3 install -r requirements.txt
echo [$(date)]: "END"

# to remove everything -
# rm -rf env/ .gitignore conda.yaml README.md .git/