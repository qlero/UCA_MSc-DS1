import pandas as pd
from sklearn.datasets import load_boston
from sklearn.model_selection import train_test_split

def load_boston_dataset(test_size):
    """
    II.1
    Load the Boston Dataset and splits it into train and test sets
    with 80% of the data in the train set.
    """
    print("Loading the dataset with train/test split: "+ \
          str(1-test_size)+"/"+str(test_size))

    boston = load_boston()
    X = pd.DataFrame(boston.data, 
                     columns=boston.feature_names)
    y = pd.DataFrame(boston.target,
                     columns=["TARGET"])
    return train_test_split(X, y, test_size=test_size, random_state=42)

def print_boston_shapes(X_train, X_test, y_train, y_test):
    """
    II.2
    Prints the shapes of the boston dataset.
    """
    print("Shape of training feature and target dataframes:",
          X_train.shape, y_train.shape,
          "Shape of testing feature and target dataframes:",
          X_test.shape, y_test.shape,
          "Means of each feature (training set):",
          X_train.mean(),
          sep="\n")
    return None

if __name__ == "__main__":
    #II.1 load the Boston Dataset
    print("#### II.1 - Loading the Boston Dataset ####")
    test_size = 0.2
    X_train, X_test, y_train, y_test = load_boston_dataset(test_size)
    
    #II.2 prints the shapes of the dataset
    print("\n\n#### II.2 - Shape of the dataset ####")
    print_boston_shapes(X_train, X_test, y_train, y_test)

    #II.3
