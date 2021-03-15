import torch
import torch.distributed as dist


class Client(object):
    r"""Implement client

    Attributes
    ----------
    learner
    loader
    device
    local_epochs
    client_weight
    rank
    world_size

    Methods
    ----------
    __init__
    push_model
    pull_model
    run

    """

    def __init__(self, learner, loader, client_weight, local_epochs=1, device=None):
        self.learner = learner
        self.loader = loader
        self.client_weight = client_weight
        self.local_epochs = local_epochs

        if device is None:
            self.device = torch.device("cpu")

        self.device = device

        self.rank = dist.get_rank()
        self.world_size = dist.get_world_size()

    def push_model(self):
         for param in self.learner.model.parameters():
             dist.reduce(param.data, dst=0, op=dist.ReduceOp.SUM)

    def pull_model(self):
        for param in self.learner.model.parameters():
            dist.broadcast(param.data, src=0)

    def run(self, n_rounds):
        for _ in range(n_rounds):
            self.pull_model()
            self.learner.fit_epochs(iterator=self.loader, n_epochs=self.local_epochs)
            self.push_model()
