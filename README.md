# Black Box Optimization Challenge

This repo contains the starter kit for the black box optimization (BBO) challenge at NeurIPS 2020.

The challenge will give the participants 3 months to iterate on their algorithms.
We will use a benchmark system built on top of the AutoML challenge workflow and the Bayesmark package, which evaluates black-box optimization algorithms on real-world objective functions
For example, it will include tuning (validation set) performance of standard machine learning models on real data sets.
This competition has widespread impact as black-box optimization (e.g., Bayesian optimization) is relevant for hyper-parameter tuning in almost every machine learning project (especially deep learning), as well as many applications outside of machine learning.
The leader board will be determined using the optimization performance on held-out (hidden) objective functions, where the optimizer must run without human intervention.
Baselines will be set using the default settings of six open source black-box optimization packages and random search.

TODO all links: main site, submissions

Look in `example_submissions` to see examples of submissions.

TODO list all subdirs and the tool.

TODO image

## Instructions for local experiments

Local experimentation/benchmarking on publicly available problems can be done using Bayesmark, which is extensively documented.
Note, these are not the same problems as on the leader board when submitting on the website, but may be useful for local iteration.

TODO full instructions

## Instructions for submissions on the website

TODO note, 2 core, no GPU, OS
TODO file link env.txt

The quick-start instructions work as follows:

* Place all the necessary Python files to execute the optimizer in a folder, for example, `example_submissions/pysot`.
The site will use `optimizer.py` as the *entry-point* (any filename is allowed if there is only one `.py` file).
* The Python environment will be `Python 3.7.7` and contain all dependencies in `environment.txt`.
All other dependencies must be placed in `requirements.txt` in the same folder as `optimizer.py`.

The submission can be prepared using the `prepare_upload` script:

```
./prepare_upload.sh ./example_submissions/pysot
```

TODO example with requirements.

This will produce a zip file (e.g., `upload_pysot.zip`) that can be uploaded at the submission site.

The submissions will be evaluated inside a docker container that has *no internet connection*.
Therefore, `prepare_upload.sh` places all dependencies from `requirements.txt` as wheel files inside the zip file.

The zip file can also manually be constructed by zipping the Python files (including `optimizer.py`) and all necessary wheel/tar balls for installing extra dependencies.
Note: the Python file should be at the top level of zip file (and not inside a parent folder).

TODO link to instructions on building your own wheel

## Optimizer API

TODO copy-past basic outline here, link to bayesmark documentation
