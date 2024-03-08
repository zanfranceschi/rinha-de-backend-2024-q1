## Load Test Results

During the development I've stumbled on a lot of little problems that skewed my tests.

First I thought it could be me misusing I/O connections with redis or postgres, made 5 different changes in way I was handling connections, querying or saving data but no avail.

Then I find that after any tests I couldnt log to postgres, redis nor make requests in the load balancer.
Even docker showing me that there was no load on the containers the network was unresponsive.

I started searching about this and found a microsoft troubleshoot guide.

After some troubleshooting I decided that I have to run my tests on linux and proceeded to do it

Configured open jdk11 and gatling on my ubuntu distro.
Run the tests on ubuntu over wsl2, no more connectivity issues, during the tests all my containers were reachable and responsive and then my results finally started to turn green, no more timeouts as the first test results show.

## Performance

dotnet 8 using native AOT deployment showed how little and performatic it can be, it used no more than 25MB for each instance and 0.25 units of cpu was more than enough to handle this workload without problems.
This leaved more resources to other services but none of them required it. 