* BennyBakery Profit Maximization With Two Scenarios 
Set i / roll, croissant, bread/;

Parameters
Rev(i) "--$/item-- revenue per unit sold"/ roll 2.25, croissant 5.5, bread 10/
C(i)   "--$/item-- cost per unit produced"/ roll 1.5, croissant 2, bread 5/
H(i)   "--hours/item-- time per unit sold"/ roll 1.5, croissant 2.25, bread 5/;

Scalar  Hbar "hours limit" /40/; 
parameter X_base(i),X_meal(i);
scalar profit_base, profit_meal; 
scalar sw_meal "Base=0, and roll_constraints=1" / 1 /;
* x(i) unit is item(s)
Positive Variable  X(i);   

Variable  Profit;          

Equations Obj, Hours, Meal;

*Total profit is calcuated in $
Obj..   Profit=e= sum(i,(Rev(i)- C(i)) * X(i)); 

*Total hours is calcuated in hrs
Hours.. sum(i, H(i) * X(i)) =l= Hbar;

* Counterfactual Rule:  Roll to be sold with every croissant and Rolls can still be sold individually.
Meal.. X('croissant') =l= X('roll') + (1-sw_meal) * (x('croissant') - x('roll')) ;

* Base Case Model (sw_meal=0)
Model Benny_Base / Obj, Hours, Meal /; 
Solve Benny_Base using LP maximizing Profit; 
X_base(i) = X.l(i);
Profit_base = Profit.l;
Display X.l, Profit.l; 

* Meal Case Model 
Model Benny_Meal / Obj, Hours, Meal /; 
Solve Benny_Meal using LP maximizing Profit; 
X_meal(i) = X.l(i);
Profit_meal = Profit.l;
Display X.l, Profit.l; 

$exit; 

