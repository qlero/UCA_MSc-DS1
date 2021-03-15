import torch.distributed as dist
from copy import deepcopy


class Server(object):
    r"""Implements server

    Attributes
    ----------
    learner
    test_loader
    logger
    log_freq
    rank
    world_size

    Methods
    ----------
    __init__
    evaluate_loader
    broadcast_model
    reduce_models
    run

    """
    def __init__(self, learner, test_loader, logger=None, log_freq=1):
        self.rank = dist.get_rank()
        self.world_size = dist.get_world_size()

        assert self.rank == 0, "Server should have rank=0"

        self.learner = learner
        self.test_loader = test_loader
        self.logger = logger
        self.log_freq = log_freq

    def broadcast_model(self):
        for param in self.learner.model.parameters():
            dist.broadcast(param.data, src=0)

    def reduce_models(self):
        #tensor_old = tensor.clone()
        for param in self.learner.model.parameters():
            param_old = param.clone()
            dist.reduce(param.data, dst=0, op=dist.ReduceOp.SUM) 
            param.data -= param_old.data
            param.data /= (self.world_size-1) 

    def run(self, n_rounds):
        for round_idx in range(n_rounds):
            self.broadcast_model()
            self.reduce_models()

            if round_idx % self.log_freq == self.log_freq-1:
                loss, acc = self.learner.evaluate_iterator(self.test_loader)
                print(f"Round {round_idx} | Loss: {loss:.3f} |Acc.: {(acc*100):.3f}%")

