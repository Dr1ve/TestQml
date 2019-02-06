mkdir _BUILD
cd _BUILD

cmake -G "Visual Studio 15 2017 Win64" ..

pause
start TestQml.sln

cd ..
