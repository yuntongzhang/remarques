---
title: "Mismatched Training and Dev/Test Set"
date: 2020-07-13T09:20:51+08:00
draft: true
---

# Mismatched Training and Dev/Test Set

## The problem

Sometimes, there are not enough data with the same distribution as dev/test set for us to use in training. Training data may then be obtained from other sources, but there is a potential issue of data distribution mismatch between training set and dev/test set.


## Bias Variance analysis when mismatched

Apart from the avoidable bias problem and the variance problem, we now have an additional data mismatch problem. To diagnose these three problems together, introduce a **training-dev** set, which has the same data distribution as the training set, but is not used during the training process.

Now, the difference between training-dev set error and dev set error reflects the data mismatch between training and dev/test set.

<img src="/deep-learning/data-mismatch.png" alt="Data mismatch" width="50%" />
