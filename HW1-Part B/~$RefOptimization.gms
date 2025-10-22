* ---- Refinery mix as LP (fixed prices, linear share bounds) ----
Scalars
Pg_bar  /92.3/      
Pmd_bar /96.7/     
W       /73.4/        
C0      /10000/   
Xcap    /140000/;   
* Coefficients can be estimated later based on OLS regression to identify the relationship between prices and each indepndent variable.

Positive Variables
  SG   "gasoline (bbl/day)"
  SMD  "middle distillate (bbl/day)"
  K    "total refined product (bbl/day)";

Variables Profit;

Equations kdef, cap, cutLo, cutHi, obj;

kdef..  K =e= SG + SMD;
cap..   K =l= Xcap;
cutLo.. SG =g= 0.3*K;     
cutHi.. SG =l= 0.7*K;     
* Simply, the model with choose the highest possible cut, which is 0.7, for the most profitible product (MD in this example)
obj..   Profit =e= Pg_bar*SG + Pmd_bar*SMD - W*K - C0;

Model RefLP /kdef, cap, cutLo, cutHi, obj/;
option lp = cplex; 
Solve RefLP using LP maximizing Profit;

display SG.l, SMD.l, K.l, Profit.l;
