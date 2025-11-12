Sets
 i /Gasoline, MD/
  , s /s1, s2/ ; 
Scalars
X_rate "total refinery throughput in bbls/day"/140000/
C0     "fixed cost in $"/ 10000/
W      "crude oil price in $/bbl"/ 73.4/;
Scalars
*demand parameters for MCP model
pbar_d /158.63/, qbar_d /140000/ , elas_d /0.615/ ;
Parameters
* Needed to calculate intercepts and slopes
Q_AVG(i) /Gasoline 8825153, MD 3754057/
P_AVG(i) /Gasoline 138.4, MD 167.3/
Elasticity_D(i) /Gasoline -0.58, MD -0.65/
Elasticity_S(i) /Gasoline 0.1, MD 0.13/
pbar_s(s)/s1 138.4, s2 167.3/ 
qbar_s(s)/s1 42000, s2 98000 / 
elas_s(s)/s1 0.1, s2 0.13/; 
* Slopes and intercepts 
Parameters a(i), b(i), c(i), d(i);
* slope of qunatity coefficinet for demand function
b(i) = (abs(Elasticity_D(i))) *(P_AVG(i)/Q_AVG(i));
* Intercept for demand function
a(i) = P_AVG(i) + b(i)* Q_AVG(i);
* slope of qunatity coefficinet for supply function
d(i) = (Elasticity_S(i)) *(P_AVG(i)/Q_AVG(i));
* Intercept for supply function
c(i) = P_AVG(i) - d(i)* Q_AVG(i);
* Taxes Multipliers
parameter tax_supply(s), tax_demand;
tax_supply(s) = 1;
tax_demand = 1;
Variables
Profit "total profit in $"
TS "total surplus for NLP model in $"
p "market price";
Positive Variables Q(i), K, q_s(s);
Equations 
K_value, Capacity, max_cut(i), objective_LP, TS_NLP, eq_sd,  eq_zpc(s);
*LP Model part
K_value.. K=e= sum(i, Q(i));
Capacity.. K=l= X_rate;
max_cut(i).. Q(i) =l= 0.7*K;
objective_LP.. Profit =e= sum(i, (P_AVG(i)*Q(i))) - W*K- C0;
* NLP Model part
TS_NLP.. TS =e= sum(i, (a(i)*Q(i) - 0.5*b(i)*sqr(Q(i))- c(i)*Q(i) - 0.5*d(i)*sqr(Q(i)) ));
* MCP Model part
eq_sd.. sum(s,q_s(s)) =g= qbar_d * (tax_demand * p / pbar_d) ** (-1 * elas_d) ;
eq_zpc(s)..  tax_supply(s) * pbar_s(s) * (q_s(s) / qbar_s(s)) ** elas_s(s) =g= p ;
Model LPmodel /K_value, Capacity, max_cut, objective_LP/;
Model NLPmodel /K_value, Capacity, max_cut, TS_NLP/;
Model mcp_example /eq_sd.p, eq_zpc.q_s/;
* Set limits for MCP
p.lo = 0.000001;
p.up = 400;
p.l = pbar_d;
q_s.lo(s) = 0.000001;
q_s.l(s) = qbar_s(s) ;
* Solving LP Problem
Solve LPmodel using LP maximizing Profit; 
Parameters Price(i);
Price(i) = a(i) - b(i) *Q.l(i);
display Q.l, K.l, Profit.l, Price;
* Solving NLP Problem
Solve NLPmodel using NLP maximizing TS; 
Price(i) = a(i) - b(i) * Q.l(i); 
display Q.l, K.l, TS.l, Price; 
* Solving MCP (Base)
mcp_example.iterlim = 100000 ;
solve mcp_example using mcp ; 
display "Base MCP", p.l, q_s.l;
* Supply MCP with tax policy
tax_supply("s2") = 1.35 ; 
solve mcp_example using mcp ; 
display p.l, q_s.l;
execute_unload 'RefProfitMax.gdx' ; 
