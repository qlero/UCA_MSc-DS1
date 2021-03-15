import matplotlib.pyplot as plt
import numpy as np
from sklearn.datasets import load_boston
from sklearn.linear_model import Ridge
from sklearn.model_selection import train_test_split

def load_boston_dataset(test_size, rd, show=True):
    """
    II.1
    Load the Boston Dataset and splits it into train and test sets
    with 80% of the data in the train set.
    """
    if show:
        print("Loading the dataset with train/test split: "+ \
          str(1-test_size)+"/"+str(test_size))
    boston = load_boston()
    X = boston.data
    y = boston.target
    return train_test_split(X, y, test_size=test_size, random_state=rd)

def print_boston_shapes(X_train, X_test, y_train, y_test):
    """
    II.2
    Prints the shapes of the boston dataset.
    """
    feature_means=[0]*13
    for datapoint in X_train:
        for idx, feature in enumerate(datapoint):
            feature_means[idx]+=feature
    feature_means=list(map(lambda x:round(x/len(X_train),2), feature_means))
    print("Shape of training feature and target dataframes:",
          "Shape of X_train: ("+str(len(X_train))+","+str(len(X_train[0]))+")",
          "Shape of y_train: ("+str(len(X_train))+",)",
          "Shape of testing feature and target dataframes:",
          "Shape of X_test: ("+str(len(X_test))+","+str(len(X_test[0]))+")",
          "Shape of y_test: ("+str(len(X_test))+",)", 
          "Means of  feature columns (training set):",
          feature_means,
          sep="\n")

def format_x_non_centered(X):
    """
    II.3
    Formats a data array as non-centered.
    """
    n = len(X)
    ones = np.ones((n, 1))
    return np.concatenate([ones, X], axis=1)
    
def compute_w1(X_train, y_train, reg_parameter):
    """
    II.3
    Computes the weight matrix based on the non-centered train
    set.
    """
    n = len(X_train)
    d = len(X_train[0])+1
    X = format_x_non_centered(X_train)
    X_t = np.transpose(X)
    identity = np.identity(d)
    inverse = np.linalg.inv(np.dot(X_t, X)+n*reg_parameter*identity)
    X_t_Y = np.dot(X_t, y_train)
    return np.dot(inverse, X_t_Y)

def predict_1(X, w1):
    """
    II.4
    Predicts the targets of the non-centered test set given 
    a set of computed weights.
    """
    return np.dot(format_x_non_centered(X), w1)

def mean_squared_error(ground_truths, predictions):
    """
    II.5
    Given a groundtruth array, and a prediction array, calculates
    a mean squared error score
    """
    mse = 0
    n = len(ground_truths)
    for i in range(n):
        mse += (ground_truths[i]-predictions[i])**2
    return mse/n

def grid_search(splits, regs, mode="non-centered"):
    """
    II.5 
    Performs a grid search over a set of hyperparameters:
    Train-test split, regularization term
    """
    results = []
    for split in splits:
        X_train, X_test, y_train, y_test = load_boston_dataset(split, 42, False)
        for reg in regs:
            if mode=="non-centered": 
                w = compute_w1(X_train, y_train, reg)
                preds = predict_1(X_test, w) 
            else:
                w, b = compute_w2(X_train, y_train, reg)
                preds = predict_2(X_test, w, b)
            mse = mean_squared_error(y_test, preds)
            results.append([split, reg, w, preds, mse])
    return results

def plot_grid_search(results, splits, regs):
    """
    II.5
    Plots the results of the grid search.
    """
    all_results = []
    for split in splits:
        results_iterator = list(filter(lambda x: x[0]==split, results))
        plot_results = []
        for result in results_iterator:
            plot_results.append(result[4])
        all_results.append([split, plot_results])
        plt.plot(regs, plot_results, label=f"Test size: {split}", linewidth=3)
    plt.xlabel("Regularization parameter value (Lambda)", fontsize=25)
    plt.ylabel("MSE", fontsize=25)
    plt.xticks(fontsize=18)
    plt.yticks(fontsize=18)
    plt.legend(fontsize=20)
    plt.show()
    all_results.sort(key=lambda x:np.mean(x[1]))
    all_results = all_results[:3]
    views = ["dotted", "dashdot", "dashed"]
    for i, entry in enumerate(all_results):
        plt.plot(regs, entry[1], linestyle=views[i], label=f"Test size: {entry[0]}", linewidth=3)
    plt.xlabel("Regularization parameter value (Lambda)", fontsize=25)
    plt.ylabel("MSE", fontsize=25)
    plt.xticks(fontsize=18)
    plt.yticks(fontsize=18)
    plt.legend(fontsize=20)
    plt.show()
    return all_results

def center_data(X):
    """
    II.8
    Centers a non-centered dataset
    """
    return X-np.mean(X, axis=0)

def compute_w2(X_train, y_train, reg_parameter):
    """
    II.8
    Computes the weight matrix based on the non-centered train
    set.
    """
    n = len(X_train)
    d = len(X_train[0])
    X = center_data(X_train)
    X_t = np.transpose(X)
    identity = np.identity(d)
    inverse = np.linalg.inv(np.dot(X_t, X)+n*reg_parameter*identity)
    X_t_Y = np.dot(X_t, y_train)
    w2 = np.dot(inverse, X_t_Y)
    b = np.mean(y_train)-np.dot(w2, np.mean(X, axis=0))
    return w2, b

def predict_2(X, w2, b):
    """
    II.8
    Predicts the targets of the non-centered test set given 
    a set of computed weights.
    """
    return np.dot(center_data(X), w2)+b

