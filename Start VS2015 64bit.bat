mkdir _BUILD
cd _BUILD

cmake -G "Visual Studio 14 2015 Win64" ..

pause
start TestQml.sln

cd ..
