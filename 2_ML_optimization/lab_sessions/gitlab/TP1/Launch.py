import os
import torch
import torch.distributed as dist
import argparse


def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('--func', type=str, help='choose the function to execute')
    parser.add_argument('--backend', type=str, help='choose the backend')
    parser.add_argument('--local_rank', type=int)
    args = parser.parse_args()
    return args

def print_rank():
    print('Hello from process {} (out of {})!'.format(dist.get_rank(), dist.get_world_size()))

def broadcast():
    rank = dist.get_rank()
    size = dist.get_world_size()
    if torch.cuda.is_available() == True:
        device = torch.device('cuda:'+str(rank))
    else:
        device = torch.device('cpu')
    tensor = torch.tensor(rank, device=device)
    group = dist.new_group([0,1])
    #print(f"I am {rank} of {size} with a tensor {tensor.item()}")
    if rank == 0 : print("**********\nStarting Communication\n************")
    dist.broadcast(tensor=tensor, src=0, group=group)
    print('Rank ', rank, ' has data ', tensor)


if __name__== '__main__':
    args = parse()
    backend = args.backend
    if torch.cuda.is_available() == True:
        size = int(os.environ['WORLD_SIZE'])
        if torch.cuda.device_count()<size:
            raise ValueError('size should not larger than the number of GPUs')
    rank = os.environ['LOCAL_RANK']
    function_mapping = {'print_rank':print_rank, 'broadcast':broadcast}
    dist.init_process_group(backend, init_method="env://")
    function_mapping[args.func]()
