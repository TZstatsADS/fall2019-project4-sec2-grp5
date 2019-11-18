#Define a function to calculate RMSE

#RMSE <- function(rating, est_rating){
  
#  sqr_err <- function(obs){
     
#    sqr_error <- (obs[3] - est_rating[as.character(obs[2]), as.character(obs[1])][[1]][as.integer(obs[5])])^2
     
#    sqr_error <- unname(sqr_error, force = FALSE)
    
#    return(sqr_error)
#  }
#  return(sqrt(mean(apply(rating, 1, sqr_err)))) 
  
  
#}


RMSE <- function(rating, est_rating){
  
  mean_RMSE = 0
  for (i in 1:dim(rating)[1]){
    sqr_error <- (rating[i,3] - est_rating[as.character(rating[i,2]), as.character(rating[i,1])][[1]][as.integer(rating[i,5])])^2
    sqr_error <- unname(sqr_error, force = FALSE)
    mean_RMSE = mean_RMSE+sqr_error
  }
  
  
  return(sqrt(mean_RMSE/dim(rating)[1]))
  
}


#Stochastic Gradient Descent
# a function returns a list containing factorized matrices p and q, training and testing RMSEs.
gradesc <- function(f , 
                    lambda,lrate = 0.01, max.iter, stopping.deriv = 0.01,
                    data, train, test){
  set.seed(0)
  
  #random assign value to matrix p and q
  p <- matrix(runif(f*U, -1, 1), ncol = U) 
  colnames(p) <- as.character(1:U)
  q <- matrix(runif(f*I, -1, 1), ncol = I)
  colnames(q) <- levels(as.factor(data$movieId))
  
  ###################
  ###################
  ## Adding:
  mu <- mean(data[,3])
  
  b_user <- matrix(runif(U, -1, 1), ncol = U)
  colnames(b_user) <- as.character(1:U)
  b_item <- as.vector(matrix(runif(I, -1, 1), ncol = 1))
  
  b_item <- matrix(runif(I, -1, 1), ncol = I)
  colnames(b_item) <- levels(as.factor(data$movieId))
  
  b_time <- matrix(runif(23*I, -1, 1), ncol = I)
  colnames(b_time) <- levels(as.factor(data$movieId))
  rownames(b_time) <- as.character(1:23)
  ###################
  ###################
  
  train_RMSE <- c()
  test_RMSE <- c()
  
  for(l in 1:max.iter){
    sample_idx <- sample(1:nrow(train), nrow(train))
    #loop through each training case and perform update
    for (s in sample_idx){
      
      u <- as.character(train[s,1])
      
      i <- as.character(train[s,2])
      
      r_ui <- train[s,3]
      
      r_t <- train[s,4]
      
      r_bin <- train[s,5]
      
      
      e_ui <- r_ui - (mu+b_user[1,u]+b_item[1,i]+b_time[r_bin,i]+t(q[,i]) %*% p[,u])
      
      grad_q <- e_ui %*% p[,u] - lambda * q[,i]
      
      if (all(abs(grad_q) > stopping.deriv, na.rm = T)){
        q[,i] <- q[,i] + lrate * grad_q
      }
      grad_p <- e_ui %*% q[,i] - lambda * p[,u]
      
      if (all(abs(grad_p) > stopping.deriv, na.rm = T)){
        p[,u] <- p[,u] + lrate * grad_p
      }
      
      ###################
      ###################
      ## Adding gradient 
      grad_b_user <- e_ui- lambda * b_user[1,u]
      
      if(all(abs(grad_b_user) > stopping.deriv, na.rm = T)){
        b_user[1,u] <- b_user[1,u] + lrate * grad_b_user
      }
      
      grad_b_item <- e_ui- lambda * b_item[1,i]
      
      if(all(abs(grad_b_item) > stopping.deriv, na.rm = T)){
        b_item[1,i] <- b_item[1,i] + lrate * grad_b_item
      }
      
      grad_b_time <- e_ui- lambda * b_time[r_bin,i]
      
      if(all(abs(grad_b_time) > stopping.deriv, na.rm = T)){
        b_time[r_bin,i] <- b_time[r_bin,i] + lrate * grad_b_time
      }
      
      ###################
      ###################
      
    }
    ## print the values of training and testing RMSE
    if (l %% 10 == 0){
      cat("epoch:", l, "\t")
      
      est_rating <- t(q) %*% p 
      
      est_rating <- est_rating  + mu + matrix(t(b_item) , length(t(b_item)) , dim(est_rating)[2] ) +matrix(b_user , dim(est_rating)[1],length(b_user),byrow=TRUE)
      
      
      ## Inclusing the time dynamicof items:
      
      dynamic_est_rating  = matrix(list(),dim(est_rating)[1] , dim(est_rating)[2])
      
      for (i in 1:dim(est_rating)[1])
        for (u in 1:dim(est_rating)[2]){
          dynamic_est_rating[i,u][[1]] = est_rating[i,u] + b_time[,i]
        }
      
      
      rownames(dynamic_est_rating) <- levels(as.factor(data$movieId))
      colnames(dynamic_est_rating) <- as.character(1:U)
      
      
      ##################
      ##################
      
      train_RMSE_cur <- RMSE(train, dynamic_est_rating)
      cat("training RMSE:", train_RMSE_cur, "\t")
      train_RMSE <- c(train_RMSE, train_RMSE_cur)
      
      test_RMSE_cur <- RMSE(test, dynamic_est_rating)
      cat("test RMSE:",test_RMSE_cur, "\n")
      test_RMSE <- c(test_RMSE, test_RMSE_cur)
    } 
  }
  
  return(list(p = p, q = q, b_user = b_user, b_item = b_item, b_time =b_time, mu = mu , train_RMSE = train_RMSE, test_RMSE = test_RMSE))
}




