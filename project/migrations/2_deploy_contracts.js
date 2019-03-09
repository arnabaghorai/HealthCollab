var demo = artifacts.require("./demo.sol");
const hospital1 = '0xc50C6B54A3bDab0f90776D065185ad1bdaf5A853';
module.exports = function(deployer) {
  deployer.deploy(demo,hospital1 , 123);
};