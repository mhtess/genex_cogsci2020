# Data files for TBT2020 cogsci

Data from each experiment can be found in its respective folder `expt1/` and `expt2/`.

- each folder has 3 raw data files
  - `genex-cogsci_expt-trials.csv`: data from the experimental trials, including the memory check trials
  - `genex-cogsci_expt-sound_check.csv`: data from the sound/attention check trial
  - `genex-cogsci_expt-participant_information.csv`: optional questionnaire data including demographic information and comments on the experiment

In addition, there are a few derivative (processed) data files, all of which had exclusion criteria already applied (participants removed who fail checks).   


- `expt2/genex-cogsci_expt1-genericOnly.csv`
  - data from the "generic only" condition of expt1 (used for plotting of expt2 results)
- `expt1/genex-cogsci_expt1-filtered.csv`
  - data after exclusion criteria were  
applied, used for modeling
- `expt2/genex-cogsci_expt2wGen-filtered.csv`
  - data after exclusion criteria were applied, used for modeling
  - includes expt2 data and data from the "generic only" condition of expt1
