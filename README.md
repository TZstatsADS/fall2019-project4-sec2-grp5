# Project 4: Algorithm implementation and evaluation: Collaborative Filtering

### [Project Description](doc/project4_desc.md)

Term: Fall 2019

+ Team 5

+ Project title: TO BE CHANGED 

+ Team members
	+   Li, Sixuan sl4410@columbia.edu
	+   Mathew, Jess jm4742@columbia.edu
	+   Mbithe, Nicole ncm2144@columbia.edu
	+   Wu, Qiqi qw2273@columbia.edu
	+  Xiao, Lihao lx2219@columbia.edu
	
+ Project summary: 
In this project, we are going to explore matrix factorization methods for recommender system and make comparison between Stochastic Gradient Descent(SGD) and Alternating Least Squares(ALS) algorithms with same regularization and post-processing methods.

    Algorithm                   | Regularization     | Post-processing
    --------------------------- | -------------------| -------------
    Stochastic Gradient Descent | Temporal Dynamics  | KNN
     Alternating Least Squares  | Temporal Dynamics  | KNN
     
   The data we use, created by 610 users,  is achieved from [MovieLens] on September 26, 2018. These data contains 100836 ratings and 3683 tag   applications across 9742 movies between March 29, 1996 and September 24, 2018. 
   
   The project is divided into three steps:
    + Implementing Algorithm, Regularization and Parameter Tuning 
    	- SGD done by Xiao,Lihao and Wu,Qiqi using R (main.rmd)
	- ALS done by Mbithe, Nicole and Wu,Qiqi using Python (file name)
    + Postprocessing 
    	- KNN done by Sixuan,Li using Python (sl_knn_sgd.ipynb)
    + Evaluation
   

**Contribution statement**:[default] All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
