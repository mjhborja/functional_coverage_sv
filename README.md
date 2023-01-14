# Covergroup Cross
As the title suggests, the focus of this review is functional coverage in SystemVerilog using the covergroup, coverpoint, cross, etc. hardware verification language (HVL) constructs in the context of simulation-based verification.

The source code uses a class object with a few class members and a coverage model. It uses a program with the following sequence:
1. Invoke the "run()" method of the "MyTest" instance in the SystemVerilog program to iterate:
2. Assigning the current value of the nested loop to the class member fields; and
3. Invoking the covergroup "sample()" method.

## Simulate & play with the code
EDA Playground Example - Covergroup Cross https://www.edaplayground.com/x/2xD8

## Additional references
[1] "IEEE Standard for SystemVerilog--Unified Hardware Design, Specification, and Verification Language," in IEEE Std 1800-2017 (Revision of IEEE Std 1800-2012), vol., no., pp.1-1315, 22 Feb. 2018, doi: 10.1109/IEEESTD.2018.8299595.

[2] D. Smith and J. Aynsley, “A Practical Look at SystemVerilog Coverage – Tips, Tricks, and Gotchas,” presented at the DVCon, United States, Mar. 2011.