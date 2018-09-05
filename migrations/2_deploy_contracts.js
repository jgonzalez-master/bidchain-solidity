var Factory = artifacts.require("./Factory.sol");
var Dashboard = artifacts.require("./Dashboard.sol");

module.exports = function(deployer) {
  deployer.deploy(Factory).then(() => {
    deployer.deploy(Dashboard, Factory.address)
  })
};