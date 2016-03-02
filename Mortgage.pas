{CS 303}
{Chris O'Brien}
{Program #1: Compare real estate options and recommend one}
program Mortgage;

const LOAN_RATE	= 0.03875;
   LOAN_TIME	= 30;
   CUR_LOAN	= 150000; {worked back from the monthly payment equation to find this}
var h1Cost, h2Cost, curCost : longInt;
   monthsLeft:  integer; {doesn't need to be big}
   h1Appr, h2Appr, h1Loan, h2Loan, h1Monthly, h2Monthly, curRate, 
   curOwed, curAppr, equity, curMonthly, curTotal, h1Total, h2Total, curProjected, 
   h1Projected, h2Projected, curNet, h1Net, h2Net : real;
   input: text; {to read from file}
   

function POWER (x:real; n: integer): real;
  {computes x to the n}
  var i: integer;
      prod: real;
  begin
      prod := 1;
      for i := 1 to n do
	prod := prod * x;
      POWER := prod;
  end; {POWER}

function COMPOUND (initial : longInt; numYears : integer; interest : real): real;
  {computes compound interest over time}
var base : real;
var exponent : integer;

begin
   base := 1 + interest;
   exponent := numYears;
   COMPOUND := initial * POWER(base, exponent);
end; {COMPOUND}

function LOANCALC (amount, interest : real; numYears : integer): real;
  {calculates monthly payment}
var base, bottom, top, monthlyInterest : real;
   numMonths : integer;

begin
   monthlyInterest := interest/12;
   base := 1 + monthlyInterest;
   numMonths := numYears*12;
   bottom := POWER(base, numMonths);
   bottom := 1/bottom;
   bottom := 1-bottom;
   top := amount*monthlyInterest;
   LOANCALC := top/bottom;
end; {LOANCALC}

begin {main}

   {INPUT}
   assign (input,'args.txt');
   reset (input);
   {write ('Enter value of Home 1: $');} {left these here to make tracing easier}
   readln (input, h1Cost);
   {write ('Enter appreciation rate of Home 1 (as a decimal): ');}
   readln (input, h1Appr);
   {write ('Enter value of Home 2: $');}
   readln (input, h2Cost);
   {write ('Enter appreciation rate of Home 2 (as a decimal): ');}
   readln (input, h2Appr);
   {write ('Enter value of current home: $');}
   readln (input, curCost);
   {write ('Enter appreciation rate of current home (as a decimal): ');}
   readln (input, curAppr);
   {write ('Enter current interest rate (as a decimal): ');}
   readln (input, curRate);
   {write ('Enter months left (currently): ');}
   readln (input, monthsLeft);
   {write ('Enter amount owed (payoff): $');}
   readln (input, curOwed);

   {CALCULATIONS}
   equity := curCost - curOwed;
   h1Loan := h1Cost - equity;
   h2Loan := h2Cost - equity;
   h1Monthly := LOANCALC (h1Loan, LOAN_RATE, LOAN_TIME);
   h2Monthly := LOANCALC (h2Loan, LOAN_RATE, LOAN_TIME);
   curMonthly := LOANCALC (CUR_LOAN, curRate, 15); {15-year loan}

   curTotal := curMonthly * monthsLeft;
   h1Total := h1Monthly * 15*12; {# months in 15 years}
   h2Total := h2Monthly * 15*12;
   curProjected := COMPOUND (curCost, 15, curAppr);
   h1Projected := COMPOUND (h1Cost, 15, h1Appr);
   h2Projected := COMPOUND (h2Cost, 15, h2Appr);
   curNet := (curProjected-curCost) - curTotal;
   h1Net := (h1Projected-h1Cost) - h1Total;
   h2Net := (h2Projected-h2Cost) - h2Total;

   {OUTPUT}
   writeln ('Results:');
   writeln ('Current equity: $', equity:0:2);
   writeln ('                        CURRENT       HOME 1      HOME 2');
   writeln ('Monthly Payment:       $', curMonthly:0:2, '     $', h1Monthly:0:2, '     $', h2Monthly:0:2);
   writeln ('Total 15-yr payment: $', curTotal:0:2, '   $', h1Total:0:2, '  $', h2Total:0:2);
   writeln ('Projected value:     $', curProjected:0:2, '  $', h1Projected:0:2, ' $', h2Projected:0:2);
   writeln ('Net equity:          $', curNet:0:2, '   $', h1Net:0:2, '  $', h2Net:0:2);
   writeln ('');
   write ('Recommendation: ');
   if (curNet > h1Net) AND (curNet > h2Net) then
      writeln ('We recommend that you stick with your current home, because it provides you with the highest net-equity over the next fifteen years.');
   if (h1Net > curNet) AND (h1Net > h2Net) then
      writeln ('We recommend that you purchase the first home because it provides you with the highest net-equity over the next fifteen years.');
   if (h2Net > curNet) AND (h2Net > h1Net) then
      writeln ('We recommend that you purchase the second home because it provides you with the highest net-equity over the next fifteen years.');
end. {MAIN}
