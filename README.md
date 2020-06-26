# Black Box Optimization Challenge

This repo contains the starter kit for the [black box optimization challenge](https://bbochallenge.com/) at [NeurIPS 2020](https://neurips.cc/Conferences/2020/CompetitionTrack).
Upload submissions [here](https://bbochallenge.com/my-submissions).

The submission site is open July 1, 2020 - October 15, 2020.
We will be open early for practice submissions in the beta-testing phase, but the leaderboard will be reset on July 1.

The benchmark site is powered by [Valohai](https://valohai.com/) and runs the [Bayesmark package](https://github.com/uber/bayesmark), which evaluates black-box optimization algorithms on real-world objective functions.
It includes tuning (validation set) performance of standard machine learning models on real data sets.
Currently, all of the problems are based on ML hyper-parameter tuning tasks.
There are example problems in the starter kit that can be run locally, but the leaderboard problems are secret.

The leaderboard is determined using the optimization performance on held-out (hidden) objective functions, where the optimizer must run without human intervention.

Look in `example_submissions` to see examples of submissions.
The examples currently contain the sub-directories:

```console
hyperopt/
nevergrad/
opentuner/
pysot/
random_search/
skopt/
turbo/
```

![Bayesmark output](https://user-images.githubusercontent.com/28273671/66338456-02516b80-e8f6-11e9-8156-2e84e04cf6fe.png)

## Instructions for local experiments

Local experimentation/benchmarking on publicly available problems can be done using Bayesmark, which is extensively [documented](https://bayesmark.readthedocs.io/en/latest/index.html).
Note, these are not the same problems as on the leaderboard when submitting on the website, but may be useful for local iteration.

For convenience the script `run_local` can do local benchmarking in a single command:

```console
> ./run_local.sh ./example_submissions/pysot 3
...
--------------------
Final score `100 x (1-loss)` for leaderboard:
optimizer
pysot_0.2.3_8cae841    81.11426
```

It produces a lot of log output as it runs, that is normal.
The first argument gives the *folder of the optimizer* to run, while the second argument gives the number of *repeated trials* for each problem.
Set the repeated trials as large as possible within your computational budget.
For finer grain control over which experiments to run, use the Bayesmark commands directly.
See the [documentation](https://bayesmark.readthedocs.io/en/latest/readme.html#example) for details.

More explanation on how the mean score formula works can be found [here](https://bayesmark.readthedocs.io/en/latest/scoring.html#mean-scores).

## Instructions for submissions on the website

The quick-start instructions work as follows:

* Place all the necessary Python files to execute the optimizer in a folder, for example, `example_submissions/pysot`.
The site will use `optimizer.py` as the *entry-point*.
* The Python environment will be `Python 3.6.10` and contain all dependencies in [environment.txt](https://github.com/rdturnermtl/bbo_challenge_starter_kit/blob/master/environment.txt).
All other dependencies must be placed in a `requirements.txt` in the same folder as `optimizer.py`.

The submission can be prepared using the `prepare_upload` script:

```console
> ./prepare_upload.sh ./example_submissions/pysot
...
For scoring, upload upload_pysot.zip at address:
https://bbochallenge.com/my-submissions
```

This will produce a zip file (e.g., `upload_pysot.zip`) that can be uploaded at the [submission site](https://bbochallenge.com/my-submissions).
See, `./prepare_upload.sh ./example_submissions/opentuner` for an example with a requirements file.

The submissions will be evaluated inside a docker container that has *no internet connection*.
Therefore, `prepare_upload.sh` places all dependencies from `requirements.txt` as wheel files inside the zip file.

The zip file can also manually be constructed by zipping the Python files (including `optimizer.py`) and all necessary wheel/tar balls for installing extra dependencies.
Note: the Python file should be at the top level of the zip file (and not inside a parent folder).

Also note, our optimization problems have been randomly split into a set that will be used to determine the leaderboard, and another set that will determine the final winner once submissions are closed (October 15, 2020).

### Time limits

The optimizer has a total of 640 seconds compute time for making suggestions on each problem (32 iterations with batch size of 8); or 20 seconds per iteration.
Optimizers exceeding the time limits will be cut off from making further suggestions and the best optima found before being killed will be used.
Participant teams will be limited to one submission per day.
These timing limits are subject to change prior to the launch date.

### Execution environment

The docker environment has two CPU cores and no GPUs.
It runs in `Debian GNU/Linux 10 (buster)` with `Python 3.6.10` and the pre-installed packages in [environment.txt](https://github.com/rdturnermtl/bbo_challenge_starter_kit/blob/master/environment.txt).
Participants have until July 31 to suggest new packages be added to `environment.txt` in the docker.
The environment in the docker can be produced locally by creating a new Python 3.6.10 [virtual environment](https://python.readthedocs.io/en/stable/library/venv.html#creating-virtual-environments) and running:

```bash
pip install -r environment.txt
```

It consumes ~1.6GB of disk space to create the virtual environment.

### Non-PyPI dependencies

The `prepare_upload` script will only fetch the wheels for packages available on [PyPI](https://pypi.org/).
If a package is not available on PyPI, you can use a public git repo instead; see the `turbo` example.

If a package is only available in a private git repo, you can include the wheel in the optimizer folder manually.
Wheels can be built using the command:

```bash
python3 setup.py bdist_wheel
```

as documented [here](https://packaging.python.org/tutorials/packaging-projects/#generating-distribution-archives).

## Optimizer API

All optimization problems are *minimization*.
Lower values of the black-box function are better.

Optimizer submissions should follow this template, for a suggest-observe interface, in your `optimizer.py`:

```python
from bayesmark.abstract_optimizer import AbstractOptimizer
from bayesmark.experiment import experiment_main


class NewOptimizerName(AbstractOptimizer):
    primary_import = None  # Optional, used for tracking the version of optimizer used

    def __init__(self, api_config):
        """Build wrapper class to use optimizer in benchmark.

        Parameters
        ----------
        api_config : dict-like of dict-like
            Configuration of the optimization variables. See API description.
        """
        AbstractOptimizer.__init__(self, api_config)
        # Do whatever other setup is needed
        # ...

    def suggest(self, n_suggestions=1):
        """Get suggestions from the optimizer.

        Parameters
        ----------
        n_suggestions : int
            Desired number of parallel suggestions in the output

        Returns
        -------
        next_guess : list of dict
            List of `n_suggestions` suggestions to evaluate the objective
            function. Each suggestion is a dictionary where each key
            corresponds to a parameter being optimized.
        """
        # Do whatever is needed to get the parallel guesses
        # ...
        return next_guess

    def observe(self, X, y):
        """Feed an observation back.

        Parameters
        ----------
        X : list of dict-like
            Places where the objective function has already been evaluated.
            Each suggestion is a dictionary where each key corresponds to a
            parameter being optimized.
        y : array-like, shape (n,)
            Corresponding values where objective has been evaluated
        """
        # Update the model with new objective function observations
        # ...
        # No return statement needed


if __name__ == "__main__":
    # This is the entry point for experiments, so pass the class to experiment_main to use this optimizer.
    # This statement must be included in the wrapper class file:
    experiment_main(NewOptimizerName)
```

You can replace `NewOptimizerName` with the name of your optimizer.

More details on the API can be found [here](https://bayesmark.readthedocs.io/en/latest/readme.html#id1).
Note: do not specify `kwargs` in a `config.json` for the challenge because the online evaluation will not pass any `kwargs` or use the `config.json`.

### Configuration space

The search space is defined in the `api_config` dictionary in the constructor to the optimizer (see template above).
For example, if we are optimizing the hyper-parameters for the scikit-learn neural network with ADAM `sklearn.neural_network.MLPClassifier` then we could use the following configuration for `api_config`:

```python
api_config = \
    {'hidden_layer_sizes': {'type': 'int', 'space': 'linear', 'range': (50, 200)},
     'alpha': {'type': 'real', 'space': 'log', 'range': (1e-5, 1e1)},
     'batch_size': {'type': 'int', 'space': 'linear', 'range': (10, 250)},
     'learning_rate_init': {'type': 'real', 'space': 'log', 'range': (1e-5, 1e-1)},
     'tol': {'type': 'real', 'space': 'log', 'range': (1e-5, 1e-1)},
     'validation_fraction': {'type': 'real', 'space': 'logit', 'range': (0.1, 0.9)},
     'beta_1': {'type': 'real', 'space': 'logit', 'range': (0.5, 0.99)},
     'beta_2': {'type': 'real', 'space': 'logit', 'range': (0.9, 1.0 - 1e-6)},
     'epsilon': {'type': 'real', 'space': 'log', 'range': (1e-9, 1e-6)}}
```

Each key in `api_config` is a variable to optimize and its description is itself a dictionary with the following entries:

* `type`: `{'real', 'int', 'cat', 'bool'}`
* `space`: `{'linear', 'log', 'logit', 'bilog'}`
* `values`: array-like of same data type as `type` to specify a whitelist of guesses
* `range`: `(lower, upper)` tuple to specify a range of allowed guesses

One can also make the following assumption on the configurations:

* `space` will only be specified for types `int` and `real`
* `range` will only be specified for types `int` and `real`
* We will not specify both `range` and `values`
* `bool` does not take anything extra (`space`, `range`, or `values`)
* The `values` for `cat` will be strings

For `observe`, `X` is a (length `n`) list of dictionaries with places where the objective function has already been evaluated.
Each suggestion is a dictionary where each key corresponds to a parameter being optimized.
Likewise, `y` is a length `n` list of floats of corresponding objective values.
The observations `y` can take on `inf` values if the objective function crashes, however, it should never be `nan`.

For `suggest`, `n_suggestions` is simply the desired number of parallel suggestions for each guess.
Also, `next_guess` will be a length `n_suggestions` array of dictionaries of guesses, in the same format as `X`.

## Schedule

* Submission site open to public: July 1
* Deadline for final submissions: October 15
* Announcement of winners: November 15
* Presentations, short papers, and code release from winners due: December 1
* Competition track (virtual) award ceremony: December 2020

## Terms and conditions

The terms and conditions for the challenge are available [here](https://github.com/rdturnermtl/bbo_challenge_starter_kit/files/4801454/terms_and_conditions.pdf).

## Contact

Any questions can be sent to <info@bbochallenge.com>.
