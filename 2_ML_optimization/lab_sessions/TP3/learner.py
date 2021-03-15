import torch

class Learner:
    """
    Responsible of training and evaluating a (deep-)learning model

    Attributes
    ----------
    model (nn.Module): the model trained by the learner
    criterion (torch.nn.modules.loss): loss function used to train the `model`
    metric (fn): function to compute the metric, should accept as input two vectors and return a scalar
    device (str or torch.device):
    optimizer (torch.optim.Optimizer):

    Methods
    ------
    fit_epoch: perform an optimizer step over one epoch
    fit_epochs: perform successive optimizer steps over successive epochs
    evaluate_iterator: evaluate `model` on an iterator
    get_param_tensor: get `model` parameters as a unique flattened tensor
    """

    def __init__(self, model, criterion, metric, device, optimizer):
        self.model = model.to(device)
        self.criterion = criterion.to(device)
        self.metric = metric
        self.device = device
        self.optimizer = optimizer

        self.model_dim = int(self.get_param_tensor().shape[0])

    def fit_epoch(self, iterator):
        """
        perform several optimizer steps on all batches drawn from `iterator`
        :param iterator:
        :type iterator: torch.utils.data.DataLoader
        return:
            loss.item()
            metric.item()
        """
        self.model.train()

        n_samples = len(iterator.dataset)

        global_loss = 0.
        global_metric = 0.

        for x, y in iterator:
            x = x.to(self.device).type(torch.float32) #type cast not required
            y = y.to(self.device)

            self.model.zero_grad()
            y_pred=self.model(x)
            loss=self.criterion(y_pred, y)
            loss.backward()
            self.optimizer.step()
            global_loss += self.criterion(y_pred.squeeze(), y).item() * len(y)
            global_metric += self.metric(y_pred.squeeze(), y).item() * len(y)

        return global_loss / n_samples, global_metric / n_samples

    def evaluate_iterator(self, iterator):
        """
        evaluate learner on `iterator`
        :param iterator:
        :type iterator: torch.utils.data.DataLoader
        :return
            global_loss and  global_metric accumulated over the iterator
        """
        n_samples = len(iterator.dataset)

        self.model.eval()

        global_loss = 0.
        global_metric = 0.

        for x, y in iterator:
            x = x.to(self.device).type(torch.float32)
            y = y.to(self.device)

            with torch.no_grad(): #we set to nograd to not update the model
                y_pred = self.model(x).squeeze()
                global_loss += self.criterion(y_pred, y).item() *len(y)
                global_metric += self.metric(y_pred, y).item() *len(y)

        return global_loss / n_samples, global_metric / n_samples

    def fit_epochs(self, iterator, n_epochs):
        """
        perform multiple training epochs
        :param iterator:
        :type iterator: torch.utils.data.DataLoader
        :param n_epochs: number of successive batches
        :type n_epochs: int
        :return:
            average loss and metric over the `n_steps`
        """
        global_loss = 0
        global_acc = 0

        for step in range(n_epochs):
            batch_loss, batch_acc = self.fit_epoch(iterator)

            global_loss += batch_loss
            global_acc += batch_acc

        return global_loss / n_epochs, global_acc / n_epochs

    def get_param_tensor(self):
        """
        get `model` parameters as a unique flattened tensor
        :return: torch.tensor
        """
        param_list = []

        for param in self.model.parameters():
            param_list.append(param.data.view(-1, ))

        return torch.cat(param_list)
