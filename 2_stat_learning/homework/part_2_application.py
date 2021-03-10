import numpy as np
from sklearn.datasets import load_boston
from sklearn.model_selection import train_test_split

def load_boston_dataset(test_size, rd):
    """
    II.1
    Load the Boston Dataset and splits it into train and test sets
    with 80% of the data in the train set.
    """
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
    return None

def compute_w1(X_train, y_train, reg_parameter):
    """
    II.3
    Computes the weight matrix based on the non-centered train
    set.
    """
    n = len(X_train)
    d = len(X_train[0])+1
    ones = np.ones((n, 1))
    X = np.concatenate([ones, X_train], axis=1)
    X_t = np.transpose(X)
    identity = np.identity(d)
    inverse = np.linalg.inv(np.dot(X_t, X)+n*reg_parameter*identity)
    X_t_Y = np.dot(X_t, y_train)
    return np.dot(inverse, X_t_Y)

def predict_1(X_test, w1):
    """
    II.4
    Predicts the targets of the non-centered test set given 
    a set of computed weights.
    """
    n = len(X_test)
    ones = np.ones((n,1))
    X = np.concatenate([ones, X_test], axis=1)
    return np.dot(X, w1)

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
    print("\n#### II.4 - Computing prediction with \hat{w}^1 ####")
    preds = predict_1(X_test, w1)
    print("Shape of predictions: ("+str(len(preds))+",)",
          "First five predictions (using w1 computed in II.3):",
          preds[:5],
          sep="\n")

    #II.5 GridSearch for w1
    print("\n#### II.5 - Performing a GridSearch for \hat{w}^1 ####")

