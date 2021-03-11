module load conda/5.0.1-python3.6
conda create --name virt_pytorch
source activate virt_pytorch
module load cuda/9.2
module load cudnn/7.1-cuda-9.2
module load gcc/7.3.0
module load mpi/openmpi-2.0.0-gcc
module load pytorch/1.4.0
