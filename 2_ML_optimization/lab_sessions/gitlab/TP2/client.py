import torch
import torch.distributed as dist


class Client(object):
    r"""Implement client

    Attributes
    ----------
    model
    loader
    criterion
    device
    rank
    world_size

    Methods
    ----------
    __init__
    get_batch
    compute_gradients
    push_gradients
    pull_model
    run
    
    """
    def __init__(self, model, loader, criterion, device=None):
        self.model = model
        self.loader = loader
        self.criterion = criterion
        if device is None:
            self.device = torch.device("cpu")

        self.device = device

        self.rank = dist.get_rank()
        self.world_size = dist.get_world_size()

    def get_batch(self):
        return next(iter(self.loader))

    def compute_gradients(self, batch):
        """
        :param batch: tuple of inputs and labels
        """
        x, y = batch
        x, y = x.to(self.device), y.to(self.device)

        self.model.zero_grad()

        y_pred = self.model(x)

        loss = self.criterion(y_pred, y)
        loss.backward()

    def push_gradients(self):
        for param in self.model.parameters():
            dist.reduce(param.grad.data, dst=0, op=dist.ReduceOp.SUM)

    def pull_model(self):
        for param in self.model.parameters():
            dist.broadcast(param.data, src=0)

    def run(self, n_rounds):
        for _ in range(n_rounds):
            self.pull_model()
            batch = self.get_batch()
            self.compute_gradients(batch)
            self.push_gradients()
