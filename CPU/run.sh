
set -x

cp data.in Data/data.in
cd Data
g++ -g gen.cpp -o gen
./gen
cp data.vlog ../Verilog/data.vlog
cd ..

cd Ins
g++ -g trans.cpp -o trans
./trans
cp Ins.vlog ../Verilog/Ins.vlog
cd ..

cd Verilog
iverilog -o test CPU.v EX.v IF.v Register.v Cache.v ID.v MA.v WB.v test_bench.v Memory.v
vvp -n test -lxt2
cd ..