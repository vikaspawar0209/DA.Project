use bank_analytics;

select * from finance_18;
select * from finance_21;

----- 1 (YEAR WISE LOAN AMOUNT STATS) ------

SELECT YEAR(issue_d) AS loan_year,
       COUNT(*) AS total_loans,
       SUM(loan_amnt) AS total_loan_amount,
       AVG(loan_amnt) AS average_loan_amount,
       MAX(loan_amnt) AS max_loan_amount,
       MIN(loan_amnt) AS min_loan_amount
FROM finance_18
GROUP BY loan_year
ORDER BY loan_year;


----- 2 (GRADE AND SUB GRADE WISE REVOL_BAL) ------

select grade, sub_grade,sum(revol_bal) as total_revol_bal
from finance_18 B1 inner join finance_21 B2 
on(B1.id = B2.id) 
group by grade,sub_grade
order by grade;


----- 3 (Total Payment for Verified Status Vs Total Payment for Non Verified Status) -----
select verification_status, round(sum(total_pymnt),2) as Total_payment
from finance_18 B1 inner join finance_21 B2 
on(B1.id = B2.id) 
where verification_status in('Verified', 'Not Verified')
group by verification_status;


----- 4 (State wise and month wise loan status) -----
select addr_state, last_credit_pull_d ,loan_status
from finance_18 B1 inner join finance_21 B2 
on(B1.id = B2.id) 
group by addr_state, last_credit_pull_d,loan_status
order by addr_state;


----- 5 (Home ownership Vs last payment date stats) -----
select home_ownership, last_pymnt_d as last_payment_date, sum(last_pymnt_amnt)
from finance_18 B1 inner join finance_21 B2 
on(B1.id = B2.id) 
where last_pymnt_d in(select max(STR_TO_DATE(B2.last_pymnt_d,'%d/%m/%Y')) from finance_21)
group by  last_pymnt_d,home_ownership
having sum(last_pymnt_amnt) =
(	Select sum(last_pymnt_amnt)
	from finance_21 B2 join finance_18 B1
    on(B1.id=B2.id)
    group by last_pymnt_d, home_ownership
);


Select last_pymnt_d,sum(last_pymnt_amnt) ,home_ownership
	from finance_21 B2 join finance_18 B1
    on(B1.id=B2.id)
    group by  last_pymnt_d,home_ownership 
    order by last_pymnt_d desc;