# Black Box Optimization Challenge

This repo contains the starter kit for the [black box optimization challenge](http://bbochallenge.com/) at [NeurIPS 2020](https://neurips.cc/Conferences/2020/CompetitionTrack).
Upload submissions [here](https://bbochallenge.com/my-submissions).

The challenge will give the participants 3 months to iterate on their algorithms.
We will use a benchmark system built on top of the AutoML challenge workflow and the [Bayesmark package](https://github.com/uber/bayesmark), which evaluates black-box optimization algorithms on real-world objective functions
For example, it will include tuning (validation set) performance of standard machine learning models on real data sets.
This competition has widespread impact as black-box optimization (e.g., Bayesian optimization) is relevant for hyper-parameter tuning in almost every machine learning project (especially deep learning), as well as many applications outside of machine learning.
The leader board will be determined using the optimization performance on held-out (hidden) objective functions, where the optimizer must run without human intervention.
Baselines will be set using the default settings of six open source black-box optimization packages and random search.

Look in `example_submissions` to see examples of submissions.
The examples currently contain the sub-directories:

```
hyperopt/
nevergrad/
opentuner/
pysot/
random_search/
skopt/
```

![Bayesmark output](https://user-images.githubusercontent.com/28273671/66338456-02516b80-e8f6-11e9-8156-2e84e04cf6fe.png)

## Instructions for local experiments

Local experimentation/benchmarking on publicly available problems can be done using Bayesmark, which is extensively [documented](https://bayesmark.readthedocs.io/en/latest/index.html).
Note, these are not the same problems as on the leader board when submitting on the website, but may be useful for local iteration.

```console
> # setup
> DB_ROOT=./output  # path/to/where/you/put/results
> DBID=demo
> # experiments
> bayesmark-launch -n 15 -r 3 -dir $DB_ROOT -b $DBID -o Opentuner PySOT -v
Supply --uuid 3adc3182635e44ea96969d267591f034 to reproduce this run.
Supply --dbid bo_example_folder to append to this experiment or reproduce jobs file.
User must ensure equal reps of each optimizer for unbiased results
-c DT -d boston -o PySOT -u a1b287b450385ad09b2abd7582f404a2 -m mae -n 15 -p 1 -dir /notebooks -b bo_example_folder
-c DT -d boston -o PySOT -u 63746599ae3f5111a96942d930ba1898 -m mse -n 15 -p 1 -dir /notebooks -b bo_example_folder
-c DT -d boston -o RandomSearch -u 8ba16c880ef45b27ba0909199ab7aa8a -m mae -n 15 -p 1 -dir /notebooks -b bo_example_folder
...
0 failures of benchmark script after 144 studies.
done
> # aggregate
> bayesmark-agg -dir $DB_ROOT -b $DBID
> # analyze
> bayesmark-anal -dir $DB_ROOT -b $DBID -v
...
median score @ 15:
optimizer
PySOT_0.2.3_9b766b6           0.330404
RandomSearch_0.0.1_9b766b6    0.961829
mean score @ 15:
optimizer
PySOT_0.2.3_9b766b6           0.124262
RandomSearch_0.0.1_9b766b6    0.256422
normed mean score @ 15:
optimizer
PySOT_0.2.3_9b766b6           0.475775
RandomSearch_0.0.1_9b766b6    0.981787
done
```

TODO link to how scoring works

If running new experiments (without the `baseline.json` file), `RandomSearch` must be included in the optimizers for the purposes of baselining.

## Instructions for submissions on the website

The quick-start instructions work as follows:

* Place all the necessary Python files to execute the optimizer in a folder, for example, `example_submissions/pysot`.
The site will use `optimizer.py` as the *entry-point* (any filename is allowed if there is only one `.py` file).
* The Python environment will be `Python 3.7.7` and contain all dependencies in [environment.txt](https://github.com/rdturnermtl/bbo_challenge_starter_kit/blob/master/environment.txt).
All other dependencies must be placed in a `requirements.txt` in the same folder as `optimizer.py`.

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

Also note, our optimization problems have been randomly split into a set that will be used to determine the leader board, and another set that will determine the final winner once submissions are closed.

### Execution environment

The docker environment has two cores and no GPUs.
It runs in `Debian GNU/Linux 10 (buster)` with `Python 3.7.7` and the pre-installed packages in [environment.txt](https://github.com/rdturnermtl/bbo_challenge_starter_kit/blob/master/environment.txt).
The optimizer has only TODO minutes on each problem.
After that, it will be cutoff from further suggestions.

### Non-PyPI dependencies

The `prepare_upload` script will only fetch the wheels for packages available on PyPI.
If a package is not available on PyPI you can include the wheel in the optimizer folder manually.
Wheels can be built using the command `python3 setup.py sdist bdist_wheel` as documented [here](https://packaging.python.org/tutorials/packaging-projects/#generating-distribution-archives).

## Optimizer API

TODO copy-paste basic outline here, link to bayesmark documentation

### Configuration space

TODO include space examples from proposal

TODO T&C link
