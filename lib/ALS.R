#Algorithm inputs
# number of features f
# learning rate maybe?
# max iterations
# test vs train data?
# stopping criterion
##----------------------------------

ALS<-function(f = 10, data, train, test){
  # startby converting the input data into a matrix form
  U_Feat <- matrix(runif(f*U, -1, 1), ncol = U) 
  colnames(U_Feat) <- as.character(1:U) #i assume userID ranges from 1 to U
  M_Feat <- matrix(runif(f*I, -1, 1), ncol = I) #number of columns = number of movies, rows = f
  colnames(M_Feat) <- levels(as.factor(data$movieId))
  
  #set the first row of M as the average ratings of each movie
  
  train_RMSE <- c()
  test_RMSE <- c()
  
}
# startby converting the input data into a matrix form
User <- matrix(runif(f*U, -1, 1), ncol = U) 
colnames(p) <- as.character(1:U) #i assume userID ranges from 1 to U
Movie <- matrix(runif(f*I, -1, 1), ncol = I) #number of columns = number of movies, rows = f
colnames(q) <- levels(as.factor(data$movieId))

# Step 1 Initialize matrix M by assigning the average rating for that movie as the first row,
# and small random numbers for the remaining entries.


#Step 2 Fix M, Solve U by minimizing the objective function (the sum of squared errors);
#Step 3 Fix U, solve M by minimizing the objective function similarly; 
#Step 4 Repeat Steps 2 and 3 until a stopping criterion is satisfied.