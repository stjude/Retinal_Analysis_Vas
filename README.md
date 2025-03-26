# Retinal Analysis -  DAPI and Vasculature
Software and tools to perform Vasculature and DAPI analysis on mouse retina

This is a submodule that's part of a larger project to perform retinal analysis.

If you're interested in performing Microglia and Astrocyte analysis in addition to DAPI and Vasculature, please stay tuned
** repo soon to be released for comprehensive four pipeline retinal analysis **


## Environment and Set up

For data preparation, we use a FIJI macro. Please refer to the data preparation section for more details.

To execute the DAPI and Vasculature pipelines after data preparation, we need a python environment. The environment with dependicies can be found inside the environment.yml 

To set up the environment in conda you can run the following commands,

```
conda env create -f environment.yml
```

Activate the environment,
```
conda activate retinal_analysis
```
Once the environment is activate, the python notebooks inside 2_DAPI_Analysis and 3_Vasculature_Analysis can be executed. 

Note: To run vasculature, DAPI outputs are a prerequisite


## Data Preparation




## How to perform DAPI Analysis ?



## How to perform Vasculature Analysis ?

