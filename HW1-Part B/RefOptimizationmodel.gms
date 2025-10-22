* Refinery Optimization Model 
Scalars
P_G /92.3/
P_MD /96.7/
W /73.1/
C0 /10000/
X_cap /140000/;

Positive Variables
SG "gasoline produced (bbl/day)"
SMD "middle destillate produced (bbl/day)"
K "total refined products produced (bbl/day)";

Variables   
profit; 

Equations ktotal, capacity, MinCut, MaxCut, obj; 

ktotal.. K =e= SG +SMD; 
capacity.. K =l= X_cap;
MinCut.. SG =g= 0.3*K;
MaxCut.. SG =l=0.7*K; 

obj.. profit =e= P_G*SG+P_MD*SMD-C0-W*K; 

Model RefOptimization /all/;
Solve RefOptimization using LP maximizing profit; 
display SG.l, SMD.l, K.l,Profit.l; 
