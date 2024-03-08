CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area


mkdir grading-area
git clone $1 student-submission &> /dev/null
echo 'Finished cloning.'

bab=$(find student-submission | grep "ListExamples.java" | head -n 1)

echo $bab

if [[ bab != "" ]]
then
	cp TestListExamples.java grading-area
	cp $bab grading-area
	cp -r lib grading-area
else
	echo 'Missing ListExamples.java, did you forget the file or misname it?'
	exit 1
fi

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

cd grading-area
javac -cp $CPATH *.java

if [[ $? -ne 0 ]]
then
	echo "Compilation error, see error above."
	exit 1
else
	echo "Compilation successful."
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junitoutput.txt

cat junitoutput.txt | grep 'OK' > dave.txt

if [[ -s dave.txt ]]
then
	tests=$(cat dave.txt | grep -o '[0-9]\+')
	successes=$((tests))
else
	cat junitoutput.txt | tail -n 2 | head -n 1 > result.txt
	tests=$(cat result.txt | grep -o '[0-9]\+' | head -n 1)
	failures=$(cat result.txt | grep -o '[0-9]\+' | tail -n 1)
	successes=$((tests - failures))

fi
echo "Your score is $successes/$tests"
