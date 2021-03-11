import os
import time
import random
import pickle
import argparse

from torchvision.datasets import FashionMNIST

FASHIONMNIST_PATH = "fashionmnist"
INDICES_PATH = "indices"
N_SAMPLES = 60_000

def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '--n_clients',
        help='number of clients;',
        type=int)
    parser.add_argument(
        '--seed',
        help='seed for the random processes;',
        type=int,
        default=1234,
        required=False)
    return parser.parse_args()


def iid_divide(l, g):
    """
    https://github.com/TalwalkarLab/leaf/blob/master/data/utils/sample.py
    divide list `l` among `g` groups
    each group has either `int(len(l)/g)` or `int(len(l)/g)+1` elements
    returns a list of groups
    """
    num_elems = len(l)
    group_size = int(len(l)/g)
    num_big_groups = num_elems - g * group_size
    num_small_groups = g - num_big_groups
    glist = []
    for i in range(num_small_groups):
        glist.append(l[group_size * i: group_size * (i + 1)])
    bi = group_size*num_small_groups
    group_size += 1
    for i in range(num_big_groups):
        glist.append(l[bi + group_size * i:bi + group_size * (i + 1)])
    return glist


def save_data(l, path_):
    with open(path_, 'wb') as f:
        pickle.dump(l, f)


def generate_data(n_clients, seed=1234):
    FashionMNIST(FASHIONMNIST_PATH, download=True)

    os.makedirs(INDICES_PATH, exist_ok=True)
    rng_seed = (seed if (seed is not None and seed >= 0) else int(time.time()))
    rng = random.Random(rng_seed)

    all_indices = list(range(N_SAMPLES)) 
    rng.shuffle(all_indices)

    clients_indices = iid_divide(all_indices, n_clients)

    for client_id, indices in enumerate(clients_indices):
        client_path = os.path.join(INDICES_PATH, f"client_{client_id+1}.pkl")
        save_data(indices, os.path.join(client_path))


if __name__ == "__main__":
    args = parse_args()
    generate_data(n_clients=args.n_clients, seed=args.seed)

