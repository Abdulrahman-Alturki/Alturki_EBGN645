* Jellybean factory optimization with two machines (X1 and X2) and five different types.

Set b "beans/colors" /yellow, blue, green, orange, purple /;
Set m "machines" / x1,x2 /;
alias (b,bb);

Parameters 

Rev(b)    "--$/item-- revenue per unit sold"/ yellow 1, blue 1.05, green 1.07, orange 0.95, purple 0.90/;

Scalars 
rate         "--quantity/machines/hour-- production rate/hour/machine"/ 100 /
hours        "--hours/week-- total hours per week"/ 40 /
Capacity     "--quantity/week-- weekly production rate"
Threshold   "allowed deviation" / 0.05 /;
Capacity = rate * hours * 2;
* Capacity is multiplied by 2 because we have 2 machines
Positive Variables y(b); 
* z unit is $ as it shows the total profit
Variable z;

equations 

Objective, CapConstraint,
eq_prodlimit_upper(b,bb),
eq_prodlimit_lower(b,bb);
* Part a
Objective..   z=e= sum(b, Rev(b) * y(b));
CapConstraint.. sum(b, Y(b)) =l= Capacity;

* Part b "No Constraints"
model Base / Objective, CapConstraint /;
solve Base using lp maximizing z;
display z.l,y.l;

*Part c "Allowed Deviation of 5% Between Colors" 
eq_prodlimit_lower(b,bb).. y(b) =g= (1-Threshold)*y(bb);
eq_prodlimit_upper(b,bb).. y(b) =l= (1+Threshold)*y(bb);
* The highest quantity should be allocated to the most profitible color and the lowest quantity for the least profitible, in which the difference between them should not exceed the 5%;
model deviation_constraint / Objective, CapConstraint, eq_prodlimit_lower, eq_prodlimit_upper /;
solve deviation_constraint using lp maximizing z;
display z.l, y.l;
* Normally we notice drop in profit due to imposing this constraint 

* Part d

* x1 allows yellow, blue, and green, while x2 allows yellow, orange, and purple; 
Set m_b(m,b);
m_b("x1", "yellow") = yes; 
m_b("x1", "blue") = yes; 
m_b("x1", "green") = yes;
m_b("x2", "yellow") = yes;
m_b("x2", "orange") = yes;
m_b("x2", "purple") = yes;

Parameter partdcapacity(m);
partdcapacity(m) = 4000; 
Positive Variable Q(m,b);
equations 
Objective_d
Capacity_d(m)
Totalbeans_d(b);
* Each machine shall pick the highest reveneu and producing 4000 items, then we take the summation of both machines 

*Having 4000 beans maximum for each machine by choosing the most profitible color
capacity_d(m).. sum(b$ m_b(m,b), Q(m,b)) =e= partdcapacity(m);

* Calculating the total number of beans by both machines
Totalbeans_d(b).. y(b) =e= sum(m$ m_b(m,b), Q(m,b));

Objective_d..  z=e= sum((m,b)$m_b(m,b), Rev(b)*Q(m,b));

model PartD / Objective_d, capacity_d, Totalbeans_d /;
solve partD using lp maximizing z;
display z.l, y.l,Q.l; 
$exit; 

