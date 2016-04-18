# qaTest

Insert URL provided where appropriate.

### Tools
```
# standard HTTP client
curl

# to inspect HTTP response + headers
brew install httpie

# command line testing dependencies
grep
awk

# for json parsing at bash shell
brew install jq

# Python 2.7
```
### These are the various tests you strive to execute where appropriate

  * Functional aka User testing
  * Load testing - putting the system under stress
  * Integration testing - testing various related components together (e.g. service + database)
  * Performance testing - aka benchmarking
  * Security testing
  * Device testing (e.g. Desktop vs mobile)

### USAGE

`./run.sh`

* This will run through the test scripts in `test_plan.txt`.
* It will invoke the shell scripts specified within each test step, recording the output in `results.txt`.
* `chart2.sh` will be called last to generate a treemap view of the results using Google Charting engine (TODO: Bug in color coding).

### SAMPLE OUTPUT

![Sample Test Results]
(https://github.com/leonj1/qaTest/blob/master/test_results.png)

### Room for improvement
* These test scripts were written using bash shell, command line tools, and Python. Ideally, this would be written using more robust tools such as Python along with WebDriver.
* The test scripts would not only include Regression, but all other forms of testing stated above.
* The test output would also be auditable for previous executions (previous builds).
* The URL under test would not be hard coded in each of the test steps.
