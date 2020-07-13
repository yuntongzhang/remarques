---
title: "Neural Network"
date: 2020-07-12T11:15:52+08:00
draft: true
---

# Neural Network

## Main steps for building a Neural Network

1. Define the model structure (# of input units, # of hidden units, etc.).
2. Initialize the model's parameters / Define hyperparameters.
3. Loop:
    - Implement forward propagation
    - Compute loss
    - Implement backward propagation to get the gradients
    - Update parameters (gradient decent)

Often times, the steps are built separately and integrated together later on.


## Activation function choices

Apart from the sigmoid activation function, there are a few more other choices.

### tanh

The hyperbolic tangent function (tanh) is represented as the following:

$$tanh(z) = \frac{e^{z} - e^{-z}}{e^{z} + e^{-z}}$$

Since the value of tanh is between -1 and 1, the output value will have a mean closer to 0 (sigmoid output has mean close to 0.5). This makes the training in next layer easier, and thus tanh is **always better** than sigmoid (except for being output layer in binary classification tasks). For binary classification tasks output layer, it is still better to use sigmoid because we want the output to be between 0 and 1.

Both sigmoid and tanh has one disadvantage: when z becomes very big or very small, the gradient becomes very small, resulting in slow progress in gradient decent.

### ReLU

The rectified linear unit (ReLU) activation function has the following representation:

$$g(z) = max(0,z) =\begin{cases} 0, & z \leq 0 \\\ z, & z > 0 \end{cases}$$

which corresponds to the following graph:

<img src="/deep-learning/relu.png" alt="ReLU graph" width="40%" />

When z is greater than 0, the gradient of ReLU is always 1, which makes gradient decent converges faster than sigmoid and tanh. ReLU is often **used as default** in practice.

### Leaky-ReLU

$$g(z) = max(0,z) =\begin{cases} \alpha z, & z \leq 0 \\\ z, & z > 0 \end{cases}$$

<img src="/deep-learning/leaky-relu.png" alt="Leaky-ReLU graph" width="40%" />

Here, $\alpha$ is a small constant to preserve the negative inputs.
