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
  
  
  # Step 1 Initialize matrix M by assigning the average rating for that movie as the first row,
  # and small random numbers for the remaining entries.
  
  #set the first row of M as the average ratings of each movie(Probably from just the training matrix)
  #get all the movie ids, #loop through the training data and for each id, sum up the ratings
  #then fivide by the count of each ID
  
  
  #Step 2 Fix M, Solve U by minimizing the objective function. Function in paper
  
  #Step 3 Fix U, solve M by minimizing the objective function similarly; 
  
  #Step 4 Repeat Steps 2 and 3 until a stopping criterion is satisfied.
  
  train_RMSE <- c()
  test_RMSE <- c()
  
  #return final U and M matrices
  #and the train and test RMSEs?
}
