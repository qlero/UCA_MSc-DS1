To launch the program:

1. Go to data directory, run python generate_data.py --n_clients 10
2. Go back to the root directory, run python -m torch.distributed.launch --nproc_per_node=11 main.py --n_rounds=100
