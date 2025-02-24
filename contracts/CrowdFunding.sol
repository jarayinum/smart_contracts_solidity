// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public immutable creator;
    uint public immutable goal;
    uint public immutable deadline;
    uint public totalRaised;
    mapping(address => uint) public contributions;

    // Events
    event Contributed(address indexed contributor, uint amount);
    event Withdrawn(address indexed creator, uint amount);
    event RefundIssued(address indexed contributor, uint amount);

    constructor(uint _goal, uint _durationInDays) {
        require(_goal > 0, "Crowdfunding: Goal must be greater than 0");
        require(_durationInDays > 0, "Crowdfunding: Duration must be greater than 0");

        creator = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
    }

    // Function to contribute ETH to the crowdfunding campaign
    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign ended");
        require(msg.value > 0, "Contribution must be greater than 0");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;

        emit Contributed(msg.sender, msg.value);
    }

    // Function to withdraw funds if the goal is met after the deadline
    function withdraw() external {
        require(msg.sender == creator, "Only creator can withdraw");
        require(block.timestamp >= deadline, "Campaign still active");
        require(totalRaised >= goal, "Goal not met");

        uint amount = address(this).balance;
        totalRaised = 0; // Reset totalRaised before transfer (prevent reentrancy)
        
        emit Withdrawn(msg.sender, amount);
        payable(creator).transfer(amount);
    }

    // Function to allow refunds if the campaign fails
    function refund() external {
        require(block.timestamp >= deadline, "Campaign still active");
        require(totalRaised < goal, "Goal was met, no refunds");

        uint contribution = contributions[msg.sender];
        require(contribution > 0, "No contributions found");

        contributions[msg.sender] = 0;
        emit RefundIssued(msg.sender, contribution);
        payable(msg.sender).transfer(contribution);
    }

    // Function to check how much a contributor has contributed
    function getContribution(address _contributor) external view returns (uint) {
        return contributions[_contributor];
    }

    // Prevent accidental ETH transfers
    receive() external payable {
        revert("Direct ETH transfer not allowed");
    }

    fallback() external payable {
        revert("Invalid function call");
    }
}
