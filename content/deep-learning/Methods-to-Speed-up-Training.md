---
title: "Methods To Speed Up Training"
date: 2020-07-12T18:26:40+08:00
draft: true
---

# Methods to Speed up Training

## Input normalization

Performing input normalization on one sample:

$$\bar{x} = \frac1m \sum_{i=1}^m x^{(i)}$$
$$x^{(i)} := x^{(i)} - \bar{x}$$
$$\sigma^2 = \frac1m \sum_{i=1}^m (x^{(i)})^2 $$
$$x^{(i)} := \frac{x^{(i)}}{\sigma^2}$$


## Weight initialization

In neural network, weighs need to be initialized randomly to break symmetry, and also need to be small to hit the region of large gradients in the activation functions.

For tanh activation function, use Xavier initialization:

$$W^{[l]} = \operatorname{np.random.randn(shape\\_params)} \times \sqrt{\frac{1}{n^{[l-1]}}}$$

For ReLU activation function, use He initialization:

$$W^{[l]} = \operatorname{np.random.randn(shape\\_params)} \times \sqrt{\frac{2}{n^{[l-1]}}}$$


## Optimization algorithms

### Mini-batch gradient descent

The mini-batch is also a hyperparameter. Roughly, choose the mini-batch size according the following guidelines:

- If the sample size is small (~a few thousands), just use batch gradient descent.
- If there are a lot of data, choose mini-batch size to be power-of-two. Eg. 64, 128, 256, etc.
- Consider the CPU/GPU memory size as well (whether they can fit in a single mini-batch of data).


### Gradient descent with momentum

Compute exponentially weighted average of the **gradients**, and use it to update the parameters.

$$v_{dW} = \beta v_{dW} + (1-\beta)dW$$
$$v_{db} = \beta v_{db} + (1-\beta)db$$
$$w := w - \alpha v_{dW}$$
$$b := b - \alpha v_{db}$$

$\beta$ is a hyperparameter which usually takes value around 0.9 in practice.


### RMSprop

RMSprop (Root Mean Square Propagation) computes exponential weighted average of the **square of gradients**. However, this exponentailly weighted average does not play the role of gradients in parameter update, but rather used to control the learning rate according to the gradients value.

$$s_{dW} = \beta s_{dW} + (1-\beta)(dW)^2$$
$$s_{db} = \beta s_{db} + (1-\beta)(db)^2$$
$$w := w - \alpha \frac{dW}{\sqrt{s_{dW} + \varepsilon}}$$
$$b := b - \alpha \frac{db}{\sqrt{s_{db} + \varepsilon}}$$

$\varepsilon$ is a very small value (usually $10^{-8}$ in practice) added to avoid division by zero.


### Adam

Adam (Adaptive Moment Estimation) optimization algorithm is the combination of momentum and RMSprop.

In Adam, before the iterations of gradient descent, $v$ and $s$ need to be initialized to zero:

$$v_{dW} = 0, v_{db} = 0, s_{dW} = 0, s_{db} = 0$$

During the $t^{th}$ iteration of gradient descent update:

$$v_{dW} = \beta_1 v_{dW} + (1-\beta_1)dW, \quad v_{db} = \beta_1 v_{db} + (1-\beta_1)db$$
$$s_{dW} = \beta_2 s_{dW} + (1-\beta_2)(dW)^2, \quad s_{db} = \beta_2 s_{db} + (1-\beta_2)(db)^2$$
$$v_{dW}^{corrected} = \frac{v_{dW}}{1-(\beta_1)^t}, \quad v_{db}^{corrected} = \frac{v_{db}}{1-(\beta_1)^t}$$
$$s_{dW}^{corrected} = \frac{s_{dW}}{1-(\beta_2)^t}, \quad s_{db}^{corrected} = \frac{s_{db}}{1-(\beta_2)^t}$$
$$w := w - \alpha \frac{v_{dW}^{corrected}}{\sqrt{s_{dW}^{corrected}}+\varepsilon}$$
$$b := b - \alpha \frac{v_{db}^{corrected}}{\sqrt{s_{db}^{corrected}}+\varepsilon}$$

Here, $\alpha$, $\beta_1$, $\beta_2$ and $\varepsilon$ are hyperparameters:

- $\alpha$ needs to be tuned;
- $\beta_1$ is usually set to 0.9;
- $\beta_2$ is usually set to 0.999;
- $\varepsilon$ is usually set to $10^{-8}$.


## Learning rate decay

Large learning rate at the start of training can make gradient descent progress faster. Smaller learning rate at the later part of the training can make gradient descent converge to the optimal solution faster.

There are a few ways for doing learning rate decay:

- $$\alpha = \frac{1}{1+decay\\_rate \times epoch\\_number} \alpha_0$$
- $$\alpha = 0.95^{epoch\\_number} \alpha_0$$
- $$\alpha = \frac{k}{\sqrt{epoch\\_number}} \alpha_0$$


## Hyperparameter tuning

How important are hyperparameters?

- Tier 1: learning rate $\alpha$.
- Tier 2: Momentum $\beta$, # of hidden units, mini-batch size.
- Tier 3: # of layers, learning rate $decay\\_rate$.
- Tier 4: Adam hyperparameters $\beta_1$, $\beta_2$, $\varepsilon$.


## Batch normalization

Batch norm performs normalization on the output of the hidden layer units. It can be applied to either $z$ or $a$.

If there are $m$ training samples, at a particular layer $l$, the steps to perform batch norm are:

$$\mu = \frac1m \sum_{i=1}^m z^{(i)}$$
$$\sigma^2 = \frac1m \sum_{i=1}^m (z^{(i)} - \mu)^2$$
$$z_{norm}^{(i)} = \frac{z^{(i)} - \mu}{\sqrt{\sigma^2 + \varepsilon}}$$

$\varepsilon$ is added to avoid division by zero, and is usually set as $10^{-8}$ in practice.

In neural network, it is better for $z$ in different layers to have different distributions (different $\mu$ and $\sigma^2$). Moreover, if all $z$ clustered around the area of $\mu = 0, \sigma^2 = 1$, the non-linear regions of the activation functions are not sufficiently utilized. Thus we have:

$$\tilde{z}^{(i)} = \gamma z_{norm}^{(i)} + \beta$$

Now $\tilde{z}$ has mean $\beta$ and variance $\gamma$. 

Note that $\beta$ and $\gamma$ here are **not** hyperparameters, but rather the parameters need to be learned by gradient descent.

Since $\beta$ sets the mean for $\tilde{z}$, the parameter $b$ is redundant now. Therefore, with batch normalization, the parameters need to be learned are $W$, $\beta$ and $\gamma$.

**At test time.** There is only one example when we are making predictions, so there is no readily calculatable mean and variance for batch norm at test time. What we can do is that, during training time, calculate the exponentially weighed average of the obtained $\mu$ and $\sigma^2$, and use those average values during test time.
