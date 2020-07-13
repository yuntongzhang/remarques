---
title: "Learning From Multiple Tasks"
date: 2020-07-13T10:18:30+08:00
---

# Learning from Multiple Tasks

## Transfer learning

Make use of a trained neural network on another task. 

If there are small amount of data for the new task, fix the trained parameters in the earlier layers, and re-initialize the parameters of the last few layers in the trained network. 

If there are more data for the new task, can choose to re-train the entire network. If re-train the entire network, the previous trianing is called **pre-training**, and the new training is called **fine-tuning**.

When transfer learning makes sense: (transfer from A to B)

- Task A and B have the same input x.
- You have a lot more data for Task A than Task B.
- Low level features from A could be helpful for learning B.


## Multi-task learning

Use one neural network to train for multiple tasks at the same time.

One example would be to detect multiple objects such as pedestrians, vehicles and traffic lights for autonomous driving.

In multi-task learning, data with some missing labels (e.g. a picture without label for vehicles) can still be used.

When multi-task learning makes sense:

- Training on a set of tasks that could benefit from having shared lower-level features.
- Usually: Amount of data you have for each task is quite similar.
- Can train a big enough neural network to do well on all the tasks.
