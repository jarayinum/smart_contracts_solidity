const SupplyChain = artifacts.require("SupplyChain");

module.exports = function (deployer) {
  deployer.deploy(SupplyChain, { gas: 2000000 });
};