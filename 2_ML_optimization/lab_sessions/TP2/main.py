import pickle
import argparse
import os

import torch
import torch.distributed as dist
from torch.utils.data import DataLoader
import torch.optim as optim

from .utils.metrics import *
from .models import *
from .datasets import *
from .client import *
from .server import *


INDICES_PATH = "data/indices"
MNIST_PATH = "data/fashionmnist"


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--n_rounds',
        help='number of communication rounds;',
        type=int)
    parser.add_argument(
        '--lr',
        help='number of clients;',
        type=float,
        default=1e-2)
    parser.add_argument(
        '--local_rank',
        type=int)
    parser.add_argument(
        '--seed',
        help='seed for the random processes;',
        type=int,
        default=1234,
        required=False)
    return parser.parse_args()


def main():
    args = parse_args()
    
    dist.init_process_group(backend='gloo', init_method="env://")

    rank = dist.get_rank()
    model = LinearModel()
    criterion = nn.CrossEntropyLoss()
    metric = accuracy
    device = toch.device("cpu")

    if rank == 0:
        # Initialize gradients to 0
        for param in model.parameters():
            param.grad = torch.zeros_like(param)

        #### Code here #####
        # create test loader for Fashion-MNIST dataset
        loader = #####
        ##### 3-5 lines #####

        optimizer = ##### Code Here ####

        server = Server(model, loader, optimizer, criterion, metric, device)
        server.run(n_rounds=args.n_rounds)

    else:
        indices_path = os.path.join(INDICES_PATH, f"client_{rank}.pkl")
        with open(indices_path, "rb") as f:
            indices = pickle.load(f)

        dataset = SubMNIST(MNIST_PATH, indices)
        loader = DataLoader(dataset, shuffle=True, batch_size=32)
        client = Client(model, loader, criterion, device)
        client.run(n_rounds=args.n_rounds)


if __name__ == "__main__":
    main()