def plot_predictions_vs_groundtruths(preds_w1, preds_w2, groundtruths):
    """
    II.9
    Plots the predictions made with w1 and w2/b against a groundtruth.
    """
    plt.plot(groundtruths, label="Ground Truth", color="#f93949")
    plt.plot(preds_w1, label="Predictions with non-centered data", color="#f4a460")
    plt.plot(preds_w2, label="Predictions with centered data", color="#4fb57a")
    plt.xlabel("Single Test Set Datapoint", fontsize=25)
    plt.ylabel("Predicted Value (y_hat)", fontsize=25)
    plt.xticks(fontsize=18)
    plt.yticks(fontsize=18)
    plt.legend(fontsize=20)
    plt.show()

def compare_w2_Ridge(preds_w1, X_train, y_train, X_test, y_test, reg):
    """
    II.11
    Compares the predictions using the Ridge implementation of SKlearn
    and the one used in II.8
    """
    model = Ridge(alpha=reg)
    model.fit(X_train, y_train)
    preds = model.predict(X_test)
    plt.plot(y_test, label="Ground Truth", color="#f93949")
    plt.plot(preds, label="Predictions with Sklearn Ridge Implementation", color="#f4a460")
    plt.plot(preds_w1, label="Predictions with From Scratch Ridge Implementation (w1 method)", color="#4fb57a")
    plt.xlabel("Single Test Set Datapoint", fontsize=25)
    plt.ylabel("Predicted Value (y_hat)", fontsize=25)
    plt.xticks(fontsize=18)
    plt.yticks(fontsize=18)
    plt.legend(fontsize=20)
    plt.show()
    mse = mean_squared_error(preds, preds_w1)
    print(f"The MSE between the predictions computed with w1 and the Sklearn Ridge model is {mse}")

if __name__ == "__main__":
    #II.1 load the Boston Dataset
    print("#### II.1 - Loading the Boston Dataset ####")
    test_size = 0.2
    X_train, X_test, y_train, y_test = load_boston_dataset(test_size,42)
    
    #II.2 prints the shapes of the dataset
    print("\n#### II.2 - Shape of the dataset ####")
    print_boston_shapes(X_train, X_test, y_train, y_test)

    #II.3 computes w1
    print("\n#### II.3 - Computing \hat{w}^1 ####")
    w1 = compute_w1(X_train, y_train, 0.1)
    print("Shape of w1: ("+str(len(w1))+",)",
          "Example computed with regularization parameter: 0.1",
          w1, sep="\n")

    #II.4 predicts based on w1
    print("\n#### II.4 - Computing predictions with \hat{w}^1 ####")
    preds_w1 = predict_1(X_test, w1)
    print("Shape of predictions: ("+str(len(preds_w1))+",)",
          "First five predictions (using w1 computed in II.3):",
          preds_w1[:5],
          sep="\n")

    #II.5 GridSearch for w1
    print("\n#### II.5 - Performing a GridSearch for \hat{w}^1 ####")
    split_sizes = list(map(lambda x:x/100, range(10, 42, 2)))
    for divisor, max_range in [(10000, 1000), (1000**2, 1000)]:
        reg_parameters = list(map(lambda x:x/divisor, range(0,max_range)))
        results = grid_search(split_sizes, reg_parameters)
        best_three_results = plot_grid_search(results, split_sizes, reg_parameters)
    for entry in best_three_results:
        param = reg_parameters[np.argmin(entry[1])]
        print(f"For test split size {entry[0]}, the best MSE score was " + \
              f"achieved with Lambda parameter: {param}.")

    #II.8 computes w2, b, predicts based on w2, b
    print("\n#### II.8 - Computing \hat{w}^2 and related predictions ####")
    w2, b = compute_w2(X_train, y_train, 0.1)
    print("Shape of w2: ("+str(len(w2))+",)",
          "Example w2 computed with regularization parameter: 0.1",
          w2, sep="\n")
    print("Example Intercept computed with regularization parameter: 0.1",
          b, sep="\n")
    preds_w2 = predict_2(X_test, w2, b)
    print("Shape of predictions: ("+str(len(preds_w2))+",)",
          "First five predictions (using w2 and b):",
          preds_w2[:5],
          sep="\n")
    print("\n#### Performing a GridSearch for \hat{w}^2 and b ####")
    split_sizes = list(map(lambda x:x/100, range(10, 42, 2)))
    for divisor, min_range, max_range in [(10000, 0, 1000), (1000**2, 0, 10000)]:
        reg_parameters = list(map(lambda x:x/divisor, range(min_range, max_range)))
        results = grid_search(split_sizes, reg_parameters, mode="centered")
        best_three_results = plot_grid_search(results, split_sizes, reg_parameters)
    
    #II.9 Comparing the two approaches
    print("\n#### II.9 - Computing the best 3 scenarions with \hat{w}^2 and b ####")
    for entry in best_three_results:
        param = reg_parameters[np.argmin(entry[1])]
        print(f"For test split size {entry[0]}, the best MSE score was " + \
              f"achieved with Lambda parameter: {param}.")

    #II.9 compares the two approaches
    plot_predictions_vs_groundtruths(preds_w1, preds_w2, y_test)
    # Using results for train-test split 0.86/0.14
    X_train, X_test, y_train, y_test = load_boston_dataset(0.14, 42, False)
    w1 = compute_w1(X_train, y_train, 0.000249)
    preds_w1 = predict_1(X_test, w1)
    w2, b = compute_w2(X_train, y_train, 0.001861)
    preds_w2 = predict_2(X_test, w2, b)
    plot_predictions_vs_groundtruths(preds_w1, preds_w2, y_test)

    #II.11 Comparing Ridge Sklearn and From Scratch implementation
    print("\n#### II.11 - Comparing Sklearn Ridge with From Scratch implementation ####")
    compare_w2_Ridge(preds_w1, X_train, y_train, X_test, y_test, 0.000249)
