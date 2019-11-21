################################# ALS  #################################

#====>>> als: a function returns a list containing factorized matrices p and q, training and testing RMSEs.

als <- function(f = 10,   
                    lambda = 0.3, max.iter = 10 ,  stopping.deriv = 0.01,lrate = 0.01, 
                    data, train, test){
  
  set.seed(0)

  U = length(unique(data$userId))  
  I = length(unique(data$movieId))  
  bin_num = unique(data$bin_num)
  
  #P <- matrix(runif(f*U, -1, 1), ncol = U)  # p: 10* 610  , fill by random number between -1 and 1 
  # colnames(P) <- as.character(1:U)
  
  # initialize the P,Q and biases 
  P  =   matrix(runif(f*U,-1,1) ,ncol = U, byrow = T)
  colnames(P)  = as.character(1:U)
  
  Q <- matrix(runif(f*I,-1,1)  ,ncol = I, byrow = T)  # q：10 * 9724  fill by random number between -1 and 1 
  colnames(Q) <- levels(as.factor(data$movieId))
  
  mu <-  mean(train[,3]) # overall ratings for all movies, stationary 
  
  bu = matrix(  rep(0, U), ncol = U  )  # user bias  1*U
  colnames(bu) <- as.character(1:U)
  bi = matrix(   rep(0, I), ncol = I  )  # movie bias  1*I 
  colnames(bi) <- levels(as.factor(data$movieId))
  b_t = matrix(rep(0, 3*I ), ncol = I) #  movies rating baise in different time bin  I*23
  colnames(b_t) <- levels(as.factor(data$movieId))
  
  
  for (l in 1:max.iter) {
  
  # Step 1 Fix Q, solve P -user 
    start_time <- Sys.time()
   
   for(  u in 1:U ) {
    # u = 1 
    pu = c( bu[as.integer(u)], P[,u] )
    qi = rbind( rep(1, I) , Q) 
    colnames(qi) <- levels(as.factor(data$movieId))
    
    # Iu: set of movie js that user i rated 
    Iu =  as.character( unique( train[train[,1] ==u , 2])) 
    qIu = qi[,Iu]   
    E=diag(1,f+1,f+1)
    
    bi_bint = c() 
    
 
       bint_i_pair = cbind(Iu, train[train[,1] == u, 5  ] )
       for ( len in 1: nrow( bint_i_pair ) ) {
         bi_bint =   c( bi_bint, b_t[as.integer(bint_i_pair[len,2]), i] ) 
       }       
    
    ru  = train[train[,1] == u , 3 ] - mu 
    ru_prime = ru - bi [,Iu]  -  bi_bint
    
    # update the pu  
    pu = solve(qIu%*%t(qIu)+ lambda*E)%*%qIu%*% matrix(c( ru_prime), ncol = 1) 
    
    # update p and user bias 
    bu[,u ] = pu[1]
    P[,u] = pu[-1]
    }
  
    
    end_time <- Sys.time()
    
    print("step 1" )
    print( end_time - start_time ) 
     
   
  # Step 2 Fix P, solve Q - movie  i and bint 
   
    
 start_time <- Sys.time()
 sum  = 0 
 
  for (i in as.character( unique(data$movieId) ) ){
    sum  =  sum  + 1 
    qi =  c( as.numeric(bi[,i]) , Q[, i] )  
    pu = rbind( rep(1, U) , P) 
    colnames(pu)  = as.character(1:U)
    # Ii: set of users who rate movie i 
    Ii =  unique( train[ train[,2] ==  i , 1] )  
    pIi = pu[,Ii]
    
    E=diag(1,f+1,f+1)
    

    # ri 
    bi_bint = c() 
    ri  = train[train[,2] == i , 3] - mu
    for (bint in c( train[train[,2] == i , 5] ))  { 
        bi_bint =  c(bi_bint,b_t[bint, i] )
    } 
    ri_prime = ri - bu [,Ii] -  bi_bint

    # update the qi
    qi = solve(pIi%*%t(pIi)+ lambda*E)%*%pIi%*% matrix( c(ri_prime) , ncol = 1) 
    bi[,i ] = qi[1]
    Q[,i] = qi[-1]
  }
 
 end_time <- Sys.time()
 
 print("step 2" )
 print( end_time - start_time ) 
 
 
 # Step 3  Fix time t 
 start_time <- Sys.time()
 
    for ( bint in 1:length(unique(train$bin_num))) {
    for (i in  as.character( unique(data$movieId))) {  
    list_u = unique(  train[ train[,5] == bint & train[,2] == i , 1])
    
    num=  sum( train[ train[,5] == bint & train[,2] == i , 3]  -   mu  - bu[,list_u] - bi[,i ] - t(P[,list_u])%*% Q[,i] )
    denom = nrow(train[ train[,5] == bint & train[,2] == i , ] ) +lambda 
    b_t[bint, i] = num/denom
    } 
     }
 
 end_time <- Sys.time()
 
 print("step 3" )
 print( end_time - start_time ) 
 
  
  }
  
} 


 