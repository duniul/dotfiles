let timedCounts = 0;

module.exports = {
  before: config => {
    global.benchmark = (func, times = 1) => {
      timedCounts++;
      const runTimes = [];

      for (let i = 0; i < times; i++) {
        const start = Date.now();
        func();
        const end = Date.now();
        runTimes.push(end - start);
      }

      const avgTime = runTimes.reduce((a, b) => a + b, 0) / runTimes.length;
      const totalTime = runTimes.reduce((a, b) => a + b, 0);

      console.log(
        `Execution time (test ${timedCounts}): ${avgTime}ms (avg) / ${totalTime}ms (total)`
      );
    };
  },
  beforeEach() {
    timedCounts = 0;
  },
};
