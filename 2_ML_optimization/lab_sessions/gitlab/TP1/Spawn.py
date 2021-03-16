import os
import torch
import torch.distributed as dist
import torch.multiprocessing as multiprocess
import argparse


def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('--size', type=int, help='the number of processes')
    parser.add_argument('--func', type=str, help='choose the function to execute')
    args = parser.parse_args()
    return args

def print_rank(tensor):
    print('Hello from process {} (out of {}) with tensor {}!'.format(dist.get_rank(), dist.get_world_size(), tensor))

def broadcast(tensor):
    rank = dist.get_rank()
    size = dist.get_world_size()
    group = dist.new_group([0,1])
    if rank == 0 : print("**********\nStarting Communication\n************")
    dist.broadcast(tensor=tensor, src=0, group=group)
    print('Rank ', rank, ' has data ', tensor)

def init_process(rank, size, fn, backend):
    """ Initialize the distributed environment. """
    os.environ['MASTER_ADDR'] = '127.0.0.1'
    os.environ['MASTER_PORT'] = '29501'
    if torch.cuda.is_available() == True:
        device = torch.device('cuda:'+str(rank))
    else:
        device = torch.device('cpu')
    tensor = torch.tensor(rank, device=device)
    # Use torch.Tensor.item() to get a Python number from a tensor containing a single value:
    print(f"I am {rank} with a tensor {tensor.item()}")
    # Get a numpy array from a tensor array: tensor.numpy() or tensor.cpu().numpy()
    dist.init_process_group(backend, rank=rank, world_size=size)
    fn(tensor)

if __name__== '__main__':
    args = parse()
    if torch.cuda.is_available() == True:
        backend = 'nccl'
        if torch.cuda.device_count()<args.size:
            raise ValueError('size should not larger than the number of GPUs')
    else:
        backend = 'gloo'
            
    print(f"Backend: {backend}")
    function_mapping = {'print_rank':print_rank, 'broadcast':broadcast}
    multiprocess.spawn(init_process, args=(args.size, function_mapping[args.func], backend), nprocs=args.size,join=True, daemon=False)