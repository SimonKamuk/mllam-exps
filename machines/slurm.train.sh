#!/bin/bash -l
#SBATCH --job-name=HAS-NeuralLam
#SBATCH --time=1-00:00:00
#SBATCH --nodes=10
#SBATCH --ntasks-per-node=8
#SBATCH --gres=gpu:8  #per node
#SBATCH --no-requeue
#SBATCH --exclusive
#SBATCH --account=cu_0003
#SBATCH --output=/dcai/users/schhau/git-repos/mllam-exps/logs/neurallam.%j.log
#SBATCH --error=/dcai/users/schhau/git-repos/mllam-exps/logs/neurallam.%j.log

echo "Started slurm job $SLURM_JOB_ID"

# export UV_INDEX=https://nexus.gefion.dcai.dk/repository/pypi/simple/
# UV_INDEX=https://nexus.gefion.dcai.dk/repository/pypi/simple/ TMPDIR=~/tmp/ ~/.local/bin/uv pip install . --native-tls
# uv venv nlm
# source nlm/bin/activate
# uv pip install neural-lam dvc dvclive
#source ~/git-repos/nlm/bin/activate
# source ~/envs/nlm_login2/bin/activate

export CARTOPY_DATA_DIR=/dcai/projects/cu_0003/user_space/has/cartopy_features/
export MLFLOW_TRACKING_URI="https://mlflow.dmi.dcs.dcai.dk" #sqlite:///mlflow.db #
export MLFLOW_TRACKING_USERNAME="admin"
export MLFLOW_TRACKING_PASSWORD="aI23ss#rPplP[:,qQ01Kl"
export MLFLOW_TRACKING_INSECURE_TLS=true

module load GCC/12.3.0
module load OpenMPI/4.1.5
module load SciPy-bundle/2024.05
module load foss/2023a
# module load Neural-LAM/0.2.0-PyTorch-2.3.1-CUDA-12.4.0
module load GCCcore/12.3.0
module load NCCL/2.18.3-CUDA-12.4.0
# module load wandb/0.16.6
module load slurm

# wandb off

# export PYTHONPATH=/dcai/projects/cu_0003/user_space/hinkas/neural-lam:$PYTHONPATH
# export PYTHONPATH=$PYTHONPATH:/dcai/projects/cu_0003/user_space/skc/packages/

source /dcai/users/schhau/git-repos/neural-lam/.venv/bin/activate

set -a
LOGLEVEL=INFO
CUDA_LAUNCH_BLOCKING=1

OMPI_MCA_pml=ucx
OMPI_MCA_btl=^vader,tcp,openib,uct
UCX_NET_DEVICES=mlx5_0:1,mlx5_3:1,mlx5_4:1,mlx5_5:1,mlx5_6:1,mlx5_9:1,mlx5_10:1,mlx5_11:1
NCCL_SOCKET_IFNAME=ens6f0
NCCL_IB_HCA=mlx5_0,mlx5_3,mlx5_4,mlx5_5,mlx5_6,mlx5_9,mlx5_10,mlx5_11
OMP_NUM_THREADS=56
set +a

srun -ul python train_wrapper.py "$@"
