---
title: "Bias and Variance"
date: 2020-07-12T14:56:05+08:00
draft: true
---

# Bias and Variance

## Diagnosis of bias and variance

Human-level performance error is often used as a proxy to the Bayes error (the theoretical lower bound of the error).

- Training set error is higher than the estimated Bayes error => avoidable bias
- Dev set error is higher than the training set error => variance


## Dealing with bias and variance

Focus first on whatever is higher between avoidable bias and variance.

### Methods to reduce avoidable bias

- Train bigger model
- Train longer/better optimization algorithms
    - Momentum
    - RMSprop
    - Adam
- NN architecture / hyperparameters search

### Methods to reduce variance

- More data
- Regularization
    - L2
    - Dropout
    - Data augmentation
- NN architecture / hyperparameter search


## Regularization methods

### L2 regularization

Neural network cost function with L2 regularization:

$$J(w^{[1]},b^{[1]},\ldots,w^{[L]},b^{[L]}) = \frac{1}{m}  \sum_{i=1}^m  \mathcal{L}( \hat{y}^{(i)},y^{(i)}) + \frac{\lambda}{2m} \sum_{l=1}^L \Vert w^{[l]} \Vert _F^2$$

where

$$\Vert w^{[l]} \Vert_F^2 = \sum_{i=1}^{n^{[l-1]}} \sum_{j=1}^{n^{[l]}} (w_{ij}^{[l]})^2$$

is called the Frobenius Norm.

With L2 regularization, the parameter update rule becomes:

$$w^{[l]} := w^{[l]} - \alpha \frac{\partial \mathcal{L}}{\partial w^{[l]}} - \alpha \frac{\lambda}{m} w^{[l]}$$

As the new update rule multiplies the parameter $w^{[l]}$ with the term $(1 - \alpha \frac{\lambda}{m})$, which is smaller than 1, the process of L2 regularization is also called **weight decay**.

### Dropout

Usually used in computer vision. Set a probability to drop each units in a layer of the network during the training process.

**Inverted dropout** is one implementation of the dropout regularizion. An example implementation of inverted dropout in python would be:

```python
keep_prob = 0.8
d3 = np.random.randn(a3.shape[0], a3.shape[1]) < keep_prob
a3 = a3 * d3 # element-wise muiltiplcation
a3 /= keep_prob
z4 = np.dot(w4, a3) + b4 
```

Here `d3` is a randomly generated boolean matrix with same dimensions as `a3`, acting as a mask to drop some units in the 3rd layer. Each layer has a `keep_prob`.

Note that dropout is not used after training when making a prediction with the trained model.
