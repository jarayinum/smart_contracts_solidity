const Crowdfunding = artifacts.require("Crowdfunding");

module.exports = function (deployer) {
  const goal = web3.utils.toWei("10", "ether"); // 10 ETH
  const durationInDays = 7; // 7 days

  deployer.deploy(Crowdfunding, goal, durationInDays, { gas: 3000000 });
};