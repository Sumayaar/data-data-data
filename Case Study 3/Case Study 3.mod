//int K = 21; // Number of customers
//range Nodes = 1..K;
//float distance[Nodes][Nodes]; // Distance matrix
// // Subtour elimination constraints
//
//   // MTZ subtour elimination constraints
//    dvar float+ u[Nodes]; // Define continuous variable for MTZ constraints
//
//// Decision Variable
//dvar boolean x[Nodes][Nodes]; // Decision variables
//
//float L[Nodes][1..2]=...; // Location matrix of sites (X&Y coordinates) //
//
//
//execute INITIALIZE {
//    // Calculating the Distance matrix using Euclidean Distance method //
//    var bigNumber = 11239444;
//
//    for (var i = 1; i <=K; i++) {         
//        for (var j = 1; j <= K; j++) {
//            if (i == j) {
//                distance[i][j] = bigNumber; // Set diagonal elements to a big number
//            } else {
//                distance[i][j] = Math.sqrt(Math.pow(L[i][1] - L[j][1], 2) + Math.pow(L[i][2] - L[j][2], 2));
//            }
//        }
//    }
//}
//
//// Objective Function
//minimize sum(i in Nodes, j in Nodes) distance[i][j] * x[i][j];
//
//// Constraints
//subject to {
//    // Constraint to ensure each house is visited exactly once
//    forall(i in Nodes) {
//        sum(j in Nodes: i!=j) x[i][j] == 1; // Each house is visited exactly once
//        sum(j in Nodes: i!=j) x[j][i] == 1; // Ensure leaving each house exactly once
//    }
//
// u[1] == 0; // Fix the starting node
////    forall(i in Nodes: i != 1)
////              u[i] >= 0;
////
//   forall(i,j in Nodes:j!=1)
//        if (i != j && i != 1 && j != 1)
//            u[i] - u[j] + K * x[i][j] <= K - 1;
//
//
//
////    // Subtour elimination constraints
////    forall(i in Nodes: i != 1) {
////        forall(j in Nodes: j != 1) {
////            if (i != j && i != 1 && j != 1) {
////                if (i != j) {
////                    x[i][j] + x[j][i] <= 1 + (K - 1) * (1 - x[i][j]);
////                }
////            }
////        }
//    }

int K = 7; // Number of customers with first as depot
range Nodes = 1..K;
float distance[Nodes][Nodes]; // Distance matrix

// MTZ subtour elimination constraints
dvar int+ u[Nodes]; // Define continuous variable for MTZ constraints

// Decision Variable
dvar boolean x[Nodes][Nodes]; // Decision variables

float L[Nodes][1..2]=...; // Location matrix of sites (X&Y coordinates) //

execute INITIALIZE {
    // Calculating the Distance matrix using Euclidean Distance method //
    for (var i = 1; i <= K; i++) {        
        for (var j = 1; j <= K; j++) {
                distance[i][j] = Math.sqrt(Math.pow(L[i][1] - L[j][1], 2) + Math.pow(L[i][2] - L[j][2], 2));
        }
    }
}

// Objective Function
minimize sum(i in Nodes, j in Nodes) distance[i][j] * x[i][j];

// Constraints
subject to {
    // Constraint to ensure each house is visited exactly once
    // Each house is entered exactly once
    forall(j in Nodes) {
        sum(i in Nodes) x[i][j] == 1;
    }
   // Ensure leaving each house exactly once
    forall(i in Nodes) {
        sum(j in Nodes) x[i][j] == 1;
    }
   //Assigning all diagonal elements in the decision variable xij matrix as ZERO
    forall(i in Nodes)
              x[i][i] == 0;
    // Fix the starting node        
    u[1] == 1;        
    
    // MTZ Subtour elimination constraints         
    forall(i in Nodes, j in Nodes: j!=1) {
        u[i] - u[j] + K * x[i][j]  <= K - 1;
  }
}