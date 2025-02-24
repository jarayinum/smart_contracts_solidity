const Voting = artifacts.require("Voting");

module.exports = function (deployer) {
  deployer.deploy(Voting, { gas: 4000000, overwrite: true });
};