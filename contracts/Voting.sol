// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    uint public candidateCount;

    function addCandidate(string memory _name) external {
        candidateCount++;
        candidates[candidateCount] = Candidate(_name, 0);
    }

    function vote(uint _candidateId) external {
        require(!hasVoted[msg.sender], "Already voted");
        require(_candidateId <= candidateCount && _candidateId > 0, "Invalid candidate");
        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
    }
}